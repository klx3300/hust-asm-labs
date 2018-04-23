	ifndef	??version
?debug	macro
	endm
	endif
	?debug	S "zhwktst.c"
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
	?debug	C E9BB09974C097A68776B7473742E63
	?debug	C E9D702974C15433A5C54435C494E434C5544455C737464696F2E68
	?debug	C E9D702974C16433A5C54435C494E434C5544455C7374646172672E+
	?debug	C 68
_BSS	ends
_DATA	segment word public 'DATA'
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 4
_main	proc	near
;	?debug	L 5
	mov	bx,word ptr DGROUP:_SCORES
	mov	byte ptr [bx],70
;	?debug	L 6
	push	word ptr DGROUP:_SCORES
	mov	ax,offset DGROUP:s@
	push	ax
	call	near ptr _printf
	pop	cx
	pop	cx
;	?debug	L 7
	xor	ax,ax
	jmp	short @1
@1:
;	?debug	L 8
	ret	
_main	endp
_TEXT	ends
	?debug	C E9
_DATA	segment word public 'DATA'
s@	label	byte
	db	70
	db	85
	db	67
	db	75
	db	32
	db	84
	db	67
	db	32
	db	37
	db	115
	db	10
	db	0
_DATA	ends
	extrn	_SCORES:word
_TEXT	segment	byte public 'CODE'
	extrn	_printf:near
_TEXT	ends
	public	_main
	end
