mostrarNumero macro num
    local ciclo, mostrar, cicloMostrar
    push ax
    push bx
    push cx
    push dx
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

leerNumero8bits macro num; arreglar solo numeros
    local ingresaNumero, guardaNumero
    mov ax, 0
    mov bx, 0
    mov cl, 10 ; la base del numero 10 
    mov dx, 0
    ingresaNumero:    
        mov ah, 7   ; para la entrada
        int 21h     ; entramos
        cmp al, ' ' ; espacio
        je guardaNumero
        cmp al, '0' 
        jb ingresaNumero
        cmp al, '9'
        ja ingresaNumero
        mov ah, 2
        mov dl, al
        ;int 21h
        mov dl, al ;guardo lo ingresado
        int 21h
        sub dl, 30h; resto para operar        
        mov al, bl ;muevo el numero para formar
        mul cl     ;multiplico por 10
        add al, dl ; sumo el digito
        mov bl, al ; llevo a bx el numero q estoy formando
        mov ax, 0  ;limpio registro
        jmp ingresaNumero
    guardaNumero:
        mov num, bl
endm

leerGuardarNumeros macro mem, cant
    push bx
    push cx
    push ax
        mov bx, 0
        mov si, offset mem
        mov cx, 0   ; los numeros que se va a guardar
        mov bh, 10
        mov bl, 0   ; el numero a formar
    ciclo:
        mov ah, 7
        int 21h
        cmp al, 13    ; guarda y sale
        je salirMacro 
        cmp al, ','   ; guarda
        je guardar
        cmp al, '0' 
        jb ciclo
        cmp al, '9'
        ja ciclo
        mov ah, 2
        mov dl, al
        int 21h
        mov ax, 0
        mov al, bl
        mul bh
        sub dl, 30h
        add al, dl
        mov bl, al
        jmp ciclo       
    guardar:   ;debo tener el numero en al despues de multiplicar y sumar el dig
        mov ah, 2
        mov dl, al
        int 21h   
        mostrarNumero bl
        mov [si], bl
        mov bl, 0
        inc si
        inc cx
        jmp ciclo
    salirMacro:
        mov cant, cx
    pop ax
    pop cx
    pop bx
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



org 100h

inicio:    
    ;leerNumero8bits n
    leerGuardarNumeros m, c
    ;mostrarMemoria 5
    mostrarMemoria m, c
        
fin: int 20h
;mem db 1, 2, 3, 4, 5
m db 50 dup(0)
n db ' '
c dw 0