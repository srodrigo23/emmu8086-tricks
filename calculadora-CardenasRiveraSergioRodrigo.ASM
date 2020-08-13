; CALCULATOR V.1.0
;------------------------------------------------
format PE GUI 4.0
entry start
include 'c:\Fasm\INCLUDE\win32ax.inc'
include 'c:\Fasm\INCLUDE\API\GDI32.inc'
;------------------------------------------------
 AW_ACTIVATE equ 00020000h
 AW_CENTER   equ 00000010h
 AW_HIDE     equ 00010000h

IDI_MAINICON equ 500
;------------------------IDS---------------
ID_ZERO  = 100
ID_ONE   = 101
ID_TWO   = 102
ID_THREE = 103
ID_FOUR  = 104
ID_FIVE  = 105
ID_SIX   = 106
ID_SEVEN = 107
ID_EIGHT = 108
ID_NINE  = 109
ID_A     = 110
ID_B     = 111
ID_C     = 112
ID_D     = 113
ID_E     = 115
ID_F     = 116

ID_PROG    = 201
ID_NORMAL  = 202
ID_BIN     = 203
ID_OCT     = 204
ID_DEC     = 205
ID_HEX     = 206
ID_DELETE  = 207
ID_MAS     = 208
ID_MENOS   = 209
ID_POR     = 210
ID_DIV     = 211
ID_1sX     = 212
ID_Sqrt    = 213
ID_CLEAR   = 214
ID_EXP     = 215
ID_PORC    = 216
ID_IGUAL   = 217

ID_PUNTO     = 218

ID_INFO_TEXT = 301
ID_SCREEN    = 302

ID_INFO_BIN   = 401
ID_SCREEN_BIN = 402
ID_INFO_OCT   = 403
ID_SCREEN_OCT = 404
ID_INFO_DEC   = 405
ID_SCREEN_DEC = 406
ID_INFO_HEX   = 407
ID_SCREEN_HEX = 408

;--------------------------------------------------
;-------------------VARIABLES----------------------
;--------------------------------------------------
section '.bss' readable writeable
  flags        dd ?
  caption      rb 40h
  message      rb 100h
  empty_screen db '',0

  num1 dd ?
  dec_num1 dd ?

  num2 dd ?
  dec_num2 dd ?

  diez dd 10
  aux dq 0
  vb dd 0

  dotn1 dd 0
  dotn2 dd 0

  ans  dq ?
  cero dq ?
  oper dd 0

  hIcon dd ?

  binary   db 40 dup (0)
  octal    db 40 dup (0)
  decimal  db 40 dup (0)
  hexadec  db 40 dup (0)

  is_standar dd 0
  base       dd 10    ; base original para formar el numero
  system_num dd 'd'   ;decimal default

  buffer rb 100
  resp_esp rb 100
  format_Out  db '%.5f',0

  caracteres db "**", 0
;-----------------------------------------------

;---------------------------------------------------------
;--------------------PRINCIPAL----------------------------
;---------------------------------------------------------
section '.text' code readable executable
  start:
        invoke  GetModuleHandle,0
        invoke  DialogBoxParam,eax,37,HWND_DESKTOP,DialogProc,0
        or      eax,eax
        jz      exit
  exit:
        invoke  ExitProcess,0

