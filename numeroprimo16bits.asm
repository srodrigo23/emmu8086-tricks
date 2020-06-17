; numero primo el 1234 eficiente
; debe ir de 2 hasta n/2 si encuentro un divisor

org 100h

imprimir macro cad
    mov ax, 0
    mov ah, 9h
    mov dx, offset cad
    int 21h
endm

inicio:
    mov ax, num ; habilito el numero
    mov bx, 2   ; para consguir la mitad
    div bx      ; dividir
    mov bx, ax  ; llevar la mitad a a BX  
    mov cx, 2   ; los numeros que se iarn probando
    mov dx, 0
ciclo:
    mov ax, num ; usar el num original
    cmp cx, bx  ; comparo los numeros a probar con la mitad  
    je mostrarEsPrimo ; mostra es primo
    div cx
    cmp dx, 0
    je mostrarNoEsPrimo
    inc cx
    mov dx, 0
    jmp ciclo

mostrarEsPrimo:
    imprimir esprimo
    jmp fin
mostrarNoEsPrimo:
    imprimir noesprimo
fin:
    int 20h
    
num dw 997
esprimo   db 'Es primo', 10, 13, '$'
noesprimo db 'No es primo', 10, 13, '$'