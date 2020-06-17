
org 100h
 
mostrarCar8bits macro m
    push ax
    push dx
        mov ah, 2
        mov dl, m
        int 21h
    pop dx
    pop ax
endm
 
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



convertirBinario macro num
    local c1, cont, c2
    push ax
    push bx
    push cx
    push dx
        mov ax, num
        mov bx, 2
        mov cx, 0
    c1: 
        div bx
        cmp ax, 0
        je cont
        inc cx
        add dl, 30h
        push dx
        mov dx, 0
        jmp c1
    cont:
        add dl, 30h      
        push dx
        inc cx
    c2:
        pop dx
        mostrarCar8bits dl
        loop c2
    pop dx
    pop cx
    pop bx
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


inicio:
    ;leerNumero8bits dia
    ;leerNumero8bits mes
    ;leerNumero8bits anio
    ;convertirBinario num16bits
    convertirBase num16bits, base
fin:    
    int 20h    
        
dia  db 0
mes  db 0
anio db 0

num16bits dw 9999
base dw 16