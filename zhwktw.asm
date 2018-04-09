.386
retsize equ 4
public qmemset ;param list: word addr, word size, byte content
public qmemcpy ;param list: word dstaddr, word srcaddr, word size
public qstrlen ;param list: word straddr; return ax:length
public qstrcmp ;param list: word strAaddr, word strBaddr; return al: first differ
public qstrfcmp ;param list: word strAaddr, word strBaddr; return al: first differ
public qstrprint ;param list: word straddr
public qprintword ; param list byte
public qfmtprint ;param list: word fmtstraddr, ...; return ax: succeed length
public qgets ; param list: word bufferaddr
public exit
public newline
public qtimer
public qtimer_start
public qtimer_curr
public qimult ; word a, word b, word result => result will be saved into result
public qidivid ; word divend, word divisor, word result-quo, word result-rem
zhwklib segment para public use16
qmemset proc far
    push bp
    mov bp,sp
    push bx
    mov bx,word ptr[bp+retsize+2]
    push ax
    mov ax,word ptr[bp+retsize+4]
    push cx
    mov cl,byte ptr[bp+retsize+6]
    cmp ax,0
    jz _qmemset_exit
_qmemset_loop:
    mov byte ptr[bx],cl
    inc bx
    dec ax
    jnz _qmemset_loop
_qmemset_exit:
    pop cx
    pop ax
    pop bx
    pop bp
    ret
qmemset endp
qmemcpy proc far
    push bp
    mov bp,sp
    push bx
    mov bx,word ptr[bp+retsize+2]
    push di
    mov di,word ptr[bp+retsize+4]
    push ax
    mov ax,word ptr[bp+retsize+6]
    cmp ax,0
    jz _qmemcpy_exit
_qmemcpy_loop:
    mov dl,byte ptr[di]
    mov byte ptr[bx],dl
    inc bx
    inc di
    dec ax
    jnz _qmemcpy_loop
_qmemcpy_exit:
    pop ax
    pop di
    pop bx
    pop bp
    ret
qmemcpy endp
qstrlen proc far
    push bp
    mov bp,sp
    push bx
    mov bx,word ptr[bp+retsize+2]
    push si
    mov si,0
    push dx
_qstrlen_loop:
    mov dl,byte ptr[bx+si]
    cmp dl,0
    jz _qstrlen_exit
    inc si
    jmp _qstrlen_loop
_qstrlen_exit:
    mov ax,si
    pop dx
    pop si
    pop bx
    pop bp
    ret
qstrlen endp
qstrcmp proc far
    push bp
    mov bp,sp
    push bx
    push si
    mov bx,word ptr[bp+retsize+2]
    mov si,word ptr[bp+retsize+4]
    push cx
_qstrcmp_loop:
    mov cl,byte ptr[bx]
    cmp cl,0
    jz _qstrcmp_corrend
    mov ch,byte ptr[si]
    cmp ch,0
    jz _qstrcmp_corrend
    sub cl,ch
    cmp cl,0
    jnz _qstrcmp_diffend
    inc bx
    inc si
    jmp _qstrcmp_loop
_qstrcmp_corrend:
    mov ax,0
    jmp _qstrcmp_exit
_qstrcmp_diffend:
    mov ax,0
    mov al,cl
    jmp _qstrcmp_exit
_qstrcmp_exit:
    pop cx
    pop si
    pop bx
    pop bp
    ret
qstrcmp endp
qstrfcmp proc far
    push bp
    mov bp,sp
    push bx
    push si
    push cx
    push dx
    mov ax,0
    mov bx,word ptr[bp+retsize+2]
    mov si,word ptr[bp+retsize+4]
    push si
    push bx
    call qstrcmp
    sub sp,-4
    cmp ax,0
    jnz _qstrfcmp_fail
    push bx
    call qstrlen
    sub sp,-2
    mov cx,ax
    push si
    call qstrlen
    sub sp,-2
    mov dx,ax
    sub cx,dx
    mov ax,cx
    cmp ax,0
    jnz _qstrfcmp_fail
    mov ax,0
_qstrfcmp_fail:
    pop dx
    pop cx
    pop si
    pop bx
    pop bp
    ret