;------------FUNCTION CALLED BY DialogBoxParam--------------
proc DialogProc hwnddlg, msg, wparam, lparam
     push    ebx esi edi
     cmp     [msg] ,WM_INITDIALOG
     je      .wminitdialog
     cmp     [msg] ,WM_COMMAND
     je      .wmcommand
     cmp     [msg] ,WM_CLOSE
     je      .wmclose
     xor     eax ,eax
     jmp     .finish

  .wminitdialog:
        invoke LoadIcon,0,500
        mov [hIcon],eax
        invoke SendMessage,[hwnddlg],WM_SETICON,NULL,[hIcon]
        invoke AnimateWindow,[hwnddlg],500,AW_ACTIVATE or AW_CENTER
        invoke SetFocus,[hwnddlg]

        invoke  CheckRadioButton  ,[hwnddlg], ID_BIN  ,ID_HEX    ,ID_DEC     ; por defecto seleccionado
        invoke  CheckRadioButton  ,[hwnddlg], ID_PROG ,ID_NORMAL ,ID_NORMAL  ; por defecto seleccionado

        invoke  IsDlgButtonChecked,[hwnddlg],ID_NORMAL

        .if  eax = BST_CHECKED
             stdcall GetStandarCalculator, [hwnddlg]
             mov [is_standar], 1
        .endif

        jmp     .processed
  .wmcommand:
       mov eax, [wparam]
       .if eax = ID_PROG
           mov [is_standar], 0
           stdcall EnableAllOptions, [hwnddlg]
           invoke  IsDlgButtonChecked,[hwnddlg],ID_BIN
           .if  eax = BST_CHECKED
               stdcall GetBinaryCalculator, [hwnddlg]
           .else
               invoke  IsDlgButtonChecked,[hwnddlg],ID_OCT
               .if  eax = BST_CHECKED
                    stdcall GetOctalCalculator, [hwnddlg]
               .else
                    invoke  IsDlgButtonChecked,[hwnddlg],ID_DEC
                    .if  eax = BST_CHECKED
                        stdcall GetDecimalCalculator, [hwnddlg]
                    .else
                        stdcall GetHexaCalculator, [hwnddlg]
                    .endif
               .endif
           .endif
       .endif

       .if eax = ID_CLEAR
           stdcall ClearAll, [hwnddlg]
       .endif
       .if eax = ID_NORMAL
           mov [is_standar], 1
           stdcall GetStandarCalculator, [hwnddlg]
       .endif
       .if eax = ID_BIN
           stdcall GetBinaryCalculator, [hwnddlg]
       .endif
       .if eax = ID_OCT
           stdcall GetOctalCalculator, [hwnddlg]
       .endif
       .if eax = ID_DEC
           stdcall GetDecimalCalculator, [hwnddlg]
       .endif
       .if eax = ID_HEX
           stdcall GetHexaCalculator, [hwnddlg]
       .endif

       .if eax = ID_ONE
           stdcall make_number,[hwnddlg], 1
       .endif
       .if eax = ID_TWO
           stdcall make_number,[hwnddlg], 2
       .endif
       .if eax = ID_THREE
           stdcall make_number,[hwnddlg], 3
       .endif
       .if eax = ID_FOUR
           stdcall make_number,[hwnddlg], 4
       .endif
       .if eax = ID_FIVE
           stdcall make_number,[hwnddlg], 5
       .endif
       .if eax = ID_SIX
           stdcall make_number,[hwnddlg], 6
       .endif
       .if eax = ID_SEVEN
           stdcall make_number,[hwnddlg], 7
       .endif
       .if eax = ID_EIGHT
           stdcall make_number,[hwnddlg], 8
       .endif
       .if eax = ID_NINE
           stdcall make_number,[hwnddlg], 9
       .endif
       .if eax = ID_ZERO
           stdcall make_number,[hwnddlg], 0
       .endif
       .if eax = ID_A
           stdcall make_number,[hwnddlg], 10
       .endif
       .if eax = ID_B
           stdcall make_number,[hwnddlg], 11
       .endif
       .if eax = ID_C
           stdcall make_number,[hwnddlg], 12
       .endif
       .if eax = ID_D
           stdcall make_number,[hwnddlg], 13
       .endif
       .if eax = ID_E
           stdcall make_number,[hwnddlg], 14
       .endif
       .if eax = ID_F
           stdcall make_number,[hwnddlg], 15
       .endif
       ;----------------------OPERACIONES--------------------------------
       .if eax = ID_MAS
           mov [oper], '+'
       .endif
       .if eax = ID_MENOS
           mov [oper], '-'
       .endif
       .if eax = ID_POR
           mov [oper], '*'
       .endif
       .if eax = ID_DIV
           mov [oper], '/'
       .endif
       ;-----------------------IGUAL-------------------------------
       .if eax = ID_IGUAL
           stdcall operar, [hwnddlg]
       .endif
       ;-------------------------RAIZ-------------------------------
       .if eax = ID_Sqrt
           stdcall raiz, [hwnddlg]
       .endif
       ;------------------------1 / X-------------------------------
       .if eax = ID_1sX
           stdcall invertir, [hwnddlg]
       .endif
       ;------------------------X exp Y------------------------------
       .if eax = ID_EXP
           mov [oper], 'e'
       .endif
       ;------------------------ DELETE A NUMBER --------------------
       .if eax = ID_DELETE
          ; stdcall delete_number, [hwnddlg]
       .endif
       ;------------------------PORCENTAJE------------------------------
       .if eax = ID_PUNTO
           stdcall punto, [hwnddlg]
       .endif
       ;------------------------NEGATIVO------------------------------
       .if eax = ID_PORC
           stdcall porcentaje, [hwnddlg]
       .endif


       jmp     .processed
  .wmclose:
       invoke  AnimateWindow,[hwnddlg],500,AW_HIDE or AW_CENTER
       invoke  EndDialog,[hwnddlg],0
  .processed:
        mov     eax,1
  .finish:
        pop     edi esi ebx
        ret
endp

