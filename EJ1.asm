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

unirRegistro macro
    push bx
    push cx
        mov bx, 0
        mov bl, anio
        shl bx, 4
        
        mov cx, 0
        mov cl, mes
        or bx, cx
        
        shl bx, 5
        mov cl, dia
        or bx, cx 
        mov fecha, bx
    pop cx
    pop bx 
endm

org 100h

inicio:
;---------------ingresando dia
    imprimirMemoria cad_dia
    leerNumero8bits dia
    imprimirMemoria salto_linea
;---------------ingresando mes
    imprimirMemoria cad_mes
    leerNumero8bits mes
    imprimirMemoria salto_linea
;---------------ingresando anio
    imprimirMemoria cad_anio
    leerNumero8bits anio
    imprimirMemoria salto_linea
;---------------UNIR TODO A UN SOLO REGISTRO    
    unirRegistro
    imprimirMemoria cad_bin_reg
    convertirBase fecha, bin    
    imprimirMemoria salto_linea    
    imprimirMemoria cad_hex_reg
    convertirBase fecha, hex
    imprimirMemoria salto_linea    
;---------------mostrando en binario todo
    imprimirMemoria salto_linea    
    imprimirMemoria cad_binario
    imprimirMemoria cad_anio
    mov bl, anio
    convertirBase bx, bin
    imprimirMemoria salto_linea
    imprimirMemoria cad_mes
    mov bl, mes
    convertirBase bx, bin
    imprimirMemoria salto_linea
    imprimirMemoria cad_dia
    mov bl, dia
    convertirBase bx, bin
    imprimirMemoria salto_linea
;---------------mostrando en hexadecimal todo    
    imprimirMemoria salto_linea
    imprimirMemoria cad_hexadec 
    imprimirMemoria cad_anio
    mov bl, anio
    convertirBase bx, hex
    imprimirMemoria salto_linea
    imprimirMemoria cad_mes
    mov bl, mes
    convertirBase bx, hex
    imprimirMemoria salto_linea
    imprimirMemoria cad_dia
    mov bl, dia
    convertirBase bx, hex
    imprimirMemoria salto_linea
fin: int 20h

cad_anio db 'Anio :$'
cad_mes  db 'Mes :$'
cad_dia  db 'Dia :$'

fecha dw 0

salto_linea db 10, 13, '$'
cad_binario db '------------ B I N A R I O -------------', 10, 13, '$'

cad_hexadec db '-------- H E X A D E C I M A L ---------', 10, 13, '$'
cad_bin_reg db 'Reg en binario :$'
cad_hex_reg db 'Reg en hexadec :$'
dia  db 0
mes  db 0
anio db 0

bin dw 2
hex dw 16