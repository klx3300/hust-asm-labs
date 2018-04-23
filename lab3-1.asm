.386
include zhwklib.inc
stack segment use16 stack
    db 500 dup(0)
stack ends

data segment use16
not_impl_hint db 'Not implemented yet.',10,0
in_user_hint db 'Please Input User Name:',0
in_pass_hint db 'Please Input Password:',0
in_good_hint db 'Please Input Good Name:',0
in_shop_hint db 'Please Input Shop Name:',0
incorrect_hint db 'Username and Password Mismatch!',10,0
correct_hint db 'Authentication Succeed!',10,0
guest_hint db 'You are in Guest Mode!',10,0
admin_hint db 'You are in Administrator Mode!',10,0
query_hint db '1. Query Goods',10,0
modify_hint db '2. Modify Goods',10,0
calcavg_hint db '3. Calculate Average Profit Rate',10,0
calcrank_hint db '4. Calculate Profit Rate Rank',10,0
printall_hint db '5. Print All Goods',10,0
quit_hint db '6. Quit System',10,0
select_hint db 'Please select: (opcode)> ',0
select_invalid_hint db 'Invalid selection.',10,0
perm_denied_hint db 'Permission Denied!',10,0
good_not_exist_hint db 'The good you ask is not exist!',10,0
shop_not_exist_hint db 'The shop you ask is not exist!',10,0
query_result_hint db 'shopname, itemname, price, stock, sold',10,0
query_result_split db ', ',0
attr_inprice db 'Instock Price: ',0
attr_sellprice db 'Selling Price: ',0
attr_stock db 'Stock: ',0
modify_input_hint db ' => ',0
quit_str db 'q',0
username db 'Huatian Zhou',0
password db 'testpasswd',0
maxgoods equ 10
print_goods_header db 'name',9,'cost',9,'price',9,'in_cnt',9,'out_cnt',0
print_goods_header_2 db 'name',9,'profit%',9,'rank',0
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
in_buffer db 50 dup(0)
auth db 0
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
    jz quit_prog
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
    jmp user_menu
auth_failed:
    @strprint <offset incorrect_hint>
    jmp restart_auth
guest_mode:
    @strprint <offset guest_hint>
    mov byte ptr[auth],0
user_menu:
    @strprint <offset query_hint>
    cmp byte ptr[auth],0
    je guest_skip
    @strprint <offset modify_hint>
    @strprint <offset calcavg_hint>
    @strprint <offset calcrank_hint>
    @strprint <offset printall_hint>
guest_skip:
    @strprint <offset quit_hint>
    @strprint <offset select_hint>
    @gets <offset in_buffer>
    @strlen <offset in_buffer>
    cmp ax,0
    jz selection_invalid
    @strtoword <offset in_buffer>
    cmp ax,0
    jnz selection_invalid
    pop ax
    cmp ax,1
    je query_goods
    cmp ax,2
    je modify_goods
    cmp ax,3
    je calc_avg
    cmp ax,4
    je calc_rank
    cmp ax,5
    je print_all
    cmp ax,6
    je restart_auth
selection_invalid:
    @strprint <offset select_invalid_hint>
    jmp user_menu
query_goods:
    @strprint <offset in_good_hint>
    @gets <offset in_good>
    @strlen <offset in_good>
    cmp ax,0
    jz user_menu
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
    @strprint <offset query_result_hint>
    @strprint <offset shop1name>
    @strprint <offset query_result_split>
    @strprint <bx>
    @strprint <offset query_result_split>
    @strlen <bx>
    add bx,ax
    inc bx
    mov cx,word ptr[bx+2]
    @printword <cx>
    @strprint <offset query_result_split>
    mov cx,word ptr[bx+4]
    @printword <cx>
    @strprint <offset query_result_split>
    mov cx,word ptr[bx+6]
    @printword <cx>
    @strprint <offset query_result_split>
    @newln
    mov bx,offset shop2goods
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
    @strprint <offset shop2name>
    @strprint <offset query_result_split>
    @strprint <bx>
    @strprint <offset query_result_split>
    @strlen <bx>
    add bx,ax
    inc bx
    mov cx,word ptr[bx+2]
    @printword <cx>
    @strprint <offset query_result_split>
    mov cx,word ptr[bx+4]
    @printword <cx>
    @strprint <offset query_result_split>
    mov cx,word ptr[bx+6]
    @printword <cx>
    @strprint <offset query_result_split>
    @newln
    jmp query_goods
