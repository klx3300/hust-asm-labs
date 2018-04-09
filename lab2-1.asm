.386
include zhwklib.inc
stack segment use16 stack
    db 500 dup(0)
stack ends

buymultiplier equ 999

data segment use16
time_cons_hint db ' ms consumed.',10,0
time_set_failed db 'setup timer failed.',10,0
in_user_hint db 'Please Input User Name:',0
in_pass_hint db 'Please Input Password:',0
in_good_hint db 'Please Input Good Name:',0
incorrect_hint db 'Username and Password Mismatch!',10,0
correct_hint db 'Authentication Succeed!',10,0
guest_hint db 'You are in Purchase Mode!',10,0
bought_hint db 'You have successfully purchased x1000!',10,0
out_stock_hint db 'The good is out of stock!',10,0
good_not_exist_hint db 'The good you ask is not exist!',10,0
price_hint db 'Current Price: ',0
stock_hint db 'Current Stock: ',0
stock_hint_suffix db ' pcs.',0
profit_pctg_suffix db '%',0
profit_rank_hint db 'Rank: ',0
quit_str db 'q',0
username db 'Huatian Zhou',0
password db 'testpasswd',0
maxgoods equ 10
shop1name db 'shop1',0
shop1goods db 'pen',0
dw 35,56,70,25,0
db 'book',0
dw 12,30,25,5,0
db 'bag',0
dw 1,2,2000,500,0
shop1topgoods db maxgoods-3 dup('Invalid Items',0,15,0,20,0,30,0,0,0,0,0)
shop2name db 'shop2',0
shop2goods db 'pen',0
dw 12,28,20,15,0
db 'book',0
dw 35,50,30,24,0
db 'bag',0
dw 32,47,19,14,0
shop2topgoods db maxgoods-3 dup('Invalid Items',0,15,0,20,0,30,0,0,0,0,0)
in_name db 50 dup(0)
in_passwd db 50 dup(0)
in_good db 50 dup(0)
auth db 0
pr1 dw 0
pr2 dw 0
avgpr dw 0
data ends

code segment para public use16
    assume cs:code,ds:data,ss:stack
    jmp begin
begin:
    ; init ds: masm is buggy while doing this!
    mov ax,data
    mov ds,ax
restart_auth:
    @strprint <offset in_user_hint>
    @gets <offset in_name>
    @strlen <offset in_name>
    cmp ax,0
    jz guest_mode
    @strfcmp <offset quit_str>, <offset in_name>
    cmp ax,0
    jz quit
    @strprint <offset in_pass_hint>
    @gets <offset in_passwd>
    @strfcmp <offset username>, <offset in_name>
    cmp ax,0
    jnz auth_failed
    @strfcmp <offset password>, <offset in_passwd>
    cmp ax,0
    jnz auth_failed
    ; auth succeed!
    mov byte ptr[auth],1
    @strprint <offset correct_hint>
    jmp query_goods
auth_failed:
    @strprint <offset incorrect_hint>
    jmp restart_auth
guest_mode:
    @strprint <offset guest_hint>
    mov byte ptr[auth],0
query_goods:
    @strprint <offset in_good_hint>
    @gets <offset in_good>
    @strlen <offset in_good>
    cmp ax,0
    jz restart_auth
    call disptime
    mov dx,0
retry_purch:
    lea bx,offset shop1goods
shop1_search_loop:
    cmp bx,offset shop1topgoods
    jz shop1_not_found
    @strfcmp <offset in_good>, <bx>
    cmp ax,0
    jz shop1_found
    @strlen <bx>
    add bx,ax
    inc bx
    add bx,10
    jmp shop1_search_loop
shop1_not_found:
    @strprint <offset good_not_exist_hint>
    jmp query_goods