qstrfcmp endp
qstrprint proc far
    push bp
    mov bp,sp
    push bx
    mov bx,word ptr[bp+retsize+2]
    push dx
    push ax
_qstrprint_loop:
    mov dl,byte ptr[bx]
    cmp dl,0
    jz _qstrprint_exit
    mov ah,02h
    int 21h
    inc bx
    jmp _qstrprint_loop
_qstrprint_exit:
    pop ax
    pop dx
    pop bx
    pop bp
    ret
qstrprint endp
qprintword proc far
    push bp
    mov bp,sp
    push ax
    mov ax,word ptr[bp+retsize+2]
    push bx
    mov bx,0 ; status accumulator
    push dx
    push cx
    mov cx,0
    mov dx,0
    cmp ax,0
    jge _qprintword_skip_neg
    neg ax
    push dx
    mov dl,'-'
    push ax
    mov ah,02h
    int 21h
    pop ax
    pop dx
_qprintword_skip_neg:
    mov bx,10
    div bx
    push dx
    mov dx,0
    inc cx
    cmp ax,bx
    jge _qprintword_skip_neg
    push ax
    inc cx
_qprintword_prloop:
    cmp cx,0
    jz _qprintword_stop
    pop dx
    add dl,'0'
    mov ah,02h
    int 21h
    dec cx
    jmp _qprintword_prloop
_qprintword_stop:
    pop cx
    pop dx
    pop bx
    pop ax
    pop bp
ret
qprintword endp
qfmtprint proc far
    push bp
    mov bp,sp
    push bx
    mov bx,word ptr[bp+retsize+2]
    push di
    mov di,4 ; parameter accumulator
    mov ax,0 ; output chars amount accumulator
    push cx
    mov cx,0 ; state recorder: classic printf is a state machine!
    ; state 0: standard output
    ; state 1: format string
    ; format specs: %b byte %c char %h word %d dword %s string %f float
    push si
    mov si,0 ; format string position accumulator
    push dx
_qfmtprint_mainloop:
    mov dl, byte ptr[bx+si]
    cmp dl,0
    jz _qfmtprint_end
    inc ax
    cmp cx,0
    jnz _qfmtprint_format
    cmp dl,'%'
    jnz _qfmtprint_normout
    mov cx,1
    dec ax
    jmp _qfmtprint_mainloop
_qfmtprint_normout:
    push ax
    mov ah,02h
    int 21h
    pop ax
    jmp _qfmtprint_mainloop
_qfmtprint_format:
    cmp dl,'b'
    jz _qfmtprint_printbyte
    cmp dl,'c'
    jz _qfmtprint_printchar
    cmp dl,'h'
    jz _qfmtprint_printword
    cmp dl,'d'
    jz _qfmtprint_printdword
    cmp dl,'s'
    jz _qfmtprint_printstr
    cmp dl,'f'
    jz _qfmtprint_printfloat
    cmp dl,'%'
    jz _qfmtprint_printpct
    ; none match..
    push ax
    mov ah,02h
    int 21h
    pop ax
    jmp _qfmtprint_mainloop
_qfmtprint_printchar:
    ; we can safely use edx now, since it's already used up
    mov dx,word ptr[bp+retsize+di]
    add di,2
    push ax
    mov ah,02h
    int 21h
    pop ax
    jmp _qfmtprint_mainloop
_qfmtprint_printstr:
    mov dx,word ptr[bp+retsize+di]
    add di,2
    push dx
    call qstrprint
    sub sp,-2
    jmp _qfmtprint_mainloop
_qfmtprint_printpct:
    push ax
    mov ah,02h
    int 21h
    pop ax
    jmp _qfmtprint_mainloop
_qfmtprint_printbyte:
    ; TODO: implement
    jmp _qfmtprint_mainloop
_qfmtprint_printword:
    ; TODO: implement
    jmp _qfmtprint_mainloop
_qfmtprint_printdword:
    ; TODO: implement
    jmp _qfmtprint_mainloop
_qfmtprint_printfloat:
    ; TODO: implement
    jmp _qfmtprint_mainloop
_qfmtprint_end:
    pop dx
    pop si
    pop cx
    pop di
    pop bx
    pop bp
    ret
