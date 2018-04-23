	ifndef	??version
?debug	macro
	endm
	endif
	?debug	S "lab3.c"
_TEXT	segment	byte public 'CODE'
DGROUP	group	_DATA,_BSS
	assume	cs:_TEXT,ds:DGROUP,ss:DGROUP
_TEXT	ends
_DATA	segment word public 'DATA'
d@	label	byte
d@w	label	word
_DATA	ends
_BSS	segment word public 'BSS'
b@	label	byte
b@w	label	word
	?debug	C E97753974C066C6162332E63
	?debug	C E9D702974C15433A5C54435C494E434C5544455C737464696F2E68
	?debug	C E9D702974C16433A5C54435C494E434C5544455C7374646172672E+
	?debug	C 68
	?debug	C E9D702974C16433A5C54435C494E434C5544455C737472696E672E+
	?debug	C 68
_BSS	ends
_DATA	segment word public 'DATA'
_shop1	label	word
	db	112
	db	101
	db	110
	db	7 dup (0)
	dw	35
	dw	56
	dw	70
	dw	25
	dw	0
	db	98
	db	111
	db	111
	db	107
	db	6 dup (0)
	dw	12
	dw	30
	dw	25
	dw	5
	dw	0
	db	160 dup (0)
_shop2	label	word
	db	112
	db	101
	db	110
	db	7 dup (0)
	dw	12
	dw	28
	dw	20
	dw	15
	dw	0
	db	98
	db	111
	db	111
	db	107
	db	6 dup (0)
	dw	35
	dw	50
	dw	30
	dw	24
	dw	0
	db	160 dup (0)
_shop1top	label	word
	dw	DGROUP:DGROUP:_shop1+800
_shop2top	label	word
	dw	DGROUP:DGROUP:_shop2+800
_username	label	word
	dw	DGROUP:DGROUP:s@
_password	label	word
	dw	DGROUP:DGROUP:s@+8
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 33
_main	proc	near
	push	bp
	mov	bp,sp
	sub	sp,100
;	?debug	L 36
	mov	byte ptr [bp-100],0
;	?debug	L 37
	mov	byte ptr [bp-50],0
	jmp	@2
@4:
;	?debug	L 39
	mov	ax,offset DGROUP:s@+18
	push	ax
	call	near ptr _printf
	pop	cx
;	?debug	L 40
	lea	ax,word ptr [bp-100]
	push	ax
	mov	ax,offset DGROUP:s@+42
	push	ax
	call	near ptr _scanf
	pop	cx
	pop	cx
;	?debug	L 41
	lea	ax,word ptr [bp-100]
	push	ax
	call	near ptr _strlen
	pop	cx
	or	ax,ax
	jne	@5
;	?debug	L 42
	mov	ax,3
	push	ax
	call	near ptr _menu
	pop	cx
;	?debug	L 43
	jmp	short @6
@5:
	lea	ax,word ptr [bp-100]
	push	ax
	mov	ax,offset DGROUP:s@+45
	push	ax
	call	near ptr _strfcmp
	pop	cx
	pop	cx
	or	ax,ax
	jne	@7
;	?debug	L 44
	xor	ax,ax
	jmp	short @1
;	?debug	L 45
	jmp	short @8
@7:
;	?debug	L 46
	mov	ax,offset DGROUP:s@+47
	push	ax
	call	near ptr _printf
	pop	cx
;	?debug	L 47
	lea	ax,word ptr [bp-50]
	push	ax
	mov	ax,offset DGROUP:s@+70
	push	ax
	call	near ptr _scanf
	pop	cx
	pop	cx
;	?debug	L 48
	push	word ptr DGROUP:_username
	lea	ax,word ptr [bp-100]
	push	ax
	call	near ptr _strfcmp
	pop	cx
	pop	cx
	or	ax,ax
	jne	@9
	push	word ptr DGROUP:_password
	lea	ax,word ptr [bp-50]
	push	ax
	call	near ptr _strfcmp
	pop	cx
	pop	cx
	or	ax,ax
	jne	@9
;	?debug	L 49
	xor	ax,ax
	push	ax
	call	near ptr _menu
	pop	cx
;	?debug	L 50
	jmp	short @10
@9:
;	?debug	L 51
	mov	ax,offset DGROUP:s@+73
	push	ax
	call	near ptr _printf
	pop	cx
