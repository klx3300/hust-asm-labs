.386
stack segment use16 stack
    db 500 dup(0)
stack ends

data segment use16
in_user_hint db 'Please Input User Name:',0
in_pass_hint db 'Please Input Password:',0
in_good_hint db 'Please Input Good Name:',0
incorrect_hint db 'Username and Password Mismatch!',10,0
correct_hint db 'Authentication Succeed!',10,0
guest_hint db 'You are in Guest Mode!',10,0
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
shop1topgoods db maxgoods-2 dup('Invalid Items',0,15,0,20,0,30,0,0,0,0,0)
shop2name db 'shop2',0
shop2goods db 'pen',0
dw 12,28,20,15,0
db 'book',0
dw 35,50,30,24,0
shop2topgoods db maxgoods-2 dup('Invalid Items',0,15,0,20,0,30,0,0,0,0,0)
in_name db 50 dup(0)
in_passwd db 50 dup(0)
in_good db 50 dup(0)
auth db 0
pr1 dw 0
pr2 dw 0
avgpr dw 0
data ends

extern qmemset:near
extern qmemcpy:near
extern qstrlen:near
extern qstrcmp:near
extern qstrfcmp:near
extern qstrprint:near
extern qprintword:near
extern qfmtprint:near
extern qgets:near
extern exit:near
extern newline:near

code segment para public use16
    assume cs:code,ds:data,ss:stack
    jmp begin
begin:
    ; init ds: masm is buggy while doing this!
    mov ax,data
    mov ds,ax
restart_auth:
    push offset in_user_hint
    call near ptr qstrprint
    sub sp,-2
    push offset in_name
    call near ptr qgets
    call near ptr qstrlen
    cmp ax,0
    jz guest_mode
    sub sp,-2
    push offset in_name
    push offset quit_str
    call near ptr qstrfcmp
    sub sp,-4
    cmp ax,0
    jz quit
    push offset in_pass_hint
    call near ptr qstrprint
    sub sp,-2
    push offset in_passwd
    call near ptr qgets
    sub sp,-2
    push offset in_name
    push offset username
    call near ptr qstrfcmp
    sub sp,-4
    cmp ax,0
    jnz auth_failed
    push offset in_passwd
    push offset password
    call near ptr qstrfcmp
    sub sp,-4
    cmp ax,0
    jnz auth_failed
    ; auth succeed!
    mov byte ptr[auth],1
    push offset correct_hint
    call near ptr qstrprint
    sub sp,-2
    jmp query_goods
auth_failed:
    push offset incorrect_hint
    call near ptr qstrprint
    sub sp,-2
    jmp restart_auth
guest_mode:
    push offset guest_hint
    call near ptr qstrprint
    sub sp,-2
    mov byte ptr[auth],0
query_goods:
    push offset in_good_hint
    call near ptr qstrprint
    sub sp,-2
    push offset in_good
    call near ptr qgets
    call near ptr qstrlen
    sub sp,-2
    cmp ax,0
    jz restart_auth
    lea bx,offset shop1goods
shop1_search_loop:
    cmp bx,offset shop1topgoods
    jz shop1_not_found
    push bx
    push offset in_good
    call near ptr qstrfcmp
    sub sp,-4
    cmp ax,0
    jz shop1_found
    push bx
    call near ptr qstrlen
    sub sp,-2
    add bx,ax
    inc bx
    add bx,10
    jmp shop1_search_loop
shop1_not_found:
    push offset good_not_exist_hint
    call near ptr qstrprint
    sub sp,-2
    jmp query_goods
shop1_found:
    mov al,byte ptr[auth]
    cmp al,0
    jnz admin_mode
    push bx
    call near ptr qstrprint
    call near ptr qstrlen
    sub sp,-2
    call near ptr newline
    push offset price_hint
    call near ptr qstrprint
    sub sp,-2
    add bx,ax
    inc bx
    mov cx,word ptr[bx+2]
    push cx
    call near ptr qprintword
    sub sp,-2
    call near ptr newline
    push offset stock_hint
    call near ptr qstrprint
    sub sp,-2
    mov cx,word ptr[bx+4]
    mov dx,word ptr[bx+6]
    sub cx,dx
    push cx
    call near ptr qprintword
    sub sp,-2
    push offset stock_hint_suffix
    call near ptr qstrprint
    sub sp,-2
    call near ptr newline
    jmp query_goods
admin_mode:
    push bx
    call near ptr qstrlen
    sub sp,-2
    add bx,ax
    inc bx
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
    mov word ptr[pr1],ax
    lea bx,offset shop2goods
shop2_search_loop:
    cmp bx,offset shop2topgoods
    jz shop2_not_found
    push bx
    push offset in_good
    call near ptr qstrfcmp
    sub sp,-4
    cmp ax,0
    jz shop2_found
    push bx
    call near ptr qstrlen
    sub sp,-2
    add bx,ax
    inc bx
    add bx,10
    jmp shop2_search_loop
shop2_not_found:
    push offset good_not_exist_hint
    call near ptr qstrprint
    sub sp,-2
    jmp query_goods
shop2_found:
    mov al,byte ptr[auth]
    cmp al,0
    jnz admin_mode_continue
    push bx
    call near ptr qstrprint
    sub sp,-2
    jmp query_goods
admin_mode_continue:
    push bx
    call near ptr qstrlen
    sub sp,-2
    add bx,ax
    inc bx
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
    mov word ptr[pr2],ax
    mov cx,word ptr[pr1]
    add ax,cx
    cwd
    mov cx,2
    idiv cx
    mov word ptr[avgpr],ax
    push ax
    call near ptr qprintword
    sub sp,-2
    push offset profit_pctg_suffix
    call near ptr qstrprint
    sub sp,-2
    call near ptr newline
    push offset profit_rank_hint
    call near ptr qstrprint
    sub sp,-2
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
    call near ptr newline
    jmp query_goods
class_a:
    mov dl,'A'
    mov ah,02H
    int 21H
    call near ptr newline
    jmp query_goods
class_b:
    mov dl,'B'
    mov ah,02H
    int 21H
    call near ptr newline
    jmp query_goods
class_c:
    mov dl,'C'
    mov ah,02H
    int 21H
    call near ptr newline
    jmp query_goods
class_d:
    mov dl,'D'
    mov ah,02H
    int 21H
    call near ptr newline
    jmp query_goods
quit:
    call near ptr exit
    
code ends
end begin