proc operar hwnddlg
     push eax ebx ecx

     .if [dotn1] = 1
        finit
        fild [num1]
        fild [aux]
        fadd st0, st1
        fwait
        fst [num1]

        fild [dec_num1]
        fild [aux]
        fadd st0, st1
        fwait
        fst [dec_num1]

        fld [num1]
        fld [dec_num1]
        fmul st0, st1
        fwait
        fst [num1]
        ;fld [ans]
        ;fstp [num1]
     .endif

     xor eax, eax
     mov eax, [oper]
     .if eax = '+'
         stdcall suma, [hwnddlg]
     .else
        .if eax = '-'
            stdcall resta, [hwnddlg]
        .else
            .if eax = '*'
                stdcall multiplicacion, [hwnddlg]
            .else
                .if eax = 'e'
                    stdcall exponencial, [hwnddlg]
                .else
                    stdcall division, [hwnddlg]
                .endif
            .endif
        .endif
     .endif
     invoke  MessageBox,HWND_DESKTOP,binary,'binario',MB_YESNOCANCEL
     invoke  MessageBox,HWND_DESKTOP,octal,'octal',MB_YESNOCANCEL
     pop eax ebx ecx
     ret
endp

proc showConvertedNumbers, hwnddlg, num
     push eax ebx ecx edx
     mov eax, [num]
     stdcall  ChangeBase,  2, eax ,binary
     stdcall  ChangeBase,  8, eax ,octal
     stdcall  ChangeBase, 10, eax ,decimal
     stdcall  ChangeBase, 16, eax ,hexadec

     ;invoke SetDlgItemText, [hwnddlg], ID_SCREEN_BIN, binary
     ;invoke SetDlgItemText, [hwnddlg], ID_SCREEN_OCT, octal
     ;invoke SetDlgItemText, [hwnddlg], ID_SCREEN_DEC, decimal
     invoke SetDlgItemText, [hwnddlg], ID_SCREEN_HEX, hexadec
     mov ecx, [base]
    .if ecx = 2
        ;invoke SendDlgItemMessage ,[hwnddlg], ID_SCREEN, WM_SETTEXT,0, binary
    .elseif ecx = 8

        ;invoke SendDlgItemMessage ,[hwnddlg], ID_SCREEN, WM_SETTEXT,0, octal
    .elseif ecx = 10

        invoke SendDlgItemMessage ,[hwnddlg], ID_SCREEN, WM_SETTEXT,0, decimal
    .elseif ecx = 16

        invoke SendDlgItemMessage ,[hwnddlg], ID_SCREEN, WM_SETTEXT,0, hexadec
    .endif
     pop eax ebx ecx edx
     ret
endp

proc Show_Number_In_Screens, hwnddlg, num
   push eax ebx ecx edx
     mov ebx, [is_standar]
    .if ebx = 0
         stdcall showConvertedNumbers, [hwnddlg],[num]
    .else
         invoke SetDlgItemInt,[hwnddlg],ID_SCREEN,[num],1
    .endif
   pop eax ebx ecx edx
   ret
endp

proc make_number, pWnd ,numero
     push eax ebx ecx edx
     mov ecx, [oper]
     .if ecx = 0
         xor eax, eax
         mov eax, [dotn1]
         .if eax = 0
             mov eax ,dword[num1]
             mov ebx ,[base]
             mul ebx
             add eax ,[numero]
             mov dword[num1], eax
             stdcall Show_Number_In_Screens, [pWnd] ,dword[num1]
         .else
             mov eax ,dword[dec_num1]
             mov ebx ,[base]
             mul ebx
             add eax ,[numero]
             mov dword[dec_num1] ,eax
             stdcall Show_Number_In_Screens, [pWnd], dword[dec_num1]
         .endif

     .else
          mov eax, [dotn2]
         .if eax = 0
             mov eax ,dword[num2]
             mov ebx ,[base]
             mul ebx
             add eax ,[numero]
             mov dword[num2] ,eax
             stdcall Show_Number_In_Screens, [pWnd], dword[num2]
         .else
             mov eax ,dword[dec_num2]
             mov ebx ,[base]
             mul ebx
             add eax ,[numero]
             mov dword[dec_num2] ,eax
             stdcall Show_Number_In_Screens, [pWnd], dword[dec_num2]
         .endif
     .endif
     pop eax ebx ecx edx
     ret
endp