modify_goods:
    ; permission checks
    cmp byte ptr[auth],0
    jnz modify_goods_passed
    @strprint <offset perm_denied_hint>
    jmp user_menu
modify_goods_passed:
    @strprint <offset in_shop_hint>
    @gets <offset in_buffer>
    @strlen <offset in_buffer>
    cmp ax,0
    je user_menu
    @strfcmp <offset in_buffer>,<offset shop1name>
    cmp ax,0
    jne mg_try_shop2
    mov bx,offset shop1goods
    mov cx,offset shop1topgoods
    jmp mg_get_goodname
mg_try_shop2:
    @strfcmp <offset in_buffer>,<offset shop2name>
    cmp ax,0
    jne mg_shop_notfound
    mov bx,offset shop2goods
    mov cx,offset shop2topgoods
    jmp mg_get_goodname
mg_shop_notfound:
    @strprint <offset shop_not_exist_hint>
    jmp modify_goods
mg_get_goodname:
    @strprint <offset in_good_hint>
    @gets <offset in_good>
    @strlen <offset in_good>
    cmp ax,0
    je modify_goods
mg_search_loop:
    cmp bx,cx
    jz mg_not_found
    @strfcmp <offset in_good>, <bx>
    cmp ax,0
    jz mg_found
    @strlen <bx>
    add bx,ax
    inc bx
    add bx,10
    jmp mg_search_loop
mg_not_found:
    @strprint <offset good_not_exist_hint>
    jmp modify_goods
mg_found:
    @strlen <bx>
    add bx,ax
    inc bx
mod_attr_inprice:
    @strprint <offset attr_inprice>
    mov dx,word ptr[bx]
    @printword <dx>
    @strprint <offset modify_input_hint>
    @gets <offset in_buffer>
    @newln
    @strlen <offset in_buffer>
    cmp ax,0
    je mod_attr_sellprice
    @strtoword <offset in_buffer>
    cmp ax,0
    jne mod_attr_inprice_fail
    pop ax
    mov word ptr[bx],ax
mod_attr_sellprice:
    @strprint <offset attr_sellprice>
    mov dx,word ptr[bx+2]
    @printword <dx>
    @strprint <offset modify_input_hint>
    @gets <offset in_buffer>
    @newln
    @strlen <offset in_buffer>
    cmp ax,0
    je mod_attr_stock
    @strtoword <offset in_buffer>
    cmp ax,0
    jne mod_attr_sellprice_fail
    pop ax
    mov word ptr[bx+2],ax
mod_attr_stock:
    @strprint <offset attr_stock>
    mov dx,word ptr[bx+4]
    @printword <dx>
    @strprint <offset modify_input_hint>
    @gets <offset in_buffer>
    @newln
    @strlen <offset in_buffer>
    cmp ax,0
    je mod_attr_end
    @strtoword <offset in_buffer>
    cmp ax,0
    jne mod_attr_stock_fail
    pop ax
    mov word ptr[bx+4],ax
mod_attr_end:
    jmp user_menu
mod_attr_inprice_fail:
    @clstk 2
    jmp mod_attr_inprice
mod_attr_sellprice_fail:
    @clstk 2
    jmp mod_attr_sellprice
mod_attr_stock_fail:
    @clstk 2
    jmp mod_attr_stock
