
; Probado con  7 1 4

org 100h

inicio:
    mov ah, 1
    int 21h
    sub al, 30h
    mov bh, al
    int 21h
    sub al, 30h
    mov ch, al
    int 21h
    sub al, 30h
    mov dh, al
    
    cmp bh, ch
    ja salto1
    jmp salto2

salto1: 
    xchg bh, ch

salto2:
    cmp bh, dh
    ja salto3
    jmp salto4

salto3:        
    xchg bh, dh

salto4:
    cmp ch, dh
    ja salto5
    jmp continua

salto5:
    xchg ch, dh
    
continua:
    mov ax, 0    
    mov al, dh
    mov cl, 2
    div cl
    cmp ah, 0
    je mostrarMayor
    jmp siguienteCaso

mostrarMayor:
    mov ax, 0
    mov ah, 2
    mov dl, dh
    add dl, 30h
    int 21h
    jmp fin
    
siguienteCaso:
    mov ax, 0
    mov al, ch
    mov cl, 2
    div cl
    cmp ah, 1
    je mostrarMedio
    jmp casoFinal  

mostrarMedio:
    mov ax, 0
    mov ah, 2
    mov dl, ch
    add dl, 30h
    int 21h    
    jmp fin

casoFinal:
    mov bl, 3
    cmp bh, bl
    jb mostrarMenor
    jmp fin

mostrarMenor:
    mov ax, 0
    mov ah, 2
    mov dl, bh
    add dl, 30h
    int 21h             
fin:
    int 20h




