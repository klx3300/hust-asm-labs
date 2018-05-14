.386
.model flat,stdcall
option casemap:none

@brkpt macro
    int 3
endm

WinMain  proto :DWORD,:DWORD,:DWORD,:DWORD
WndProc  proto :DWORD,:DWORD,:DWORD,:DWORD
PrintAll  proto :DWORD
Int2String proto :DWORD,:DWORD
CAPR  proto :DWORD,:DWORD,:DWORD,:DWORD

IDM_FILE_EXIT equ 10001
IDM_ACTION_LIST equ 20001
IDM_ACTION_AVG equ 20002
IDM_HELP_ABOUT equ 30001

include windows.inc
include user32.inc
include kernel32.inc
include gdi32.inc
include shell32.inc
includelib user32.lib
includelib kernel32.lib
includelib gdi32.lib
includelib shell32.lib

good struct
    tname db 10 dup(0)
    inprice dw 0
    sellprice dw 0
    stock dw 0
    sold dw 0
    profit dw 0
good ends

TOTGOODS equ 2

.data
ClassName db 'ZHWKWindowsClass',0
AppName db 'Shop Management System',0
MenuName db 'SysMenu',0
DlgName db 'Manage Your Shop, in a flash!',0
AboutMsg db 'imzhwk@2018, this software lisenced under MIT.',0
AboutMsgLim db 0
hInstance dd 0
CommandLine dd 0
shop1goods good<'book      ',35,56,70,25,0>
           good<'pen       ',12,30,25,5,0>
shop1topgoods db 0
shop2goods good<'book      ',12,28,20,15,0>
           good<'pen       ',35,50,30,24,0>
shop2topgoods db 0
itoabuf db 100 dup(0)
genbuf db 100 dup(0)
tablehint db 'name   inprice    sellprice   stock     sold     profit',0
tablehintlim db 0
keep_printing dw 0

.code
Start:
    invoke GetModuleHandle,NULL
    mov hInstance,eax
    invoke GetCommandLine
    mov CommandLine,eax
    invoke WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT
    invoke ExitProcess,eax

WinMain proc hInst:DWORD,hPrevInst:DWORD,CmdLine:DWORD,CmdShow:DWORD
    local wc:WNDCLASSEX
    local msg:MSG
    local hWnd:HWND
    invoke RtlZeroMemory,addr wc,sizeof wc
    mov wc.cbSize,sizeof WNDCLASSEX
    mov wc.style, CS_HREDRAW or CS_VREDRAW
    mov wc.lpfnWndProc, offset WndProc
    mov wc.cbClsExtra,NULL
    mov wc.cbWndExtra,NULL
    push hInst
    pop wc.hInstance
    mov wc.hbrBackground,COLOR_WINDOW+1
    mov wc.lpszMenuName,offset MenuName
    mov wc.lpszClassName,offset ClassName
    invoke LoadIcon,NULL,IDI_APPLICATION
    mov wc.hIcon,eax
    mov wc.hIconSm,0
    invoke LoadCursor,NULL,IDC_ARROW
    mov wc.hCursor,eax
    invoke RegisterClassEx,addr wc
    invoke CreateWindowEx,NULL,addr ClassName,addr AppName,\
        WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,\
        CW_USEDEFAULT,NULL,NULL,hInst,NULL
    mov hWnd,eax
    invoke ShowWindow,hWnd,SW_SHOWNORMAL
    invoke UpdateWindow,hWnd

MsgLoop:
    invoke GetMessage,addr msg,NULL,0,0
    cmp eax,0
    je ExitLoop
    invoke TranslateMessage,addr msg
    invoke DispatchMessage,addr msg
    jmp MsgLoop
ExitLoop:
    mov eax,msg.wParam
    ret
WinMain endp


WndProc proc hWnd:dword,uMsg:dword,wParam:dword,lParam:dword
    local hdc:HDC
    .if uMsg == WM_DESTROY
        invoke PostQuitMessage,NULL
    .elseif uMsg == WM_KEYDOWN
        .if wParam == VK_F1
            invoke MessageBox,hWnd,addr AboutMsg,addr AppName,MB_OK
        .endif
    .elseif uMsg == WM_COMMAND
        .if wParam == IDM_FILE_EXIT
            invoke SendMessage,hWnd,WM_CLOSE,0,0
        .elseif wParam == IDM_ACTION_LIST
            mov ebx,offset keep_printing
            mov word ptr[ebx],1
            invoke PrintAll,hWnd
        .elseif wParam == IDM_ACTION_AVG
            mov ebx,offset keep_printing
            mov word ptr[ebx],0
            invoke CAPR,addr shop1goods,addr shop1topgoods,addr shop2goods,addr shop2topgoods
        .elseif wParam == IDM_HELP_ABOUT
            invoke MessageBox,hWnd,addr AboutMsg,addr AppName,MB_OK
        .endif
    .elseif uMsg == WM_PAINT
        mov ebx,offset keep_printing
        cmp word ptr[ebx],0
        jz next
        invoke PrintAll,hWnd
        next:
        nop
    .else
        invoke DefWindowProc,hWnd,uMsg,wParam,lParam
        ret
    .endif
    xor eax,eax
    ret
