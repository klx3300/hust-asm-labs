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

code segment use16
    assume cs:code,ds:data,ss:stack
    jmp begin
qmemset proc
    push bp
    mov bp,sp
    push bx
    mov bx,word ptr[bp+4]
    push ax
    mov ax,word ptr[bp+6]
    push cx
    mov cl,byte ptr[bp+8]
    cmp ax,0
    jz _qmemset_exit
_qmemset_loop:
    mov byte ptr[bx],cl
    inc bx
    dec ax
    jnz _qmemset_loop
_qmemset_exit:
    pop cx
    pop ax
    pop bx
    pop bp
    ret
qmemset endp
qmemcpy proc
    push bp
    mov bp,sp
    push bx
    mov bx,word ptr[bp+4]
    push di
    mov di,word ptr[bp+6]
    push ax
    mov ax,word ptr[bp+8]
    cmp ax,0
    jz _qmemcpy_exit
_qmemcpy_loop:
    mov dl,byte ptr[di]
    mov byte ptr[bx],dl
    inc bx
    inc di
    dec ax
    jnz _qmemcpy_loop
_qmemcpy_exit:
    pop ax
    pop di
    pop bx
    pop bp
    ret
qmemcpy endp
qstrlen proc
    push bp
    mov bp,sp
    push bx
    mov bx,word ptr[bp+4]
    push si
    mov si,0
    push dx
_qstrlen_loop:
    mov dl,byte ptr[bx+si]
    cmp dl,0
    jz _qstrlen_exit
    inc si
    jmp _qstrlen_loop
_qstrlen_exit:
    mov ax,si
    pop dx
    pop si
    pop bx
    pop bp
    ret
qstrlen endp
qstrcmp proc
    push bp
    mov bp,sp
    push bx
    push si
    mov bx,word ptr[bp+4]
    mov si,word ptr[bp+6]
    push cx
_qstrcmp_loop:
    mov cl,byte ptr[bx]
    cmp cl,0
    jz _qstrcmp_corrend
    mov ch,byte ptr[si]
    cmp ch,0
    jz _qstrcmp_corrend
    sub cl,ch
    cmp cl,0
    jnz _qstrcmp_diffend
    inc bx
    inc si
    jmp _qstrcmp_loop
_qstrcmp_corrend:
    mov ax,0
    jmp _qstrcmp_exit
_qstrcmp_diffend:
    mov ax,0
    mov al,cl
    jmp _qstrcmp_exit
_qstrcmp_exit:
    pop cx
    pop si
    pop bx
    pop bp
    ret
qstrcmp endp
qstrfcmp proc
    push bp
    mov bp,sp
    push bx
    push si
    push cx
    push dx
    mov ax,0
    mov bx,word ptr[bp+4]
    mov si,word ptr[bp+6]
    push si
    push bx
    call qstrcmp
    sub sp,-4
    cmp ax,0
    jnz _qstrfcmp_fail
    push bx
    call qstrlen
    sub sp,-2
    mov cx,ax
    push si
    call qstrlen
    sub sp,-2
    mov dx,ax
    sub cx,dx
    mov ax,cx
    cmp ax,0
    jnz _qstrfcmp_fail
    mov ax,0
_qstrfcmp_fail:
    pop dx
    pop cx
    pop si
    pop bx
    pop bp
    ret
qstrfcmp endp
qstrprint proc
    push bp
    mov bp,sp
    push bx
    mov bx,word ptr[bp+4]
    push dx
_qstrprint_loop:
    mov dl,byte ptr[bx]
    cmp dl,0
    jz _qstrprint_exit
    mov ah,02h
    int 21h
    inc bx
    jmp _qstrprint_loop
_qstrprint_exit:
    pop dx
    pop bx
    pop bp
    ret
qstrprint endp
qprintbyte proc
    push bp
    mov bp,sp
    push ax
    mov ax,word ptr[bp+4]
    push bx
    mov bx,0 ; status accumulator
    push dx
    push cx
    cmp ax,0
    jg _printbyte_skip_neg
    neg ax
    push dx
    mov dl,'-'
    push ax
    mov ah,02h
    int 21h
    pop ax
    pop dx
_printbyte_skip_neg:
    push bx
    mov bx,10
    div bx
    pop bx
    push ax
    inc bx
    mov ax,dx
    cmp dx,0
    jnz _printbyte_skip_neg
    add bx,6
    mov cx,6
    push bp
    mov bp,sp
