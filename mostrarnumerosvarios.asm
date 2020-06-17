
ordenarMemoria macro mem, cant
    local iteracion, ciclo, cambia, salidaRecorrido
    push ax
    push bx
    push cx
        mov bx, 0
        mov cx, cant              
        iteracion:        
            mov si, offset mem
            mov ah, 0  
            mov al, cl
            dec al
        ciclo:
            cmp ah, al
            je salidaRecorrido
            mov bh, [si]
            inc si
            mov bl, [si]
            cmp bl, bh
            jb cambia
            inc ah
            jmp ciclo
        cambia:
            dec si
            mov [si], bl
            inc si
            mov [si], bh
            inc ah
            jmp ciclo
        salidaRecorrido:
            loop iteracion
    pop cx
    pop bx
    pop ax
endm

mostrarMemoria macro mem, cant
    push cx
    push ax
        mov ax, 0            
        mov cx, cant
        mov si, offset mem
    cicloM:
        mov al, [si]         
        mostrarNumero al
        inc si
        loop cicloM
    pop ax
    pop cx    
endm

mostrarNumero macro num
    local ciclo
    local mostrar
    local cicloMostrar
    push ax
    push bx
    push cx
    push dx
        ;resetMemoria
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

org 100h

inicio:
    ;ordenarMemoria nums, 9
    mostrarMemoria nums, 7
              
fin: int 20h

nums db 1, 2, 3, 4, 5, 6, 7 
;n db 0