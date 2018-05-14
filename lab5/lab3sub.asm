.386
retsize equ 2
MAGICDIFF equ -200
public _MODGOODS
public _CAPR
public _CPRR
public _PAG
include zhwklibt.inc
_DATA segment use16 word public 'DATA'
calc_finish_hint db 'Calculation Finished! Please use Function 5 to display!',10,0
in_good_hint db 'Please Input Good Name:',0
in_shop_hint db 'Please Input Shop Name:',0
good_not_exist_hint db 'The good you ask is not exist!',10,0
shop_not_exist_hint db 'The shop you ask is not exist!',10,0
query_result_hint db 'shopname, itemname, price, stock, sold',10,0
attr_inprice db 'Instock Price: ',0
attr_sellprice db 'Selling Price: ',0
attr_stock db 'Stock: ',0
modify_input_hint db ' => ',0
shop1name db 'shop1',0
shop2name db 'shop2',0
print_goods_header db 'name',9,'cost',9,'price',9,'in_cnt',9,'out_cnt',0
print_goods_header_2 db 'name',9,'profit%',9,'rank',0
in_good db 50 dup(0)
in_buffer db 50 dup(0)
_DATA ends
_TEXT segment use16 byte public 'CODE'
assume cs:_TEXT,ds:_DATA
_MODGOODS proc near
    push bp
    mov bp,sp
    pusha
mg_restart:
    @strprint <offset in_shop_hint>
    @gets <offset in_buffer>
    @strlen <offset in_buffer>
    cmp ax,0
    je mod_attr_end
    @strfcmp <offset in_buffer>,<offset shop1name>
    cmp ax,0
    jne mg_try_shop2
    mov bx,word ptr[bp+retsize+2]
    mov cx,word ptr[bp+retsize+4]
    jmp mg_get_goodname
mg_try_shop2:
    @strfcmp <offset in_buffer>,<offset shop2name>
    cmp ax,0
    jne mg_shop_notfound
    mov bx,word ptr[bp+retsize+6]
    mov cx,word ptr[bp+retsize+8]
    jmp mg_get_goodname
mg_shop_notfound:
    @strprint <offset shop_not_exist_hint>
    jmp mg_restart
mg_get_goodname:
    @strprint <offset in_good_hint>
    @gets <offset in_good>
    @strlen <offset in_good>
    cmp ax,0
    je mg_restart
mg_search_loop:
    cmp bx,cx
    jz mg_not_found
    @strfcmp <offset in_good>, <bx>
    cmp ax,0
    jz mg_found
    add bx,10
    add bx,10
    jmp mg_search_loop
mg_not_found:
    @strprint <offset good_not_exist_hint>
    jmp mg_restart
mg_found:
    add bx,10
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
    popa
    pop bp
    ret
mod_attr_inprice_fail:
    @clstk 2
    jmp mod_attr_inprice
mod_attr_sellprice_fail:
    @clstk 2
    jmp mod_attr_sellprice
mod_attr_stock_fail:
    @clstk 2
    jmp mod_attr_stock
_MODGOODS endp
_CAPR proc near
    push bp
    mov bp,sp
    pusha
    ;@brkpt
    mov bx, [bp+retsize+2]
    cmp bx, [bp+retsize+4]
    je calc_avg_exit
calc_avg_passed_loop: ; start of the loop
    add bx,10

    mov ax, word ptr[bx] ; cost
    mov dx, word ptr[bx+4] ; in count
    mul dx

    ; store result in ecx
    mov cx, dx
    shl ecx, 10h
    mov cx, ax
    ; revenue
    mov ax, word ptr[bx+2] ; price
    mov dx, word ptr[bx+6] ; sold count
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
    sub bx, [bp+retsize+2]
    add bx, [bp+retsize+6]

    mov ax, word ptr[ebx] ; cost
    mov dx, word ptr[ebx+4] ; in count
    mul dx

    ; store result in ecx
    mov cx, dx
    shl ecx, 10h
    mov cx, ax
    ; revenue
    mov ax, word ptr[bx+2] ; price
    mov dx, word ptr[bx+6] ; sold count
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
    mov word ptr[bx+8], ax ; store

    ; increment
    add bx, 10
    ; check condition
    cmp bx, [bp+retsize+4]
    jne calc_avg_passed_loop
calc_avg_exit:
    @strprint <offset calc_finish_hint>
    popa
    pop bp
    ret
