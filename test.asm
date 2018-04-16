.386
stack segment use16 stack
    db 500 dup(0)
stack ends

data segment use16
fakecorrective db 500 dup(0)
testnumber db '123FUCK',0
data ends
include zhwklib.inc
code segment para public use16
    assume cs:code,ds:data,ss:stack
    jmp begin
begin:
    ; init ds: masm is buggy while doing this!
    mov ax,data
    mov ds,ax
    ; test printbyte..
    @strtobyte <offset testnumber>
    pop ax
    nop
    
code ends
end begin

