.386
retsize equ 4
include zhwklib.inc
public qstrshift; (orig, dest, size)
public qencrypt ; (orig, psk, shftpsk, size, buf)
public qdecrypt ; (ciph, psk, shftpsk, size, buf)
zhwkcipher segment para public use16
qstrshift proc far
    push bp
    mov bp,sp
    pusha
    mov si,[bp+retsize+2]
    mov di,[bp+retsize+4]
    mov ax,[bp+retsize+6]
    mov bx,ax
    mov cl,byte ptr[si]
    mov byte ptr[di+bx-1],cl
    mov bx,1
_qstrshft_loop:
    mov cl,byte ptr[si+bx]
    mov byte ptr[di+bx-1],cl
    inc bx
    cmp bx,ax
    jl _qstrshft_loop
    popa
    pop bp
    ret
qstrshift endp
qencrypt proc far
    push bp
    mov bp,sp
    pusha
    mov bx,[bp+retsize+2]
    mov si,[bp+retsize+4]
    mov dx,[bp+retsize+6]
    mov cx,[bp+retsize+8]
    mov di,[bp+retsize+10]
    pusha
    add cx,bx
    mov al,byte ptr[bx]
    xor al,byte ptr[si]
    mov byte ptr[di],al
    inc bx
    inc si
    inc di
_qencrypt_first_loop:
    mov al,byte ptr[bx]
    xor al,byte ptr[si]
    xor al,byte ptr[bx-1]
    mov byte ptr[di],al
    inc bx
    inc si
    inc di
    cmp bx,cx
    jl _qencrypt_first_loop
    popa
    mov bx,0
    mov si,dx
_qencrypt_second_loop:
    mov al,byte ptr[di+bx]
    xor al,byte ptr[si+bx]
    mov byte ptr[di+bx],al
    inc bx
    cmp bx,cx
    jl _qencrypt_second_loop
    popa
    pop bp
    ret
qencrypt endp
qdecrypt proc far
    push bp
    mov bp,sp
    pusha
    mov bx,[bp+retsize+2]
    mov si,[bp+retsize+6] ; shftpsk curr
    mov dx,[bp+retsize+4]
    mov cx,[bp+retsize+8]
    mov di,[bp+retsize+10]
    pusha
    add cx,bx
_qdecrypt_first_loop:
    mov al,byte ptr[bx]
    xor al,byte ptr[si]
    mov byte ptr[di],al
    inc bx
    inc si
    inc di
    cmp bx,cx
    jl _qdecrypt_first_loop
    popa
    mov si,dx
    add cx,di
    mov al,byte ptr[di]
    xor al,byte ptr[si]
    mov byte ptr[di],al
    inc di
    inc si
_qdecrypt_second_loop:
    mov al,byte ptr[di]
    xor al,byte ptr[si]
    xor al,byte ptr[di-1]
    mov byte ptr[di],al
    inc di
    inc si
    cmp di,cx
    jl _qdecrypt_second_loop
    popa
    pop bp
    ret
qdecrypt endp
zhwkcipher ends
end