_CAPR endp
goods_sort proc
    ; loop init
    push bp
    mov bp, sp

    mov bx, [bp+retsize+6]
    cmp bx, [bp+retsize+8]
    jne FUCK1
    ret

FUCK1:
    xor cx, cx
FUCK2:
    push bx
    inc cx
    inc cx
    add bx, 9

    add bx, 0bh
    cmp bx, [bp+retsize+8]
    jne FUCK2

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
FUCK3:
    xor ebx, ebx
    mov bx, [esp+ecx*2-2]
    add bx,10
    mov [ebx+8], cx
    loop FUCK3
    
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
    jg FUCK4
    pop ebx
    ret
FUCK4:

    xor ecx, ecx
    mov cx, ss:[esi-2] ; pivot pointer
    add cx,10
    add cx, 8
    mov cx, (MAGICDIFF)[ecx] ; pivot

    mov eax, edi ; end of > zone
    mov ebx, eax ; end of <= zone

    push edi ; store beg
FUCK6:
    ; compare
    xor edx, edx
    mov dx, ss:[ebx]

    mov edi, eax

    add dx,9
    add dx, 9 ; curr pointer

    mov eax, edi

    cmp (MAGICDIFF)[edx], cx
    jle FUCK5
    ; swap
    mov dx, ss:[ebx]
    mov di, ss:[eax]
    mov ss:[eax], dx
    mov ss:[ebx], di
    add eax, 2
FUCK5:
    add ebx, 2

    cmp ebx, esi
    jne FUCK6

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
_CPRR proc near
    push bp
    mov bp,sp
    pusha
    mov ax,[bp+retsize+8]
    push ax
    mov ax,[bp+retsize+6]
    push ax
    mov ax,[bp+retsize+4]
    push ax
    mov ax,[bp+retsize+2]
    push ax
    call goods_sort
    @clstk 8
    @strprint <offset calc_finish_hint>
    popa
    pop bp
    ret
_CPRR endp
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
    push bp
    mov bp,sp
    test edi, edi
    jnz FUCK7
    @strprint <offset shop1name>
    print_cr_lf
    @strprint <offset print_goods_header>
    print_cr_lf
    mov bx, [bp+retsize+2]
    cmp bx, [bp+retsize+4]
    je FUCK8
FUCK9:
    @strprint <bx>
    print_ht
    add bx,10
    @printword <word ptr [bx]>
    print_ht
    @printword <word ptr [bx+2]>
    print_ht
    @printword <word ptr [bx+4]>
    print_ht
    @printword <word ptr [bx+6]>
    print_cr_lf
    add bx, 0ah
    cmp bx, [bp+retsize+4]
    jne FUCK9

    print_cr_lf
FUCK8:
    @strprint <offset shop2name>
    print_cr_lf
    @strprint <offset print_goods_header>
    print_cr_lf
    mov bx, [bp+retsize+6]
    cmp bx, [bp+retsize+8]
    je FUCK10
FUCK11:
    @strprint <bx>
    print_ht
    add bx,10
    @printword <word ptr [bx]>
    print_ht
    @printword <word ptr [bx+2]>
    print_ht
    @printword <word ptr [bx+4]>
    print_ht
    @printword <word ptr [bx+6]>
    print_cr_lf
    add bx, 0ah
    cmp bx, [bp+retsize+8]
    jne FUCK11
FUCK10:
    pop bp
    ret
FUCK7:
    @strprint <offset print_goods_header_2>
    print_cr_lf

    mov bx, [bp+retsize+2]
    cmp bx, [bp+retsize+4]
    je FUCK12

FUCK13:
    @strprint <bx>
    print_ht
    add bx,10
    @printword <word ptr [bx+8]>
    print_ht
    @printword <word ptr (-MAGICDIFF)[bx+8]>
    print_cr_lf
    add bx, 0ah
    cmp bx, [bp+retsize+4]
    jne FUCK13
FUCK12:
    pop bp
    ret
print_goods endp
_PAG proc near
    push bp
    mov bp,sp
    pusha
    xor edi,edi
    mov ax,[bp+retsize+8]
    push ax
    mov ax,[bp+retsize+6]
    push ax
    mov ax,[bp+retsize+4]
    push ax
    mov ax,[bp+retsize+2]
    push ax
    call print_goods
    inc edi
    call print_goods
    @clstk 8
    popa
    pop bp
    ret
_PAG endp

_TEXT ends
end