_printbyte_prloop:
    cmp cx,bx
    jz _printbyte_stop
    push dx
    push di
    mov di,cx
    mov dl,byte ptr[bp+di]
    pop di
    add dl,'0'
    push ax
    mov ax,05h
    int 21h
    pop ax
    pop dx
    inc cx
    jmp _printbyte_prloop
_printbyte_stop:
    pop bp
    sub bx,6
    add sp,bx
    pop cx
    pop dx
    pop bx
    pop ax
    pop bp
ret
qprintbyte endp
qfmtprint proc
    push bp
    mov bp,sp
    push bx
    mov bx,word ptr[bp+4]
    push di
    mov di,6 ; parameter accumulator
    mov ax,0 ; output chars amount accumulator
    push cx
    mov cx,0 ; state recorder: classic printf is a state machine!
    ; state 0: standard output
    ; state 1: format string
    ; format specs: %b byte %c char %h word %d dword %s string %f float
    push si
    mov si,0 ; format string position accumulator
    push dx
_qfmtprint_mainloop:
    mov dl, byte ptr[bx+si]
    cmp dl,0
    jz _qfmtprint_end
    inc ax
    cmp cx,0
    jnz _qfmtprint_format
    cmp dl,'%'
    jnz _qfmtprint_normout
    mov cx,1
    dec ax
    jmp _qfmtprint_mainloop
_qfmtprint_normout:
    push ax
    mov ah,02h
    int 21h
    pop ax
    jmp _qfmtprint_mainloop
_qfmtprint_format:
    cmp dl,'b'
    jz _qfmtprint_printbyte
    cmp dl,'c'
    jz _qfmtprint_printchar
    cmp dl,'h'
    jz _qfmtprint_printword
    cmp dl,'d'
    jz _qfmtprint_printdword
    cmp dl,'s'
    jz _qfmtprint_printstr
    cmp dl,'f'
    jz _qfmtprint_printfloat
    cmp dl,'%'
    jz _qfmtprint_printpct
    ; none match..
    push ax
    mov ah,02h
    int 21h
    pop ax
    jmp _qfmtprint_mainloop
_qfmtprint_printchar:
    ; we can safely use edx now, since it's already used up
    mov dx,word ptr[bp+di]
    add di,2
    push ax
    mov ah,02h
    int 21h
    pop ax
    jmp _qfmtprint_mainloop
_qfmtprint_printstr:
    mov dx,word ptr[bp+di]
    add di,2
    push dx
    call qstrprint
    sub sp,-2
    jmp _qfmtprint_mainloop
_qfmtprint_printpct:
    push ax
    mov ah,02h
    int 21h
    pop ax
    jmp _qfmtprint_mainloop
_qfmtprint_printbyte:
    ; TODO: implement
    jmp _qfmtprint_mainloop
_qfmtprint_printword:
    ; TODO: implement
    jmp _qfmtprint_mainloop
_qfmtprint_printdword:
    ; TODO: implement
    jmp _qfmtprint_mainloop
_qfmtprint_printfloat:
    ; TODO: implement
    jmp _qfmtprint_mainloop
_qfmtprint_end:
    pop dx
    pop si
    pop cx
    pop di
    pop bx
    pop bp
    ret
qfmtprint endp
qgets proc
    push bp
    mov bp,sp
    push cx
    mov cx,ds
    push ax
    push bx
    mov bx,word ptr[bp+4]
    push si
    push di
    push dx
    sub sp,100
    mov si,sp
    mov byte ptr ss:[si],98
    mov byte ptr ss:[si+1],0
    mov dx,sp
    mov ax,ss
    mov ds,ax
    mov ah,0AH
    int 21H
    mov ds,cx
    mov di,0
    mov ax,0
    mov al,byte ptr ss:[si+1]
    mov di,ax
    add di,2
    push bx
    mov bx,di
    mov byte ptr ss:[si+bx],0
    pop bx
    inc ax
    add si,2
_qgets_cploop:
    mov dl,byte ptr ss:[si]
    mov byte ptr[bx],dl
    inc si
    inc bx
    dec ax
    jnz _qgets_cploop
    sub sp,-100
    mov dl,10
    mov ah,02H
    int 21H
    pop dx
    pop di
    pop si
    pop bx
    pop ax
    pop cx
    pop bp
    ret
qgets endp
exit proc
    mov ax,0
    mov ah,4CH
    int 21H
exit endp
newline proc
    push dx
    push ax
    mov dl,10
    mov ah,02H
    int 21H
    pop ax
    pop dx
    ret
newline endp

begin:
    ; init ds: masm is buggy while doing this!
    mov ax,data
    mov ds,ax
