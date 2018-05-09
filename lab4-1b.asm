.386
include zhwklib.inc
stack segment use16 stack
db 500 dup(0)
stack ends
data segment use16
hint_input db 'Please input the interrupt number: ',0
hint_dos db 'The interrupt destination read from DOS is:',10,0
hint_ram db 'The interrupt destination read from RAM is:',10,0
hint_press db 'Press enter to continue..',10,0
hint_splitter db ':',0
input_buffer db 20 dup(0)
dos_buffer db 20 dup(0)
data ends
code segment use16
    assume cs:code, ds:data, ss:stack
start:
    mov ax, data
    mov ds, ax
    mov es, ax
    @strprint <offset hint_input>
    @gets <offset input_buffer>
    @strtoword <offset input_buffer>
    pop ax
    @printhex <ax>
    @newln
    @strprint <offset hint_dos>
    mov ah,35h
    int 21h
    mov ax,es
    @printhex <ax>
    @strprint <offset hint_splitter>
    @printhex <bx>
    @newln
    @strtoword <offset input_buffer>
    pop ax
    mov bx,4
    @multiply <ax>,<bx>
    pop ax
    xor bx,bx
    mov ds,bx
    mov bx,ax
    mov cx,word ptr[bx]
    mov dx,word ptr[bx+2]
    mov bx, data
    mov ds, bx
    @strprint <offset hint_ram>
    @printhex <dx>
    @strprint <offset hint_splitter>
    @printhex <cx>
    @newln
    @strprint <offset hint_press>
    @gets <offset input_buffer>
    jmp start
code ends
end start
