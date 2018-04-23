.386
public _FUCK
_DATA segment use16 word public 'DATA'
fucka dw 15
fuckb dw 16
_DATA ends
_TEXT segment byte use16 public 'CODE'
assume cs:_TEXT,ds:_DATA
_FUCK proc near
    mov ax,word ptr offset fuckb
    ret
_FUCK endp
_CODE ends
end
