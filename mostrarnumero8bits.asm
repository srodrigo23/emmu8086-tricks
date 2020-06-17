
resetMemorias macro
   mov ax, 0
   mov bx, 0
   mov cx, 0
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
        resetMemorias        
        mov dx, 0
        mov bl, 10
        mov bh, num    
        mov cx, 0
    ciclo: 
        mov ax, 0
        mov al, bh
        div bl
        cmp al, 0
        je mostrar
        mov dl, ah
        push dx
        inc cx
        mov bh, al
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

; muestra en pantalla numero de 8bits

inicio:

    mov num, 0
    mostrarNumero num
    mov num, 5
    mostrarNumero num

fin: int 20h

num db 0