proc suma hwnddlg
     push eax ebx ecx
     finit
     .if [is_standar]= 1

        .if [vb] = 0
           fild [num1]
           fild [aux]
           fadd st0,st1
           fst  [num1]
           mov [vb], 1
        .endif
        fwait
        fild [num2]
        fld  [aux]
        fadd st0,st1
        fstp [num2]

        fld  [num1]
        fld  [num2]
        fadd st0, st1
        fstp [ans]
        fwait
        fld  [ans]
        stdcall showAnswerOfOperations,[hwnddlg]
        fstp [num1]
     .else
        fild  [num1]
        fild  [num2]
        fadd st0, st1
        fistp [ans]
        fwait
        stdcall Show_Number_In_Screens,[hwnddlg], dword[ans]
        fild [ans]
        fistp [num1]
     .endif
     mov [num2], 0
     pop eax ebx ecx
     ret
endp

proc resta hwnddlg
     push eax ebx ecx
     finit
        mov ebx, [is_standar]
        .if ebx = 1
            .if [vb] = 0
              fild [num1]
              fild [aux]
              fadd st0,st1
              fst  [num1]
              mov [vb], 1
            .endif
              fwait
              fild [num2]
              fld  [aux]
              fadd st0,st1
              fst [num2]
              fld [num2]
              fld [num1]
              fsub st0, st1
              fwait
              fstp [ans]
              fwait

           fld [ans]
           stdcall showAnswerOfOperations,[hwnddlg]
           fstp [num1]
        .else
           fild [num2]
           fild [num1]
           fsub st0, st1
           fwait
           fistp [ans]
           fwait
           stdcall Show_Number_In_Screens,[hwnddlg],dword[ans]
           fild [ans]
           fistp [num1]
        .endif
        mov [num2], 0
     pop eax ebx ecx
     ret
endp

proc multiplicacion hwnddlg
     push eax ebx ecx edx
     finit
        mov ebx, [is_standar]
        .if ebx = 1
           .if [vb] = 0
              fild [num1]
              fild [aux]
              fadd st0,st1
              fst  [num1]
              mov [vb], 1
           .endif
           fwait
           fild [num2]
           fld  [aux]
           fadd st0,st1
           fstp [num2]

           fld  [num1]
           fld  [num2]
           fmul st0, st1
           fwait
           fst [ans]
           fwait
           stdcall showAnswerOfOperations,[hwnddlg]
           fld [ans]
           fstp [num1]
        .else
           fild  [num1]
           fild  [num2]
           fmul st0, st1
           fwait
           fistp [ans]
           stdcall Show_Number_In_Screens,[hwnddlg],dword[ans]
           fild [ans]
           fistp [num1]

        .endif

        mov dword[num2], 0
     pop eax ebx ecx edx
     ret
endp

proc division hwnddlg
     push eax ebx ecx edx
     finit
        mov ebx, [is_standar]
        .if ebx = 1
            .if [vb] = 0
               fild [num1]
               fild [aux]
               fadd st0,st1
               fst  [num1]
               mov [vb], 1
            .endif
            fwait
            fild [num2]
            fld  [aux]
            fadd st0,st1
            fstp [num2]

           fld [num2]
           fld [num1]
           fdiv st0, st1
           fstp [ans]
           fld [ans]

           stdcall showAnswerOfOperations,[hwnddlg]
           fstp [num1]
        .else

           xor edx, edx
           mov eax, [num1]
           mov ebx, [num2]
           div ebx
           mov dword[ans], eax
           ;fild  dword[eax]
           ;fistp [ans]

           ;fild[num2]
           ;fild [num1]
           ;fdiv st0, st1
           ;frndint
           ;fistp [ans]
           stdcall Show_Number_In_Screens,[hwnddlg],dword[ans]
           fld [num2]
           fld [num1]
           fdiv st0, st1
           fstp [ans]
           fld [ans]

           invoke sprintf, buffer, format_Out, dword[ans], dword[ans+4]
           invoke lstrcat, buffer, caracteres
           invoke lstrcat, buffer, hexadec
           invoke SendDlgItemMessage,[hwnddlg],ID_SCREEN_HEX,WM_SETTEXT, buffer

        .endif
        fwait
        mov [num2], 0
     pop eax ebx ecx edx
     ret
endp

proc exponencial hwnddlg
     push eax ebx ecx edx
     finit
     .if [vb] = 0
        fild [num1]
        fild [aux]
        fadd st0,st1
        fst  [num1]
        mov [vb], 1
     .endif
        fwait
        fild [num2]
        fld  [aux]
        fadd st0,st1
        fist [num2]

       mov ecx, dword[num2]
       sub ecx, 1
       fld [num1]
       fld [num1]

    .expo:
       fmul st, st1
       loop .expo
       fst [ans]
       ;fwait
       ;fld [ans]
       stdcall showAnswerOfOperations,[hwnddlg]
       ;fst [num1]
       ;mov [num2], 0
     pop eax ebx ecx edx
     ret
endp

