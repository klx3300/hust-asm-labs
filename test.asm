.386
heapspace macro hsize ; creates heap space segment
    _heap segment use16
    db hsize dup(0)
    _heap ends
endm
stack segment use16 stack
    db 200 dup(0)
stack ends

data segment use16
xuehao db 4 dup(0)
data ends

heapspace 1024

extern qprintbyte:abs

code segment use16
    assume cs:code,ds:data,ss:stack,es:_heap
    jmp begin
begin:
    ; variable
    push 50
    call word ptr qprintbyte
code ends
end begin

