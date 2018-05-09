.386
stack segment use16 stack
    db 500 dup(0)
stack ends

data segment use16
psk db 'pakey'
shftpsk db 5 dup(0)
orig db 'FUCKU'
cipher db 5 dup(0)
decipher db 5 dup(0)
data ends
include zhwklib.inc
include cipher.inc
code segment para public use16
    assume cs:code,ds:data,ss:stack
    jmp begin
begin:
    ; init ds: masm is buggy while doing this!
    mov ax,data
    mov ds,ax
    ; test START!!
    @strshift <offset psk>,<offset shftpsk>,<5>
    nop
    @encrypt <offset orig>,<offset psk>,<offset shftpsk>,<5>,<offset cipher>
    nop
    @decrypt <offset cipher>,<offset psk>,<offset shftpsk>,<5>,<offset decipher>
    nop
    
code ends
end begin

