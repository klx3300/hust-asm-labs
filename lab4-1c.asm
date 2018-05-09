.386
code segment use16
old_int db 4 dup(0)
new16h:
    cmp ah, 00h
    je next
    cmp ah, 10h
    je next
    jmp dword ptr old_int
next:
    push bp
    mov bp, sp
    pushf
    call dword ptr old_int
    cli ; iret will set IF while we still in handling. not expected.
    cmp al, 'a'
    jb quit
    cmp al, 'z'
    ja quit
    add al, 'A'-'a'
quit:
    pop bp
    iret
start:
    xor ax, ax
    mov ds, ax
    mov bx, offset old_int
    mov ax, ds:[16h * 4]
    mov word ptr cs:[bx], ax
    mov ax, ds:[16h * 4 + 2]
    mov word ptr cs:[bx+2], ax
    cli
    mov word ptr ds:[16h * 4], offset new16h
    mov ds:[16h * 4 + 2], cs
    sti
    mov dx, offset start + 16
    shr dx, 4
    add dx, 10h
    mov ax, 3100h
    int 21h
code ends
stack segment stack
    db 200 dup(0)
stack ends
end start
