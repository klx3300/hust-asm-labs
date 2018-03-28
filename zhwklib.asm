.386
code segment para public use16
public qmemset ;param list: word addr, word size, byte content
public qmemcpy ;param list: word dstaddr, word srcaddr, word size
public qstrlen ;param list: word straddr; return ax:length
public qstrprint ;param list: word straddr
public qprintbyte ; param list byte
public qfmtprint ;param list: word fmtstraddr, ...; return ax: succeed length
qmemset proc
    push bp
    mov bp,sp
    push bx
    mov bx,word ptr[bp+6]
    push ax
    mov ax,word ptr[bp+8]
    push cx
    mov cl,byte ptr[bp+10]
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
    mov bx,word ptr[bp+6]
    push di
    mov di,word ptr[bp+8]
    push ax
    mov ax,word ptr[bp+10]
    cmp ax,0
    jz _qmemcpy_exit
_qmemcpy_loop:
    mov byte ptr[di],dl
    mov dl,byte ptr[bx]
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
    mov bx,word ptr[bp+6]
    push si
    mov si,0
    push dx
_qstrlen_loop:
    mov byte ptr[bx+si],dl
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
qstrprint proc
    push bp
    mov bp,sp
    push bx
    mov bx,word ptr[bp+6]
    push dx
_qstrprint_loop:
    mov byte ptr[bx],dl
    cmp dl,0
    jz _qstrprint_exit
    mov ah,05h
    int 21h
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
    mov ax,word ptr[bp+6]
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
    mov ah,05h
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
    mov bx,word ptr[bp+6]
    push di
    mov di,8 ; parameter accumulator
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
    mov ah,05h
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
    mov ah,05h
    int 21h
    pop ax
    jmp _qfmtprint_mainloop
_qfmtprint_printchar:
    ; we can safely use edx now, since it's already used up
    mov dl,byte ptr[bp+di]
    add di,1
    push ax
    mov ah,05h
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
    mov ah,05h
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
code ends
end