@10:
@8:
@6:
@2:
;	?debug	L 38
	jmp	@4
@3:
;	?debug	L 55
	xor	ax,ax
	jmp	short @1
@1:
;	?debug	L 56
	mov	sp,bp
	pop	bp
	ret	
_main	endp
_TEXT	ends
_DATA	segment word public 'DATA'
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 58
_menu	proc	near
	push	bp
	mov	bp,sp
	sub	sp,8
	push	si
	push	di
	mov	di,word ptr [bp+4]
;	?debug	L 59
	mov	word ptr [bp-8],0
	mov	word ptr [bp-6],0
	xor	si,si
;	?debug	L 60
	mov	word ptr [bp-4],0
	mov	word ptr [bp-2],0
	jmp	@12
@14:
;	?debug	L 62
	mov	ax,offset DGROUP:s@+106
	push	ax
	call	near ptr _printf
	pop	cx
;	?debug	L 63
	or	di,di
	jne	@15
	mov	ax,offset DGROUP:s@+122
	push	ax
	call	near ptr _printf
	pop	cx
@15:
;	?debug	L 64
	or	di,di
	jne	@16
	mov	ax,offset DGROUP:s@+139
	push	ax
	call	near ptr _printf
	pop	cx
@16:
;	?debug	L 65
	or	di,di
	jne	@17
	mov	ax,offset DGROUP:s@+173
	push	ax
	call	near ptr _printf
	pop	cx
@17:
;	?debug	L 66
	or	di,di
	jne	@18
	mov	ax,offset DGROUP:s@+204
	push	ax
	call	near ptr _printf
	pop	cx
@18:
;	?debug	L 67
	mov	ax,offset DGROUP:s@+224
	push	ax
	call	near ptr _printf
	pop	cx
;	?debug	L 68
	mov	ax,offset DGROUP:s@+240
	push	ax
	call	near ptr _printf
	pop	cx
;	?debug	L 69
	lea	ax,word ptr [bp-8]
	push	ax
	mov	ax,offset DGROUP:s@+266
	push	ax
	call	near ptr _scanf
	pop	cx
	pop	cx
	mov	word ptr [bp-6],ax
	or	ax,ax
	jne	@19
;	?debug	L 70
	jmp	@12
@19:
;	?debug	L 72
	cmp	word ptr [bp-8],1
	je	@48
	jmp	@20
@48:
;	?debug	L 73
	mov	ax,offset DGROUP:s@+269
	push	ax
	call	near ptr _printf
	pop	cx
;	?debug	L 74
	mov	ax,offset DGROUP:_globbuf
	push	ax
	mov	ax,offset DGROUP:s@+293
	push	ax
	call	near ptr _scanf
	pop	cx
	pop	cx
;	?debug	L 75
	xor	si,si
	jmp	short @24
@23:
;	?debug	L 76
	mov	ax,offset DGROUP:_globbuf
	push	ax
	mov	ax,si
	mov	dx,20
	mul	dx
	add	ax,offset DGROUP:_shop1
	push	ax
	call	near ptr _strfcmp
	pop	cx
	pop	cx
	or	ax,ax
	je	@25
;	?debug	L 77
	mov	ax,si
	mov	dx,20
	mul	dx
	add	ax,offset DGROUP:_shop1
	mov	word ptr [bp-4],ax
;	?debug	L 78
	jmp	short @21
@25:
@22:
	inc	si
@24:
	mov	ax,si
	mov	dx,20
	mul	dx
	add	ax,offset DGROUP:_shop1
	cmp	ax,word ptr DGROUP:_shop1top
	jb	@23
@21:
;	?debug	L 81
	mov	ax,si
	mov	dx,20
	mul	dx
	add	ax,offset DGROUP:_shop1
	cmp	ax,word ptr DGROUP:_shop1top
	jne	@26
;	?debug	L 82
	mov	ax,offset DGROUP:s@+296
	push	ax
	call	near ptr _printf
	pop	cx
;	?debug	L 83
	jmp	@12
@26:
;	?debug	L 85
	xor	si,si
	jmp	short @30