calc_avg:
    cmp byte ptr[auth],0
    jnz calc_avg_passed
    @strprint <offset perm_denied_hint>
    jmp user_menu
calc_avg_passed:
    ; @strprint <offset not_impl_hint>
    ; loop init
    mov ebx, offset shop1goods
    cmp ebx, offset shop1topgoods
    je user_menu
calc_avg_passed_loop: ; start of the loop
    @strlen <bx>
    add bx, ax
    inc bx

    mov ax, [ebx] ; cost
    mov dx, [ebx+4] ; in count
    mul dx

    ; store result in ecx
    mov cx, dx
    shl ecx, 10h
    mov cx, ax
    ; revenue
    mov ax, [ebx+2] ; price
    mov dx, [ebx+6] ; sold count
    mul dx
    ; store result in edx
    shl edx, 10h
    mov dx, ax

    mov eax, edx
    sub     eax, ecx ; profit
    mov     edx, 100
    imul    edx      ; profit * 100

    idiv ecx

    mov si, ax
    ; shop 2
    mov edi, ebx
    sub ebx, offset shop1goods
    lea ebx, shop2goods[ebx]

    mov ax, [ebx] ; cost
    mov dx, [ebx+4] ; in count
    mul dx

    ; store result in ecx
    mov cx, dx
    shl ecx, 10h
    mov cx, ax
    ; revenue
    mov ax, [ebx+2] ; price
    mov dx, [ebx+6] ; sold count
    mul dx
    ; store result in edx
    shl edx, 10h
    mov dx, ax

    mov eax, edx
    sub     eax, ecx ; profit
    mov     edx, 100
    imul    edx      ; profit * 100

    idiv ecx

    add ax, si

    test ax, ax
    js calc_avg_passed_loop_neg_div

    shr ax, 1
    jmp calc_avg_passed_loop_avg_done
calc_avg_passed_loop_neg_div:
    inc ax
    sar ax, 1

calc_avg_passed_loop_avg_done:
    mov ebx, edi
    mov [ebx+8], ax ; store

    ; increment
    add ebx, 10
    ; check condition
    cmp ebx, offset shop1topgoods
    jne calc_avg_passed_loop

    jmp user_menu

goods_sort proc
    ; loop init
    push bp
    mov bp, sp

    mov bx, offset shop2goods
    cmp bx, offset shop2topgoods
    jne @F
    ret

@@:
    xor cx, cx
@@:
    push bx
    inc cx
    inc cx
    @strlen <bx>
    add bx, ax

    add bx, 0bh
    cmp bx, offset shop2topgoods
    jne @B

    xor edi, edi
    xor esi, esi
    mov di, sp
    mov si, sp
    add si, cx

    push cx

    call goods_qsort_recur

    xor ecx, ecx
    pop cx
    shr cx, 1
@@:
    xor ebx, ebx
    mov bx, [esp+ecx*2-2]
    @strlen <bx>
    add bx, ax
    inc bx
    mov [ebx+8], cx
    loop @B
    
    ; free
    mov sp, bp
    pop bp
    ret
goods_sort endp

goods_qsort_recur proc
    push ebx
    ; beg in edi, end in esi

    ; base condition
    mov eax, esi
    sub eax, edi
    cmp eax, 2
    jg @F
    pop ebx
    ret
@@:

    xor ecx, ecx
    mov cx, ss:[esi-2] ; pivot pointer
    @strlen <cx>
    add cx, ax
    inc cx
    add cx, 8
    mov cx, (shop1goods-shop2goods)[ecx] ; pivot

    mov eax, edi ; end of > zone
    mov ebx, eax ; end of <= zone

    push edi ; store beg
@l1:
    ; compare
    xor edx, edx
    mov dx, ss:[ebx]

    mov edi, eax

    @strlen <dx>
    add dx, ax
    add dx, 9 ; curr pointer

    mov eax, edi

    cmp (shop1goods-shop2goods)[edx], cx
    jle @F
    ; swap
    mov dx, ss:[ebx]
    mov di, ss:[eax]
    mov ss:[eax], dx
    mov ss:[ebx], di
    add eax, 2
