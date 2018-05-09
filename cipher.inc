extern qstrshift:far
extern qencrypt:far
extern qdecrypt:far

@strshift macro srcaddr:req,dstaddr:req,sz:req
    push sz
    push dstaddr
    push srcaddr
    call far ptr qstrshift
    sub sp,-6
endm

@encrypt macro srcaddr:req,pskaddr:req,shftpsk:req,sz:req,buf:req
    push buf
    push sz
    push shftpsk
    push pskaddr
    push srcaddr
    call far ptr qencrypt
    sub sp,-10
endm

@decrypt macro srcaddr:req,pskaddr:req,shftpsk:req,sz:req,buf:req
    push buf
    push sz
    push shftpsk
    push pskaddr
    push srcaddr
    call far ptr qdecrypt
    sub sp,-10
endm

@undebug macro
    mov dword ptr gs:[4],0
    mov dword ptr gs:[12],0
endm