proc raiz hwnddlg
     push eax ebx ecx edx
     finit
     .if [vb] = 0
        fild [num1]
        fild [aux]
        fadd st0,st1
        fst  [num1]
        mov [vb], 1
     .endif
        fwait
        fld  [num1]
        fsqrt
        fstp [ans]
        fwait
        stdcall showAnswerOfOperations, [hwnddlg]
        fld  [ans]
        fstp [num1]
        mov dword[num2], 0
     pop eax ebx ecx edx
     ret
endp

proc invertir hwnddlg
     push eax ebx ecx edx
     mov eax, [num1]
     mov [num2], eax
     mov [num1], 1
     stdcall  division, [hwnddlg]
     pop eax ebx ecx edx
     ret
endp

proc porcentaje hwnddlg
     push eax ebx ecx edx
     mov [num2], 100
     stdcall  division, [hwnddlg]
     pop eax ebx ecx edx
     ret
endp

proc punto hwnddlg
     push eax ebx ecx edx
     mov eax, [oper]
     .if eax = 0
         mov [dotn1], 1
     .else
         mov [dotn2], 1
     .endif
     pop eax ebx ecx edx
     ret
endp


proc showAnswerOfOperations hwnddlg
     push eax ebx ecx edx
     mov ebx, [is_standar]
     ;.if ebx = 0
     ;   stdcall , [hwnddlg]
     ;.else
        invoke sprintf, buffer, format_Out, dword[ans], dword[ans+4]
        invoke SendDlgItemMessage,[hwnddlg],ID_SCREEN,WM_SETTEXT, buffer
        ;stdcall Show_Converted_Number_In_Screens, [hwnddlg], ans
     ;.endif
     pop  eax ebx ecx edx
     ret
endp

proc ChangeBase base, dwValue, lpBuffer
     pushad
        xor  ecx , ecx
        mov  eax , [dwValue]
        mov  edi , [lpBuffer]
        mov  ebx , [base]
     .count:
        xor  edx, edx
        div  ebx  ;DIVISION!!!!!!!!
        .if edx = 10
            push 'A'
        .elseif edx = 11
            push 'B'
        .elseif edx = 12
            push 'C'
        .elseif edx = 13
            push 'D'
        .elseif edx = 14
            push 'E'
        .elseif edx = 15
            push 'F'
        .else
            add  edx, 30h
            push edx
        .endif
        inc  ecx
        or   eax, eax
        jnz .count

        ;mov eax, '0'
        ;mov [edi], eax
        ;inc edi
        ;mov [edi], ','
        ;inc edi
     .check:
        pop  edx
        mov [edi], edx
        inc edi
        loop .check

     popad
     ret
endp

proc dwtoa, dwValue, lpBuffer
     pushad
        xor  ecx , ecx
        mov  eax , [dwValue]
        mov  edi , [lpBuffer]
        mov  ebx , 10
     count:
        xor  edx, edx
        div  ebx
        add  edx, 30h
        push edx
        inc  ecx
        or   eax, eax
        jnz count
     check:
        pop  edx
        mov [edi], edx
        inc edi
        loop check
     popad
     ret
endp

proc ClearAll hwnddlg
     mov dword[num1]    , 0
     mov dword[num2]    , 0
     mov dword[oper]    , 0
     mov dword[buffer]  , 0
     mov dword[dotn1]   , 0
     mov dword[dotn2]   , 0
     mov dword[dec_num1], 0
     mov dword[dec_num2], 0
     mov dword[oper]    , 0
     mov dword[aux],     0
     mov [vb], 0
     invoke SendDlgItemMessage ,[hwnddlg], ID_SCREEN, WM_SETTEXT,0, empty_screen ;para mostrar un texto en la pantalla
     invoke SendDlgItemMessage ,[hwnddlg], ID_SCREEN_BIN, WM_SETTEXT,0, empty_screen ;para mostrar un texto en la pantalla
     invoke SendDlgItemMessage ,[hwnddlg], ID_SCREEN_OCT, WM_SETTEXT,0, empty_screen ;para mostrar un texto en la pantalla
     invoke SendDlgItemMessage ,[hwnddlg], ID_SCREEN_DEC, WM_SETTEXT,0, empty_screen ;para mostrar un texto en la pantalla
     invoke SendDlgItemMessage ,[hwnddlg], ID_SCREEN_HEX, WM_SETTEXT,0, empty_screen ;para mostrar un texto en la pantalla
     ret
endp