qfmtprint endp
qgets proc far
    push bp
    mov bp,sp
    push cx
    mov cx,ds
    push ax
    push bx
    mov bx,word ptr[bp+retsize+2]
    push si
    push di
    push dx
    sub sp,100
    mov si,sp
    mov byte ptr ss:[si],98
    mov byte ptr ss:[si+1],0
    mov dx,sp
    mov ax,ss
    mov ds,ax
    mov ah,0AH
    int 21H
    mov ds,cx
    mov di,0
    mov ax,0
    mov al,byte ptr ss:[si+1]
    mov di,ax
    add di,2
    push bx
    mov bx,di
    mov byte ptr ss:[si+bx],0
    pop bx
    inc ax
    add si,2
_qgets_cploop:
    mov dl,byte ptr ss:[si]
    mov byte ptr[bx],dl
    inc si
    inc bx
    dec ax
    jnz _qgets_cploop
    sub sp,-100
    mov dl,10
    mov ah,02H
    int 21H
    pop dx
    pop di
    pop si
    pop bx
    pop ax
    pop cx
    pop bp
    ret
qgets endp
exit proc far
    mov ax,0
    mov ah,4CH
    int 21H
exit endp
newline proc far
    push dx
    push ax
    mov dl,10
    mov ah,02H
    int 21H
    pop ax
    pop dx
    ret
newline endp
qtimer_start proc far
    push bp
    mov bp,sp
    push cx
    push dx
    mov cx,0
    mov dx,0
    mov ah,2DH
    int 21H
    pop dx
    pop cx
    pop bp
    ret
qtimer_start endp
qtimer_curr proc far
    push bp
    mov bp,sp
    push cx
    push dx
    mov ah,2CH
    int 21H
    mov al,dh
    mov ah,0
    imul ax,ax,1000
    mov cx,ax
    mov al,cl
    mov ah,0
    imul ax,ax,10
    add ax,cx
    pop dx
    pop cx
    pop bp
    ret
qtimer_curr endp
qtimer	PROC far
	PUSH  DX
	PUSH  CX
	PUSH  BX
	MOV   BX, AX
	MOV   AH, 2CH
	INT   21H	     ;CH=hour(0-23),CL=minute(0-59),DH=second(0-59),DL=centisecond(0-100)
	MOV   AL, DH
	MOV   AH, 0
	IMUL  AX,AX,1000
	MOV   DH, 0
	IMUL  DX,DX,10
	ADD   AX, DX
	CMP   BX, 0
	JNZ   _T1
	MOV   CS:_TS, AX
_T0:	POP   BX
	POP   CX
	POP   DX
	RET
_T1:	SUB   AX, CS:_TS
	JNC   _T2
	ADD   AX, 60000
_T2:	MOV   CX, 0
	MOV   BX, 10
_T3:	MOV   DX, 0
	DIV   BX
	PUSH  DX
	INC   CX
	CMP   AX, 0
	JNZ   _T3
	MOV   BX, 0
_T4:	POP   AX
	ADD   AL, '0'
	MOV   CS:_TMSG[BX], AL
	INC   BX
	LOOP  _T4
	PUSH  DS
	MOV   CS:_TMSG[BX+0], 0AH
	MOV   CS:_TMSG[BX+1], 0DH
	MOV   CS:_TMSG[BX+2], '$'
	LEA   DX, _TS+2
	PUSH  CS
	POP   DS
	MOV   AH, 9
	INT   21H
	POP   DS
	JMP   _T0
_TS	DW    ?
 	DB    'Time elapsed in ms is '
_TMSG	DB    12 DUP(0)
qtimer  ENDP
qimult proc far
    push bp
    mov bp,sp
    pusha
    mov ax,word ptr[bp+retsize+2]
    mov bx,word ptr[bp+retsize+4]
    imul bx
    mov word ptr[bp+retsize+6],ax
    popa
    pop bp
    ret
qimult endp
qidivid proc far
    push bp
    mov bp,sp
    pusha
    mov dx,0
    mov ax,word ptr[bp+retsize+2]
    mov bx,word ptr[bp+retsize+4]
    idiv bx
    mov word ptr[bp+retsize+6],ax
    mov word ptr[bp+retsize+8],dx
    popa
    pop bp
    ret
qidivid endp
zhwklib ends
end
