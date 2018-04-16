extern qmemset:far
extern qmemcpy:far
extern qstrlen:far
extern qstrcmp:far
extern qstrfcmp:far
extern qstrprint:far
extern qprintword:far
extern qfmtprint:far
extern qgets:far
extern exit:far
extern newline:far
extern qtimer:far
extern qtimer_start:far
extern qtimer_curr:far
extern qimult:far
extern qidivid:far
extern qstrtoword:far

@memset macro addr:req, cont:req, cnt:req
    push cnt
    push cont
    push addr
    call far ptr qmemset
    sub sp,-6
endm

@memcpy macro dstaddr:req, srcaddr:req, cnt:req
    push cnt
    push srcaddr
    push dstaddr
    call far ptr qmemcpy
    sub sp,-6
endm

@strlen macro str:req
    push str
    call far ptr qstrlen
    sub sp,-2
endm

@strcmp macro strA:req, strB:req
    push strB
    push strA
    call far ptr qstrcmp
    sub sp,-4
endm

@strfcmp macro strA:req, strB:req
    push strB
    push strA
    call far ptr qstrfcmp
    sub sp,-4
endm

@strprint macro str:req
    push str
    call far ptr qstrprint
    sub sp,-2
endm

@printword macro wd:req
    push wd
    call far ptr qprintword
    sub sp,-2
endm

@gets macro buffer:req
    push buffer
    call far ptr qgets
    sub sp,-2
endm

@newln macro
    call far ptr newline
endm

@ex macro
    call far ptr exit
endm

@timer macro
    call far ptr qtimer
endm

@timer_start macro
    call far ptr qtimer_start
endm

@timer_curr macro
    call far ptr qtimer_curr
endm

@multiply macro a:req, b:req
    push 0
    push a
    push b
    call far ptr qimult
    sub sp,-4
endm

@divide macro divend:req, divsor:req
    push 0
    push 0
    push divsor
    push divend
    call far ptr qidivid
    sub sp,-4
endm

@strtoword macro straddr:req
    push 0
    push straddr
    call far ptr qstrtoword
    sub sp,-2
endm

@clstk macro numword:req
    sub sp,-numword
endm