restart_auth:
    push offset in_user_hint
    call qstrprint
    sub sp,-2
    push offset in_name
    call qgets
    call qstrlen
    cmp ax,0
    jz guest_mode
    sub sp,-2
    push offset in_name
    push offset quit_str
    call qstrfcmp
    sub sp,-4
    cmp ax,0
    jz quit
    push offset in_pass_hint
    call qstrprint
    sub sp,-2
    push offset in_passwd
    call qgets
    sub sp,-2
    push offset in_name
    push offset username
    call qstrfcmp
    sub sp,-4
    cmp ax,0
    jnz auth_failed
    push offset in_passwd
    push offset password
    call qstrfcmp
    sub sp,-4
    cmp ax,0
    jnz auth_failed
    ; auth succeed!
    mov byte ptr[auth],1
    push offset correct_hint
    call qstrprint
    sub sp,-2
    jmp query_goods
auth_failed:
    push offset incorrect_hint
    call qstrprint
    sub sp,-2
    jmp restart_auth
guest_mode:
    push offset guest_hint
    call qstrprint
    sub sp,-2
    mov byte ptr[auth],0
query_goods:
    push offset in_good_hint
    call qstrprint
    sub sp,-2
    push offset in_good
    call qgets
    call qstrlen
    sub sp,-2
    cmp ax,0
    jz restart_auth
    lea bx,offset shop1goods
shop1_search_loop:
    cmp bx,offset shop1topgoods
    jz shop1_not_found
    push bx
    push offset in_good
    call qstrfcmp
    sub sp,-4
    cmp ax,0
    jz shop1_found
    push bx
    call qstrlen
    sub sp,-2
    add bx,ax
    inc bx
    add bx,10
    jmp shop1_search_loop
shop1_not_found:
    push offset good_not_exist_hint
    call qstrprint
    sub sp,-2
    jmp query_goods
shop1_found:
    mov al,byte ptr[auth]
    cmp al,0
    jnz admin_mode
    push bx
    call qstrprint
    sub sp,-2
    call newline
    jmp query_goods
admin_mode:
    push bx
    call qstrlen
    sub sp,-2
    add bx,ax
    inc bx
    mov ax,word ptr[bx+2]
    mov cx,word ptr[bx+6]
    imul cx
    mov dx,ax
    mov ax,word ptr[bx]
    mov cx,word ptr[bx+4]
    imul cx
    sub dx,ax
    mov ax,dx
    mov cx,100
    imul cx
    mov dx,ax
    mov ax,word ptr[bx]
    mov cx,word ptr[bx+4]
    imul cx
    mov cx,ax
    mov ax,dx
    idiv cx
    mov word ptr[pr1],ax
    lea bx,offset shop2goods
shop2_search_loop:
    cmp bx,offset shop2topgoods
    jz shop2_not_found
    push bx
    push offset in_good
    call qstrfcmp
    sub sp,-4
    cmp ax,0
    jz shop2_found
    push bx
    call qstrlen
    sub sp,-2
    add bx,ax
    inc bx
    add bx,10
    jmp shop2_search_loop
shop2_not_found:
    push offset good_not_exist_hint
    call qstrprint
    sub sp,-2
    jmp query_goods
shop2_found:
    mov al,byte ptr[auth]
    cmp al,0
    jnz admin_mode_continue
    push bx
    call qstrprint
    sub sp,-2
    jmp query_goods
admin_mode_continue:
    push bx
    call qstrlen
    sub sp,-2
    add bx,ax
    inc bx
    mov ax,word ptr[bx+2]
    mov cx,word ptr[bx+6]
    imul cx
    mov dx,ax
    mov ax,word ptr[bx]
    mov cx,word ptr[bx+4]
    imul cx
    sub dx,ax
    mov ax,dx
    mov cx,100
    imul cx
    mov dx,ax
    mov ax,word ptr[bx]
    mov cx,word ptr[bx+4]
    imul cx
    mov cx,ax
    mov ax,dx
    idiv cx
    mov word ptr[pr2],ax
    mov cx,word ptr[pr1]
    add ax,cx
    mov cx,2
    idiv cx
    mov word ptr[avgpr],ax
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
    call newline
    jmp query_goods
class_a:
    mov dl,'A'
    mov ah,02H
    int 21H
    call newline
    jmp query_goods
class_b:
    mov dl,'B'
    mov ah,02H
    int 21H
    call newline
    jmp query_goods
class_c:
    mov dl,'C'
    mov ah,02H
    int 21H
    call newline
    jmp query_goods
class_d:
    mov dl,'D'
    mov ah,02H
    int 21H
    call newline
    jmp query_goods
quit:
    call exit
    
code ends
end begin