@29:
;	?debug	L 86
	mov	ax,offset DGROUP:_globbuf
	push	ax
	mov	ax,si
	mov	dx,20
	mul	dx
	add	ax,offset DGROUP:_shop2
	push	ax
	call	near ptr _strfcmp
	pop	cx
	pop	cx
	or	ax,ax
	je	@31
;	?debug	L 87
	mov	ax,si
	mov	dx,20
	mul	dx
	add	ax,offset DGROUP:_shop2
	mov	word ptr [bp-2],ax
;	?debug	L 88
	jmp	short @27
@31:
@28:
	inc	si
@30:
	mov	ax,si
	mov	dx,20
	mul	dx
	add	ax,offset DGROUP:_shop2
	cmp	ax,word ptr DGROUP:_shop2top
	jb	@29
@27:
;	?debug	L 91
	mov	ax,si
	mov	dx,20
	mul	dx
	add	ax,offset DGROUP:_shop2
	cmp	ax,word ptr DGROUP:_shop2top
	jne	@32
;	?debug	L 92
	mov	ax,offset DGROUP:s@+316
	push	ax
	call	near ptr _printf
	pop	cx
;	?debug	L 93
	jmp	@12
@32:
;	?debug	L 95
	mov	ax,offset DGROUP:s@+336
	push	ax
	call	near ptr _printf
	pop	cx
;	?debug	L 96
	push	word ptr [bp-4]
	mov	ax,offset DGROUP:s@+372
	push	ax
	call	near ptr _printgood
	pop	cx
	pop	cx
;	?debug	L 97
	push	word ptr [bp-2]
	mov	ax,offset DGROUP:s@+378
	push	ax
	call	near ptr _printgood
	pop	cx
	pop	cx
;	?debug	L 98
	jmp	@33
@20:
	cmp	word ptr [bp-8],2
	jne	@34
;	?debug	L 99
	or	di,di
	je	@35
	mov	ax,offset DGROUP:s@+384
	push	ax
	call	near ptr _printf
	pop	cx
	jmp	@12
@35:
;	?debug	L 100
	push	word ptr DGROUP:_shop2top
	mov	ax,offset DGROUP:_shop2
	push	ax
	push	word ptr DGROUP:_shop1top
	mov	ax,offset DGROUP:_shop1
	push	ax
	call	near ptr _MODGOODS
	add	sp,8
;	?debug	L 101
	jmp	@36
@34:
	cmp	word ptr [bp-8],3
	jne	@37
;	?debug	L 102
	or	di,di
	je	@38
	mov	ax,offset DGROUP:s@+404
	push	ax
	call	near ptr _printf
	pop	cx
	jmp	@12
@38:
;	?debug	L 103
	push	word ptr DGROUP:_shop2top
	mov	ax,offset DGROUP:_shop2
	push	ax
	push	word ptr DGROUP:_shop1top
	mov	ax,offset DGROUP:_shop1
	push	ax
	call	near ptr _CAPR
	add	sp,8
;	?debug	L 104
	jmp	@39
@37:
	cmp	word ptr [bp-8],4
	jne	@40
;	?debug	L 105
	push	word ptr DGROUP:_shop2top
	mov	ax,offset DGROUP:_shop2
	push	ax
	push	word ptr DGROUP:_shop1top
	mov	ax,offset DGROUP:_shop1
	push	ax
	call	near ptr _CPRR
	add	sp,8
;	?debug	L 106
	or	di,di
	je	@41
	mov	ax,offset DGROUP:s@+424
	push	ax
	call	near ptr _printf
	pop	cx
	jmp	short @12
@41:
;	?debug	L 107
	jmp	short @42
@40:
	cmp	word ptr [bp-8],5
	jne	@43
;	?debug	L 108
	push	word ptr DGROUP:_shop2top
	mov	ax,offset DGROUP:_shop2
	push	ax
	push	word ptr DGROUP:_shop1top
	mov	ax,offset DGROUP:_shop1
	push	ax
	call	near ptr _PAG
	add	sp,8
;	?debug	L 109
	or	di,di
	je	@44
	mov	ax,offset DGROUP:s@+444
	push	ax
	call	near ptr _printf
	pop	cx
	jmp	short @12
@44:
;	?debug	L 110
	jmp	short @45
@43:
	cmp	word ptr [bp-8],6
	jne	@46
;	?debug	L 111
	jmp	short @13
