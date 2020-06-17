
;EJERCICIO 

resetMemoria macro
    mov ax, 0
    mov bx, 0
    mov cx ,0
    mov dx, 0
endm

mostrarNumero macro num
    local ciclo
    local mostrar
    local cicloMostrar
    push ax
    push bx
    push cx
    push dx
        resetMemoria
        mov bl, num ; modificamos
        mov bh, 10    
        mov cx, 0
    ciclo: 
        mov ax, 0
        mov al, bl
        div bh
        cmp al, 0
        je mostrar
        mov dl, ah
        push dx
        inc cx
        mov bl, al
        jmp ciclo
    mostrar:
        mov dl, ah
        push dx
        inc cx        
        mov ax, 0
        mov ah, 2
    cicloMostrar:
        pop dx    
        add dl, 30h
        int 21h
        loop cicloMostrar
    pop dx
    pop cx
    pop bx
    pop ax
endm

suma macro num
    local cicloSuma
    mov bh, 1
    mov cx, 10
cicloSuma:
    mostrarNumero num
    imprimirRegistro '+'
    mov numMos, bh
    mostrarNumero numMos
    imprimirRegistro '='
    mov ah, num
    add ah, bh
    mov numMos, ah   
    mostrarNumero numMos
    imprimir saltoLinea
    inc bh
    loop cicloSuma
endm


resta macro num
    local cicloResta
    mov bh, num
    mov cx, 10
cicloResta:
    mov numMos, bh
    mostrarNumero numMos
    imprimirRegistro '-'
    mostrarNumero num
    imprimirRegistro '='
    mov ah, bh
    sub ah, num
    mov numMos, ah
    mostrarNumero numMos
    imprimir saltoLinea
    inc bh
    loop cicloResta    
endm

multiplicacion macro num
    local cicloMul
    mov cx, 10
    mov bh, 1
cicloMul:
    mov ax, 0
    mostrarNumero num
    imprimirRegistro '*'
    mov numMos, bh
    mostrarNumero numMos
    imprimirRegistro '='
    mov al, num
    mul bh
    mov numMos, al
    mostrarNumero numMos
    imprimir saltoLinea
    inc bh
    loop cicloMul
endm

division macro num 
    local cicloDiv
    mov cx, 10
    mov bh, num
cicloDiv:
    mov ax, 0
    mov numMos, bh
    mostrarNumero numMos
    imprimirRegistro '/'
    mostrarNumero num
    imprimirRegistro '='
    mov bl, num
    mov al, bh
    div bl
    mov numMos, al
    mostrarNumero numMos
    imprimir saltoLinea
    add bh, num
    loop cicloDiv   
endm


imprimir macro c
    push ax
    push dx
        mov ax, 0
        mov ah, 9h
        mov dx, offset c
        int 21h
    pop dx
    pop ax    
endm

imprimirRegistro macro s
    push ax
    push dx
        mov ax, 0
        mov dx, 0
        mov ah, 2
        mov dl, s
        int 21h 
    pop dx
    pop ax        
endm

;XXXXXXXXXXXXXXXXXXXXXXXX PRINCIPAL XXXXXXXXXXXXXXXXXXXXXXXX
org 100h
inicio:
     imprimir cad1
     mov ah, 1
     mov cx, 0
cicloCaracteres:
     int 21h
     cmp al, 13
     je pedirCaracter
     mov bl, al
     push bx
     inc cx
     jmp cicloCaracteres
     
pedirCaracter:
     imprimir saltoLinea
     imprimir cad2
     mov ah, 1
     int 21h
     mov bx, 0
     mov bl, al
     
     mov al, 0
cicloContar:
     pop dx 
     cmp bx, dX
     jne continua
     inc al
     
continua:
     loop cicloContar
     
     mov num, al
     mov bx, 0
     
     imprimir saltoLinea
     
     imprimir menTab
     mostrarNumero num
     
     imprimir saltoLinea
     imprimir menSuma
     suma num
     
     imprimir saltoLinea
     imprimir menResta
     resta num
     
     imprimir saltoLinea
     imprimir menMulti
     multiplicacion num
     
     imprimir saltoLinea
     imprimir menDiv
     division num
     
fin: int 20h                                                        

cad1 db 'Ingrese todos los caracteres, hasta presionar enter', 10, 13, '$'
cad2 db 'Ingrese el caracter a contar :$'

saltoLinea db 10, 13, '$'

menTab   db 'TABLA ARITMETICA DE $'
menSuma  db 'SUMA',10, 13, '$'
menResta db 'RESTA',10, 13, '$' 
menMulti db 'MULTIPLICACION',10, 13, '$' 
menDiv   db 'DIVISION',10, 13, '$' 

num db 0
numMos db 0
simbolo db ' '