proc EnableAllOptions hwnddlg
     push ebx esi edi
     stdcall ClearAll, [hwnddlg]
     invoke GetDlgItem, [hwnddlg], ID_A
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_B
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_C
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_D
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_E
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_F
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_NINE
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_EIGHT
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_SEVEN
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_SIX
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_FIVE
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_FOUR
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_THREE
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_TWO
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_ONE
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_DEC
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_HEX
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_BIN
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_OCT
     invoke EnableWindow, eax, TRUE

     invoke GetDlgItem, [hwnddlg], ID_SCREEN_DEC
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_SCREEN_HEX
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_SCREEN_BIN
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_SCREEN_OCT
     invoke EnableWindow, eax, TRUE

     invoke GetDlgItem, [hwnddlg], ID_1sX
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_Sqrt
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_EXP
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_PORC
     invoke EnableWindow, eax, TRUE
     invoke GetDlgItem, [hwnddlg], ID_PUNTO
     invoke EnableWindow, eax, TRUE

     pop ebx esi edi
     ret
endp

proc GetBinaryCalculator hwnddlg
     push  ebx esi edi
     mov [system_num], 'b'
     mov [base], 2
     stdcall EnableAllOptions,[hwnddlg]
     invoke GetDlgItem, [hwnddlg], ID_A
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_B
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_C
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_D
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_E
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_F
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_NINE
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_EIGHT
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_SEVEN
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_SIX
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_FIVE
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_FOUR
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_THREE
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_TWO
     invoke EnableWindow, eax, FALSE

     invoke GetDlgItem, [hwnddlg], ID_1sX
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_Sqrt
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_EXP
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_PORC
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_PUNTO
     invoke EnableWindow, eax, FALSE

     pop ebx esi edi
     ret
endp

proc GetStandarCalculator, hwnddlg
     push  ebx esi edi
     stdcall EnableAllOptions, [hwnddlg]
     invoke GetDlgItem, [hwnddlg], ID_A
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_B
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_C
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_D
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_E
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_F
     invoke EnableWindow, eax, FALSE

     invoke GetDlgItem, [hwnddlg], ID_DEC
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_HEX
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_BIN
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_OCT
     invoke EnableWindow, eax, FALSE

     invoke GetDlgItem, [hwnddlg], ID_SCREEN_DEC
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_SCREEN_HEX
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_SCREEN_BIN
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_SCREEN_OCT
     invoke EnableWindow, eax, FALSE

     pop ebx esi edi
     ret
endp

proc GetHexaCalculator, hwnddlg
     push  ebx esi edi
      mov [system_num], 'h'
      mov [base], 16
     stdcall EnableAllOptions,[hwnddlg]

     invoke GetDlgItem, [hwnddlg], ID_1sX
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_Sqrt
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_EXP
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_PORC
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_PUNTO
     invoke EnableWindow, eax, FALSE

     pop ebx esi edi
     ret
endp

proc GetOctalCalculator, hwnddlg
     push  ebx esi edi
      mov [system_num], 'o'
      mov [base], 8
     stdcall EnableAllOptions,[hwnddlg]
     invoke GetDlgItem, [hwnddlg], ID_A
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_B
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_C
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_D
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_E
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_F
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_NINE
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_EIGHT
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_1sX
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_Sqrt
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_EXP
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_PORC
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_PUNTO
     invoke EnableWindow, eax, FALSE
     pop ebx esi edi
     ret
endp

proc GetDecimalCalculator, hwnddlg
     push  ebx esi edi
     stdcall EnableAllOptions,[hwnddlg]
      mov [system_num], 'd'
      mov [base], 10
     invoke GetDlgItem, [hwnddlg], ID_A
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_B
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_C
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_D
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_E
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_F
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_1sX
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_Sqrt
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_EXP
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_PORC
     invoke EnableWindow, eax, FALSE
     invoke GetDlgItem, [hwnddlg], ID_PUNTO
     invoke EnableWindow, eax, FALSE
     pop   ebx esi edi
     ret
endp
;-------------------------------------------------------------
section '.idata' import data readable writeable
  library kernel,'KERNEL32.DLL',\
          user,'USER32.DLL',\
          msvcrt,'MSVCRT.DLL'

  import kernel,\
         GetModuleHandle,'GetModuleHandleA',\
         lstrcat, 'lstrcat',\
         ExitProcess,'ExitProcess'
  import msvcrt, \
         sprintf, 'sprintf'

  import user,\
         AnimateWindow, 'AnimateWindow',\
         SetDlgItemInt, 'SetDlgItemInt',\
         GetDlgItem, 'GetDlgItem',\
         EnableWindow, 'EnableWindow',\
         SetFocus , 'SetFocus',\
         SendMessage , 'SendMessageA',\
         SendDlgItemMessage,'SendDlgItemMessageA',\
         SetDlgItemText,'SetDlgItemTextA',\
         DialogBoxParam,'DialogBoxParamA',\
         CheckRadioButton,'CheckRadioButton',\
         GetDlgItemText,'GetDlgItemTextA',\
         IsDlgButtonChecked,'IsDlgButtonChecked',\
         MessageBox,'MessageBoxA',\
         LoadIcon , 'LoadIconA',\
         EndDialog,'EndDialog'

