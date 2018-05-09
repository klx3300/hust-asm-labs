.386
include zhwklib.inc
stack segment use16 stack
db 500 dup(0)
stack ends
data segment use16
hint_input db 'Please input the CMOS address: ',0
input_buffer db 20 dup(0)
data ends
code segment use16
    assume cs:code, ds:data, ss:stack
start:
    mov ax, data
    mov ds, ax
    @strprint <offset hint_input>
    @gets <offset input_buffer>
    @strtoword <offset input_buffer>
    pop ax
    out 70h,al
    xor ax,ax
    in al,71h
    @printhex <ax>
    @newln
    jmp start
    
code ends
end start
