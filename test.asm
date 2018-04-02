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

extern qmemset:near
extern qmemcpy:near
extern qstrlen:near
extern qstrcmp:near
extern qstrfcmp:near
extern qstrprint:near
extern qprintword:near
extern qfmtprint:near
extern qgets:near
extern exit:near
extern newline:near

code segment para public use16
    assume cs:code,ds:data,ss:stack
    jmp begin
begin:
    ; init ds: masm is buggy while doing this!
    mov ax,data
    mov ds,ax
    ; test printbyte..
    push 6666
    call near ptr qprintword
    push offset in_passwd
    call near ptr qgets
    call near ptr exit
    
code ends
end begin

