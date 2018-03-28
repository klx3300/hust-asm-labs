.386
stack segment use16 stack
    db 200 dup(0)
stack ends

data segment use16
xuehao db 4 dup(0)
data ends

extrn clear:abs
code segment para public use16
    assume cs:code,ds:data,ss:stack
    jmp begin
begin:
    ; variable
    mov bx, offset xuehao
    mov byte ptr[bx],'4'
    mov byte ptr[bx+1],'5'
    mov byte ptr[bx+2],'6'
    mov byte ptr[bx+3],'4'
    push 4
    push bx
    call word ptr clear
    sub sp,-4
    ; indirect
    mov bx, offset xuehao
    mov byte ptr[bx],'4'
    inc bx
    mov byte ptr[bx],'5'
    inc bx
    mov byte ptr[bx],'6'
    inc bx
    mov byte ptr[bx],'4'
    mov bx, offset xuehao
    push 4
    push bx
    call word ptr clear
    sub sp,-4
    ; base and offset
    mov bx, offset xuehao
    mov si,0
    mov byte ptr[bx+si],'4'
    inc si
    mov byte ptr[bx+si],'5'
    inc si
    mov byte ptr[bx+si],'6'
    inc si
    mov byte ptr[bx+si],'4'
    push 4
    push bx
    call word ptr clear
    sub sp,-4
    mov bx,0
    ; direct
    mov xuehao,'4'
    mov xuehao+1,'5'
    mov xuehao+2,'6'
    mov xuehao+3,'4'
code ends
end begin