shop1_found:
    ;@strprint <bx>
    @strlen <bx>
    ;@newln
    ;@strprint <offset price_hint>
    add bx,ax
    inc bx
    mov al,byte ptr[auth]
    cmp al,0
    jnz admin_mode
    mov cx,word ptr[bx+2]
    ;@printword <cx>
    ;@newln
    ;@strprint <offset stock_hint>
    mov cx,word ptr[bx+4]
    mov ax,word ptr[bx+6]
    sub cx,ax
    ;@printword <cx>
    ;@strprint <offset stock_hint_suffix>
    cmp cx,0
    jg continue_purch
    ;@strprint <offset out_stock_hint>
    jmp query_goods
    ;@newln
continue_purch:
    ;@newln
    add word ptr[bx+6],1
admin_mode:
    call recalc_profit
    mov si,bx
    lea bx,offset shop2goods
shop2_search_loop:
    cmp bx,offset shop2topgoods
    jz shop2_not_found
    @strfcmp <offset in_good>, <bx>
    cmp ax,0
    jz shop2_found
    @strlen <bx>
    add bx,ax
    inc bx
    add bx,10
    jmp shop2_search_loop
shop2_not_found:
    @strprint <offset good_not_exist_hint>
    jmp query_goods
shop2_found:
    @strlen <bx>
    add bx,ax
    inc bx
    call recalc_profit
    mov al,byte ptr[auth]
    cmp al,0
    jnz admin_mode_cont
    cmp dx,buymultiplier
    jz final_bought
    inc dx
    jmp retry_purch
final_bought:
    @strprint <offset bought_hint>
    call disptime
    jmp query_goods
admin_mode_cont:
    mov di,bx
    call calc_avg
    mov ax,word ptr[avgpr]
    @printword <ax>
    @strprint <offset profit_pctg_suffix>
    @newln
    @strprint <offset profit_rank_hint>
    cmp ax,90
    jge class_a
    cmp ax,50
    jge class_b
    cmp ax,20
    jge class_c
    cmp ax,0
    jge class_d
    mov dl,'F'
    mov ah,02H
    int 21H
    @newln
    jmp query_goods
class_a:
    mov dl,'A'
    mov ah,02H
    int 21H
    @newln
    jmp query_goods
class_b:
    mov dl,'B'
    mov ah,02H
    int 21H
    @newln
    jmp query_goods
class_c:
    mov dl,'C'
    mov ah,02H
    int 21H
    @newln
    jmp query_goods
class_d:
    mov dl,'D'
    mov ah,02H
    int 21H
    @newln
    jmp query_goods
quit:
    @ex

recalc_profit proc ; the starter in bx
    pusha
    mov ax,word ptr[bx+2]
    mov cx,word ptr[bx+6]
    imul cx
    mov si,ax
    mov ax,word ptr[bx]
    mov cx,word ptr[bx+4]
    imul cx
    sub si,ax
    mov ax,si
    mov cx,100
    imul cx
    push dx
    mov si,ax
    mov ax,word ptr[bx]
    mov cx,word ptr[bx+4]
    imul cx
    mov cx,ax
    mov ax,si
    pop dx
    idiv cx
    mov word ptr[bx+8],ax
    popa
    ret
recalc_profit endp
calc_avg proc ; shop1 in si, shop2 in di
    pusha
    mov bx,si
    mov cx,word ptr[bx+8]
    mov bx,di
    mov ax,word ptr[bx+8]
    add ax,cx
    cwd
    mov cx,2
    idiv cx
    mov word ptr[avgpr],ax
    popa
    ret
calc_avg endp

disptime proc
    local timestr[8]:byte
    push cx
    push dx         
    push ds
    push ss
    pop  ds
    mov  ah,2ch 
    int  21h
    xor  ax,ax
    mov  al,dh
    mov  cl,10
    div  cl
    add  ax,3030h
    mov  word ptr timestr,ax
    mov  timestr+2,'"'
    xor  ax,ax
    mov  al,dl
    div  cl
    add  ax,3030h
    mov  word ptr timestr+3,ax
    mov  word ptr timestr+5,0a0dh
    mov  timestr+7,'$'    
    lea  dx,timestr  
    mov  ah,9
    int  21h    
    pop  ds 
    pop  dx
    pop  cx
    ret
disptime	endp

code ends
end begin

