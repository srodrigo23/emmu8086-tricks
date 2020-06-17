convertirBase macro num, base
    local c1, cont, c2, letras, mostrar
    push ax
    push bx
    push cx
    push dx
        mov ax, num
        mov bx, base
        mov cx, 0
    c1: 
        div bx
        cmp ax, 0
        je cont
        inc cX
        push dx
        mov dx, 0
        jmp c1
    cont:
        push dx
        inc cx
    c2:
        pop dx
        cmp dl, 9
        ja letras
        add dl, 30h
        jmp mostrar
    letras:
        add dl, 55
    mostrar:
        mostrarCar8bits dl
        loop c2
    pop dx
    pop cx
    pop bx
    pop ax        
endm

mostrarCar8bits macro m
    push ax
    push dx
        mov ah, 2
        mov dl, m
        int 21h
    pop dx
    pop ax
endm

leerNumero8bits macro mem
    local ciclo, finIngreso
    push ax
    push bx
    push cx
    push dx    
        mov bh, 0  ; el numero a formar
        mov bl, 10 ; para mult
    ciclo:    
        mov ah, 7
        int 21h
        cmp al, 13
        je finIngreso
        
        cmp al, '0'
        jb ciclo
        cmp al, '9'
        ja ciclo
        mostrarCar8bits al        
        sub al, 30h
        mov ch, al
        mov al, bh
        mul bl
        add al, ch
        mov bh, al ; formando el numero
        jmp ciclo
finIngreso:
    mov mem, bh
    pop dx
    pop cx
    pop bx
    pop ax
endm


leerValorEsperado macro ve
    local ciclo, salirCiclo
    push bx
    push ax
        mov bh, ve
        mov ah, 1
    ciclo:
        int 21h
        cmp al, bh
        je salirCiclo
        imprimirMemoria salto_linea
        imprimirMemoria valor_no_permitido
        imprimirMemoria salto_linea
        jmp ciclo
    salirCiclo:
        imprimirMemoria salto_linea
    pop ax
    pop bx
endm

imprimirMemoria macro m
    push ax
    push dx
        mov ax, 0
        mov ah, 9h
        mov dx, offset m
        int 21h
    pop dx
    pop ax
endm

mostrar1234 macro
    imprimirMemoria menu_1
    imprimirMemoria menu_2
    imprimirMemoria menu_3
    imprimirMemoria menu_4
endm

mostrar234 macro
    imprimirMemoria menu_2
    imprimirMemoria menu_3
    imprimirMemoria menu_4
endm

mostrar34 macro
    imprimirMemoria menu_3
    imprimirMemoria menu_4
endm


mostrar4 macro
    imprimirMemoria menu_4
endm

leeOpcion macro ops, ans
    local cicloEntrada, cicloBusqueda, finMacro 
    push ax
    push dx        
    cicloEntrada:
        mov ah, 7
        int 21h
        mov si, offset ops
    cicloBusqueda:
        cmp [si], '$'
        je cicloEntrada
        cmp [si], al
        je finMacro 
        inc si
        loop cicloBusqueda
    finMacro:
        mov ans, al    
        mov ah, 2
        mov dl, al
        int 21h
    pop dx
    pop ax
endm

op_suma macro a, b, ans
    push bx
        mov bh, a
        mov bl, b
        add bh, bl
        mov ans, bh
    pop bx
endm

op_resta macro a, b, ans
    local operar
    push bx
        mov bh, a
        mov bl, b
        cmp bh, bl
        ja operar
        xchg bh, bl
    operar:
        sub bh, bl
        mov ans, bh    
    pop bx
endm

op_multiplicacion macro a, b, ans
    push ax
    push bx 
        mov ax, 0
        mov al, a
        mov bh, b
        mul bh
        mov ans, al
    pop bx
    pop ax
endm

op_division macro a, b, ans
    local operar
    push ax
    push bx
        mov bh, a
        mov bl, b
        cmp bh, bl
        ja operar
        xchg bh, bl
    operar:
        mov al, bh
        div bl
        mov ans, al 
    pop bx
    pop ax
endm

realizarOperacion macro
    local suma, resta, multiplicacion, division, finMacro
    push bx
        mov bh, op_el
        cmp bh, '+'
        je suma
        cmp bh, '-'
        je resta
        cmp bh, '*'
        je multiplicacion
        cmp bh, '/'
        je division
        
    suma:
        op_suma n1, n2, res
        jmp finMacro
    resta:
        op_resta n1, n2, res
        jmp finMacro
    
    multiplicacion:
        op_multiplicacion n1, n2, res
        jmp finMacro
    division:
        op_division n1, n2, res
        jmp finMacro
    finMacro:

    pop bx
endm

mostrarResultadoBase macro
    local binario, octal, decimal, hexadecimal, finMacro
    push bx
    push cx 
        xor bx, bx
        xor cx, cx
        
        mov bl, res ; el numero
        mov cl, base_el
        
        cmp cl, 'b'
        je binario
        cmp cl, 'o'
        je octal
        cmp cl, 'd'
        je decimal
        cmp cl, 'h'
        je hexadecimal       
        jmp finMacro
    
    binario:        
        mov cl, 2
        convertirBase bx, cx ;solo con numeros de 32bits
        jmp finMacro
    octal:
        mov cl, 8
        convertirBase bx, cx ;solo con numeros de 32bits
        jmp finMacro
    decimal:
        mov cl, 10
        convertirBase bx, cx ;solo con numeros de 32bits
        jmp finMacro
    hexadecimal:
        mov cl, 16
        convertirBase bx, cx ;solo con numeros de 32bits
        jmp finMacro
    finMacro:
    
    pop cx
    pop bx    
endm

org 100h

inicio:
    
    mostrar1234
    leerValorEsperado '1'
    
    imprimirMemoria num_1
    leerNumero8bits n1
    imprimirMemoria salto_linea
    
    imprimirMemoria num_2
    leerNumero8bits n2
    imprimirMemoria salto_linea
    
    ;------------------------------------------
    imprimirMemoria salto_linea
    mostrar234
    leerValorEsperado '2'
    leeOpcion operaciones, op_el
    realizarOperacion
    imprimirMemoria salto_linea
    
    ;------------------------------------------
    imprimirMemoria salto_linea
    mostrar34
    leerValorEsperado '3'
    leeOpcion bases, base_el
    imprimirMemoria salto_linea
    
    ;------------------------------------------
    imprimirMemoria salto_linea
    mostrar4
    leerValorEsperado '4'
    
    mostrarResultadoBase
    

fin: int 20h

valor_no_permitido db 'Valor no permitido$'

num_1 db 'Num 1=$'
num_2 db 'Num 2=$'

n1 db 0
n2 db 0
res db 0

menu_1 db '1)Ingreso de numeros', 10, 13, '$'
menu_2 db '2)Ingreso de operacion ( + , - , * , / )', 10, 13, '$'
menu_3 db '3)Seleccion de base (b, d, o, h)', 10, 13, '$'
menu_4 db '4)Mostrar el resultado', 10, 13, '$'
salto_linea db 10, 13, '$'

op_el db ' '
operaciones db '+', '-', '*', '/', '$'

base_el db ' '
bases db 'b', 'd', 'o', 'h', '$'