WndProc endp

PrintAll proc hWnd:dword
    XBEGIN equ 10
    YBEGIN equ 10
    XSTEP equ 100
    YSTEP equ 30
    local hdc:HDC
    local ycurr:dword
    local thisgood:dword
    pusha
    mov ycurr,YBEGIN
    invoke GetDC,hWnd
    mov hdc,eax
    invoke TextOut,hdc,XBEGIN,ycurr,offset tablehint,tablehintlim-tablehint
    mov ecx,TOTGOODS
    add ycurr,YSTEP
    mov thisgood,offset shop1goods
PrintEach:
    push ecx
    invoke TextOut,hdc,XBEGIN,ycurr,thisgood,10
    add thisgood,10
    invoke Int2String,thisgood,addr itoabuf
    invoke TextOut,hdc,XBEGIN+XSTEP,ycurr,addr itoabuf,5
    add thisgood,2
    invoke Int2String,thisgood,addr itoabuf
    invoke TextOut,hdc,XBEGIN+2*XSTEP,ycurr,addr itoabuf,5
    add thisgood,2
    invoke Int2String,thisgood,addr itoabuf
    invoke TextOut,hdc,XBEGIN+3*XSTEP,ycurr,addr itoabuf,5
    add thisgood,2
    invoke Int2String,thisgood,addr itoabuf
    invoke TextOut,hdc,XBEGIN+4*XSTEP,ycurr,addr itoabuf,5
    add thisgood,2
    invoke Int2String,thisgood,addr itoabuf
    invoke TextOut,hdc,XBEGIN+5*XSTEP,ycurr,addr itoabuf,5
    add thisgood,2
    add ycurr,YSTEP
    pop ecx
    dec ecx
    cmp ecx,0
    jg near ptr PrintEach
    popa
ret
PrintAll endp
Int2String proc srcaddr:dword,dstaddr:dword
    pusha
    ;@brkpt
    mov esi,srcaddr
    mov ax,word ptr[esi]
    mov esi,dstaddr
    mov ebx,0 ;status accumulator
    cmp ax,0
    jge SkipNegative
    neg ax
    mov dl,'-'
    mov byte ptr[esi+ebx],dl
    inc esi
SkipNegative:
    xor edx,edx
    mov ecx,10
    div cx
    add dl,'0'
    push dx
    inc ebx
    cmp ax,0
    jg SkipNegative
    mov byte ptr[esi+ebx],0
    dec ebx
    xor ecx,ecx
GenString:
    pop dx
    mov byte ptr[esi+ecx],dl
    inc ecx
    cmp ecx,ebx
    jle GenString
    popa
    ret
Int2String endp
CAPR proc shop1:dword,shop1top:dword,shop2:dword,shop2top:dword
    pusha
    ;@brkpt
    mov ebx, shop1
    cmp ebx, shop1top
    je calc_avg_exit
calc_avg_passed_loop: ; start of the loop
    add ebx,10

    mov ax, word ptr[ebx] ; cost
    mov dx, word ptr[ebx+4] ; in count
    mul dx

    ; store result in ecx
    mov cx, dx
    shl ecx, 10h
    mov cx, ax
    ; revenue
    mov ax, word ptr[ebx+2] ; price
    mov dx, word ptr[ebx+6] ; sold count
    mul dx
    ; store result in edx
    shl edx, 10h
    mov dx, ax

    mov eax, edx
    sub     eax, ecx ; profit
    mov     edx, 100
    imul    edx      ; profit * 100

    idiv ecx

    mov si, ax
    ; shop 2
    mov edi, ebx
    sub ebx, shop1
    add ebx, shop2

    mov ax, word ptr[ebx] ; cost
    mov dx, word ptr[ebx+4] ; in count
    mul dx

    ; store result in ecx
    mov cx, dx
    shl ecx, 10h
    mov cx, ax
    ; revenue
    mov ax, word ptr[ebx+2] ; price
    mov dx, word ptr[ebx+6] ; sold count
    mul dx
    ; store result in edx
    shl edx, 10h
    mov dx, ax

    mov eax, edx
    sub     eax, ecx ; profit
    mov     edx, 100
    imul    edx      ; profit * 100

    idiv ecx

    add ax, si

    test ax, ax
    js calc_avg_passed_loop_neg_div

    shr ax, 1
    jmp calc_avg_passed_loop_avg_done
calc_avg_passed_loop_neg_div:
    inc ax
    sar ax, 1

calc_avg_passed_loop_avg_done:
    mov ebx, edi
    mov word ptr[ebx+8], ax ; store

    ; increment
    add ebx, 10
    ; check condition
    cmp ebx, shop1top
    jne calc_avg_passed_loop
calc_avg_exit:
    popa
    ret
CAPR endp
end Start