;	?debug	L 112
	jmp	short @47
@46:
	jmp	short @12
@47:
@45:
@42:
@39:
@36:
@33:
@12:
;	?debug	L 61
	jmp	@14
@13:
@11:
;	?debug	L 114
	pop	di
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_menu	endp
_TEXT	ends
_DATA	segment word public 'DATA'
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 116
_printgood	proc	near
	push	bp
	mov	bp,sp
	push	si
	mov	si,word ptr [bp+6]
;	?debug	L 117
	push	word ptr [si+16]
	push	word ptr [si+14]
	push	word ptr [si+12]
	push	si
	push	word ptr [bp+4]
	mov	ax,offset DGROUP:s@+464
	push	ax
	call	near ptr _printf
	add	sp,12
@49:
;	?debug	L 118
	pop	si
	pop	bp
	ret	
_printgood	endp
;	?debug	L 120
_strfcmp	proc	near
	push	bp
	mov	bp,sp
	push	si
;	?debug	L 121
	xor	si,si
;	?debug	L 122
	push	word ptr [bp+6]
	push	word ptr [bp+4]
	call	near ptr _strcmp
	pop	cx
	pop	cx
	mov	si,ax
	mov	ax,si
	or	ax,ax
	je	@51
	mov	ax,si
	jmp	short @50
@51:
;	?debug	L 123
	push	word ptr [bp+4]
	call	near ptr _strlen
	pop	cx
	push	ax
	push	word ptr [bp+6]
	call	near ptr _strlen
	pop	cx
	mov	dx,ax
	pop	ax
	sub	ax,dx
	jmp	short @50
@50:
;	?debug	L 124
	pop	si
	pop	bp
	ret	
_strfcmp	endp
_TEXT	ends
_BSS	segment word public 'BSS'
_globbuf	label	byte
	db	50 dup (?)
_BSS	ends
	?debug	C E9
