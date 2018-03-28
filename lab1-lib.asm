.386
code segment para public use16
public clear
clear proc
    push bp
    mov bp,sp
    push bx
    mov bx,word ptr[bp+6]
    push ax
    mov ax,word ptr[bp+8]
    cmp ax,0
    jz clear_exit
clear_loop:
    mov byte ptr[bx],0
    inc bx
    dec ax
    jnz clear_loop
clear_exit:
    pop ax
    pop bx
    pop bp
    ret
clear endp
code ends
end
