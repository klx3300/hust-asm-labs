extrn qmemset:near
extrn qmemcpy:near
extrn qstrlen:near
extrn qstrcmp:near
extrn qstrfcmp:near
extrn qstrprint:near
extrn qprintword:near
extrn qfmtprint:near
extrn qgets:near
extrn exit:near
extrn newline:near
extrn qtimer:near
extrn qtimer_start:near
extrn qtimer_curr:near
extrn qimult:near
extrn qidivid:near
extrn qstrtoword:near

@memset macro addr:req, cont:req, cnt:req
    push cnt
    push cont
    push addr
    call qmemset
    sub sp,-6
endm

@memcpy macro dstaddr:req, srcaddr:req, cnt:req
    push cnt
    push srcaddr
    push dstaddr
    call qmemcpy
    sub sp,-6
endm

@strlen macro str:req
    push str
    call qstrlen
    sub sp,-2
endm

@strcmp macro strA:req, strB:req
    push strB
    push strA
    call qstrcmp
    sub sp,-4
endm

@strfcmp macro strA:req, strB:req
    push strB
    push strA
    call qstrfcmp
    sub sp,-4
endm

@strprint macro str:req
    push str
    call qstrprint
    sub sp,-2
endm

@printword macro wd:req
    push wd
    call qprintword
    sub sp,-2
endm

@gets macro buffer:req
    push buffer
    call qgets
    sub sp,-2
endm

@newln macro
    call newline
endm

@ex macro
    call exit
endm

@timer macro
    call qtimer
endm

@timer_start macro
    call qtimer_start
endm

@timer_curr macro
    call qtimer_curr
endm

@multiply macro a:req, b:req
    push 0
    push a
    push b
    call qimult
    sub sp,-4
endm

@divide macro divend:req, divsor:req
    push 0
    push 0
    push divsor
    push divend
    call qidivid
    sub sp,-4
endm

@strtoword macro straddr:req
    push 0
    push straddr
    call qstrtoword
    sub sp,-2
endm

@clstk macro numword:req
    sub sp,-numword
endm

@brkpt macro
    int 3
endm