section '.rsrc' resource data readable

  directory  RT_DIALOG,dialogs,\
  RT_ICON, icons,\
  RT_GROUP_ICON, group_icons

  resource dialogs,\
           37,LANG_ENGLISH+SUBLANG_DEFAULT,demonstration

  resource icons,\
  1,LANG_NEUTRAL,icon_data
  resource group_icons,\
  17,LANG_NEUTRAL,main_icon

  icon main_icon, icon_data, 'MAINICON.ICO'

 pos_x = 300
 pos_y = 100
 tam_x = 335
 tam_y = 225

 dist_x = 10
 dist_y = 10
 x_button = 160
 y_button = 85

 tam_button_x = 25
 tam_button_y = 25

 pos_sistema_x = 10 ;vertical
 pos_sistema_y = 140

 pos_tipo_x = 10
 pos_tipo_y = 85

  dialog demonstration,'CALCULADORA', pos_x, pos_y, tam_x ,tam_y,WS_CAPTION+WS_POPUP+WS_SYSMENU+DS_MODALFRAME

    dialogitem 'EDIT','',ID_SCREEN,   10, 10, 315 ,25 ,WS_VISIBLE+WS_BORDER+WS_TABSTOP+ES_AUTOHSCROLL+SS_RIGHT;+WS_DISABLED

    dialogitem 'BUTTON' ,'&Tipo de calculadora' , -1 , pos_tipo_x, pos_tipo_y      ,70,50 ,WS_VISIBLE+BS_GROUPBOX
    dialogitem 'BUTTON' ,'Programador',ID_PROG       , pos_tipo_x+5, pos_tipo_y+15 ,60,13 ,WS_VISIBLE+BS_AUTORADIOBUTTON+WS_TABSTOP+WS_GROUP
    dialogitem 'BUTTON' ,'Estandar'     ,ID_NORMAL     , pos_tipo_x+5, pos_tipo_y+30 ,60,13 ,WS_VISIBLE+BS_AUTORADIOBUTTON

    dialogitem 'BUTTON' ,'&Sistema'    , -1    ,pos_sistema_x  ,pos_sistema_y    ,70,80        ,WS_VISIBLE+BS_GROUPBOX
    dialogitem 'BUTTON' ,'Binario'     ,ID_BIN ,pos_sistema_x+5,pos_sistema_y+15 ,60,13 ,WS_VISIBLE+BS_AUTORADIOBUTTON+WS_TABSTOP+WS_GROUP
    dialogitem 'BUTTON' ,'Octal'       ,ID_OCT ,pos_sistema_x+5,pos_sistema_y+30 ,60,13 ,WS_VISIBLE+BS_AUTORADIOBUTTON
    dialogitem 'BUTTON' ,'Decimal'     ,ID_DEC ,pos_sistema_x+5,pos_sistema_y+45 ,60,13 ,WS_VISIBLE+BS_AUTORADIOBUTTON
    dialogitem 'BUTTON' ,'Hexadecimal' ,ID_HEX ,pos_sistema_x+5,pos_sistema_y+60 ,60,13 ,WS_VISIBLE+BS_AUTORADIOBUTTON

    dialogitem 'BUTTON','7' ,ID_SEVEN  ,x_button ,y_button,tam_button_x,tam_button_y     ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON;+WS_DISABLED
    dialogitem 'BUTTON','8' ,ID_EIGHT  ,x_button+35 ,y_button,tam_button_x,tam_button_y  ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON
    dialogitem 'BUTTON','9' ,ID_NINE   ,x_button+70 ,y_button,tam_button_x,tam_button_y  ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON

    dialogitem 'BUTTON','4' ,ID_FOUR   ,x_button ,y_button+35,tam_button_x,tam_button_y      ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON
    dialogitem 'BUTTON','5' ,ID_FIVE   ,x_button+35 ,y_button+35 ,tam_button_x ,tam_button_y ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON
    dialogitem 'BUTTON','6' ,ID_SIX    ,x_button+70 ,y_button+35 ,tam_button_x ,tam_button_y ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON

    dialogitem 'BUTTON','1' ,ID_ONE    ,x_button ,y_button+70,tam_button_x,tam_button_y    ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON
    dialogitem 'BUTTON','2' ,ID_TWO    ,x_button+35 ,y_button+70,tam_button_x,tam_button_y ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON
    dialogitem 'BUTTON','3' ,ID_THREE  ,x_button+70 ,y_button+70,tam_button_x,tam_button_y ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON

    dialogitem 'BUTTON','0' ,ID_ZERO , x_button, y_button+105, tam_button_x*2+10, tam_button_y  ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON

    dialogitem 'BUTTON','.' ,ID_PUNTO , x_button+70   , y_button+105, tam_button_x, tam_button_y  ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON
    dialogitem 'BUTTON','+' ,ID_MAS  , x_button+105  , y_button+105, tam_button_x, tam_button_y  ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON
    dialogitem 'BUTTON','-' ,ID_MENOS , x_button+105 , y_button+70, tam_button_x, tam_button_y  ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON
    dialogitem 'BUTTON','*' ,ID_POR , x_button+105   , y_button+35, tam_button_x, tam_button_y  ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON
    dialogitem 'BUTTON','/' ,ID_DIV , x_button+105   , y_button, tam_button_x, tam_button_y  ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON

    dialogitem 'BUTTON','A' ,ID_A , x_button-70  , y_button  , tam_button_x, tam_button_y  ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON
    dialogitem 'BUTTON','B' ,ID_B , x_button-35  , y_button     , tam_button_x, tam_button_y  ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON;+WM_ENABLE
    dialogitem 'BUTTON','C' ,ID_C , x_button-70  , y_button+35  , tam_button_x, tam_button_y  ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON
    dialogitem 'BUTTON','D' ,ID_D , x_button-35  , y_button+35  , tam_button_x, tam_button_y  ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON
    dialogitem 'BUTTON','E' ,ID_E , x_button-70  , y_button+70 , tam_button_x, tam_button_y  ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON
    dialogitem 'BUTTON','F' ,ID_F , x_button-35  , y_button+70 , tam_button_x, tam_button_y  ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON

    dialogitem 'BUTTON','1/x'  ,ID_1sX   ,x_button-70  ,y_button+105 , tam_button_x, tam_button_y  ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON
    dialogitem 'BUTTON','Sqrt' ,ID_Sqrt  ,x_button-35  ,y_button+105 , tam_button_x, tam_button_y  ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON

    dialogitem 'BUTTON','CE'  ,ID_CLEAR ,x_button+140  ,y_button , tam_button_x, tam_button_y  ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON
    dialogitem 'BUTTON','x^y' ,ID_EXP   ,x_button+140  ,y_button+35 , tam_button_x, tam_button_y  ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON
    dialogitem 'BUTTON','%'   ,ID_PORC  ,x_button+140  ,y_button+70 , tam_button_x, tam_button_y  ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON
    dialogitem 'BUTTON','='   ,ID_IGUAL ,x_button+140  ,y_button+105 , tam_button_x, tam_button_y  ,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON

    dialogitem 'BUTTON','Sistemas',-1, 10, 40, 315, 40,BS_GROUPBOX+WS_VISIBLE,0
    ;dialogitem 'STATIC',"BIN : ",ID_INFO_BIN   ,  20, 50, 65, 10, SS_LEFT+WS_GROUP+WS_VISIBLE,0
    ;dialogitem 'EDIT',   ''     ,ID_SCREEN_BIN ,  20, 60, 65, 15, WS_VISIBLE+WS_BORDER+WS_TABSTOP+ES_AUTOHSCROLL+SS_RIGHT;+WS_DISABLED
   ; dialogitem 'STATIC',"OCT : ",ID_INFO_OCT   ,  95, 50, 65, 10, SS_LEFT+WS_GROUP+WS_VISIBLE,0
   ; dialogitem 'EDIT',   ''     ,ID_SCREEN_OCT ,  95, 60, 65, 15, WS_VISIBLE+WS_BORDER+WS_TABSTOP+ES_AUTOHSCROLL+SS_RIGHT;+WS_DISABLED
    ;dialogitem 'STATIC',"DEC : ",ID_INFO_DEC   , 175, 50, 65, 10, SS_LEFT+WS_GROUP+WS_VISIBLE,0
   ; dialogitem 'EDIT',   ''     ,ID_SCREEN_DEC , 175, 60, 65, 15, WS_VISIBLE+WS_BORDER+WS_TABSTOP+ES_AUTOHSCROLL+SS_RIGHT;+WS_DISABLED
    dialogitem 'STATIC',"HEX : ",ID_INFO_HEX   , 250, 50, 65, 10, SS_LEFT+WS_GROUP+WS_VISIBLE,0
    dialogitem 'EDIT',''        ,ID_SCREEN_HEX , 250, 60, 65, 15, WS_VISIBLE+WS_BORDER+WS_TABSTOP+ES_AUTOHSCROLL+SS_RIGHT;+WS_DISABLED
  enddialog