@@:
    add ebx, 2

    cmp ebx, esi
    jne @l1

    ; move pivot
    mov bx, ss:[eax]
    mov dx, ss:[esi-2]
    mov ss:[eax], dx
    mov ss:[esi-2], bx

    pop edi
    push eax
    push esi
    mov esi, eax
    call goods_qsort_recur
    pop esi
    pop edi
    add edi, 2
    call goods_qsort_recur

    pop ebx
    ret
goods_qsort_recur endp

calc_rank:
    cmp byte ptr[auth],0
    jnz calc_rank_passed
    @strprint <offset perm_denied_hint>
    jmp user_menu
calc_rank_passed:
    ; @strprint <offset not_impl_hint>
    call goods_sort
    jmp user_menu

print_ht macro
    mov ah, 02h
    mov dl, 09h
    int 21h
endm

print_cr_lf macro
    mov ah, 02h
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h
endm

print_goods proc
    ; parameter in edix
    test edi, edi
    jnz @l1
    @strprint <offset shop1name>
    print_cr_lf
    @strprint <offset print_goods_header>
    print_cr_lf
    mov bx, offset shop1goods
    cmp bx, offset shop1topgoods
    je @l2
@l3:
    @strprint <bx>
    print_ht
    @strlen <bx>
    add bx, ax
    inc bx
    @printword <word ptr [bx]>
    print_ht
    @printword <word ptr [bx+2]>
    print_ht
    @printword <word ptr [bx+4]>
    print_ht
    @printword <word ptr [bx+6]>
    print_cr_lf
    add bx, 0ah
    cmp bx, offset shop1topgoods
    jne @l3

    print_cr_lf
@l2:
    @strprint <offset shop2name>
    print_cr_lf
    @strprint <offset print_goods_header>
    print_cr_lf
    mov bx, offset shop2goods
    cmp bx, offset shop2topgoods
    je @l4
@l5:
    @strprint <bx>
    print_ht
    @strlen <bx>
    add bx, ax
    inc bx
    @printword <word ptr [bx]>
    print_ht
    @printword <word ptr [bx+2]>
    print_ht
    @printword <word ptr [bx+4]>
    print_ht
    @printword <word ptr [bx+6]>
    print_cr_lf
    add bx, 0ah
    cmp bx, offset shop2topgoods
    jne @l5
@l4:
    ret
@l1:
    @strprint <offset print_goods_header_2>
    print_cr_lf

    mov bx, offset shop1goods
    cmp bx, offset shop1topgoods
    je @l6

@l7:
    @strprint <bx>
    print_ht
    @strlen <bx>
    add bx, ax
    inc bx
    @printword <word ptr [bx+8]>
    print_ht
    @printword <word ptr (shop2goods-shop1goods)[bx+8]>
    print_cr_lf
    add bx, 0ah
    cmp bx, offset shop1topgoods
    jne @l7
@l6:
    ret
print_goods endp
print_all:
    cmp byte ptr[auth],0
    jnz print_all_passed
    @strprint <offset perm_denied_hint>
    jmp user_menu
print_all_passed:
    ; @strprint <offset not_impl_hint>
    xor edi, edi
    call print_goods
    inc edi
    call print_goods
    jmp user_menu

quit_prog:
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
;calc_avg proc ; shop1 in si, shop2 in di
    ;pusha
    ;mov bx,si
    ;mov cx,word ptr[bx+8]
    ;mov bx,di
    ;mov ax,word ptr[bx+8]
    ;add ax,cx
    ;cwd
    ;mov cx,2
    ;idiv cx
    ;mov word ptr[avgpr],ax
    ;popa
    ;ret
;calc_avg endp

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