_DATA	segment word public 'DATA'
s@	label	byte
	db	72
	db	85
	db	84
	db	90
	db	72
	db	79
	db	85
	db	0
	db	116
	db	115
	db	116
	db	112
	db	97
	db	115
	db	115
	db	119
	db	100
	db	0
	db	80
	db	108
	db	101
	db	97
	db	115
	db	101
	db	32
	db	73
	db	110
	db	112
	db	117
	db	116
	db	32
	db	85
	db	115
	db	101
	db	114
	db	32
	db	78
	db	97
	db	109
	db	101
	db	58
	db	0
	db	37
	db	115
	db	0
	db	113
	db	0
	db	80
	db	108
	db	101
	db	97
	db	115
	db	101
	db	32
	db	73
	db	110
	db	112
	db	117
	db	116
	db	32
	db	80
	db	97
	db	115
	db	115
	db	119
	db	111
	db	114
	db	100
	db	58
	db	0
	db	37
	db	115
	db	0
	db	85
	db	115
	db	101
	db	114
	db	110
	db	97
	db	109
	db	101
	db	32
	db	97
	db	110
	db	100
	db	32
	db	80
	db	97
	db	115
	db	115
	db	119
	db	111
	db	114
	db	100
	db	32
	db	77
	db	105
	db	115
	db	109
	db	97
	db	116
	db	99
	db	104
	db	33
	db	10
	db	0
	db	49
	db	46
	db	32
	db	81
	db	117
	db	101
	db	114
	db	121
	db	32
	db	71
	db	111
	db	111
	db	100
	db	115
	db	10
	db	0
	db	50
	db	46
	db	32
	db	77
	db	111
	db	100
	db	105
	db	102
	db	121
	db	32
	db	71
	db	111
	db	111
	db	100
	db	115
	db	10
	db	0
	db	51
	db	46
	db	32
	db	67
	db	97
	db	108
	db	99
	db	117
	db	108
	db	97
	db	116
	db	101
	db	32
	db	65
	db	118
	db	101
	db	114
	db	97
	db	103
	db	101
	db	32
	db	80
	db	114
	db	111
	db	102
	db	105
	db	116
	db	32
	db	82
	db	97
	db	116
	db	101
	db	10
	db	0
	db	52
	db	46
	db	32
	db	67
	db	97
	db	108
	db	99
	db	117
	db	108
	db	97
	db	116
	db	101
	db	32
	db	80
	db	114
	db	111
	db	102
	db	105
	db	116
	db	32
	db	82
	db	97
	db	116
	db	101
	db	32
	db	82
	db	97
	db	110
	db	107
	db	10
	db	0
	db	53
	db	46
	db	32
	db	80
	db	114
	db	105
	db	110
	db	116
	db	32
	db	65
	db	108
	db	108
	db	32
	db	71
	db	111
	db	111
	db	100
	db	115
	db	10
	db	0
	db	54
	db	46
	db	32
	db	81
	db	117
	db	105
	db	116
	db	32
	db	83
	db	121
	db	115
	db	116
	db	101
	db	109
	db	10
	db	0
	db	80
	db	108
	db	101
	db	97
	db	115
	db	101
	db	32
	db	115
	db	101
	db	108
	db	101
	db	99
	db	116
	db	58
	db	32
	db	40
	db	111
	db	112
	db	99
	db	111
	db	100
	db	101
	db	41
	db	62
	db	32
	db	0
	db	37
	db	100
	db	0
	db	80
	db	108
	db	101
	db	97
	db	115
	db	101
	db	32
	db	105
	db	110
	db	112
	db	117
	db	116
	db	32
	db	103
	db	111
	db	111
	db	100
	db	32
	db	110
	db	97
	db	109
	db	101
	db	58
	db	0
	db	37
	db	115
	db	0
	db	78
	db	111
	db	116
	db	32
	db	102
	db	111
	db	117
	db	110
	db	100
	db	32
	db	105
	db	110
	db	32
	db	115
	db	104
	db	111
	db	112
	db	49
	db	10
	db	0
	db	78
	db	111
	db	116
	db	32
	db	102
	db	111
	db	117
	db	110
	db	100
	db	32
	db	105
	db	110
	db	32
	db	115
	db	104
	db	111
	db	112
	db	49
	db	10
	db	0
	db	115
	db	104
	db	111
	db	112
	db	110
	db	97
	db	109
	db	101
	db	44
	db	103
	db	111
	db	111
	db	100
	db	110
	db	97
	db	109
	db	101
	db	44
	db	112
	db	114
	db	105
	db	99
	db	101
	db	44
	db	115
	db	116
	db	111
	db	99
	db	107
	db	44
	db	115
	db	111
	db	108
	db	100
	db	10
	db	0
	db	115
	db	104
	db	111
	db	112
	db	49
	db	0
	db	115
	db	104
	db	111
	db	112
	db	50
	db	0
	db	80
	db	101
	db	114
	db	109
	db	105
	db	115
	db	115
	db	105
	db	111
	db	110
	db	32
	db	68
	db	101
	db	110
	db	105
	db	101
	db	100
	db	33
	db	10
	db	0
	db	80
	db	101
	db	114
	db	109
	db	105
	db	115
	db	115
	db	105
	db	111
	db	110
	db	32
	db	68
	db	101
	db	110
	db	105
	db	101
	db	100
	db	33
	db	10
	db	0
	db	80
	db	101
	db	114
	db	109
	db	105
	db	115
	db	115
	db	105
	db	111
	db	110
	db	32
	db	68
	db	101
	db	110
	db	105
	db	101
	db	100
	db	33
	db	10
	db	0
	db	80
	db	101
	db	114
	db	109
	db	105
	db	115
	db	115
	db	105
	db	111
	db	110
	db	32
	db	68
	db	101
	db	110
	db	105
	db	101
	db	100
	db	33
	db	10
	db	0
	db	37
	db	115
	db	44
	db	37
	db	115
	db	44
	db	37
	db	100
	db	44
	db	37
	db	100
	db	44
	db	37
	db	100
	db	10
	db	0
_DATA	ends
_TEXT	segment	byte public 'CODE'
	extrn	_strcmp:near
	extrn	_strlen:near
	extrn	_printf:near
	extrn	_scanf:near
	extrn	_MODGOODS:near
	extrn	_CPRR:near
	extrn	_CAPR:near
	extrn	_PAG:near
_TEXT	ends
	public	_shop2top
	public	_shop1top
	public	_printgood
	public	_strfcmp
	public	_username
	public	_password
	public	_globbuf
	public	_menu
	public	_main
	public	_shop2
	public	_shop1
	end
