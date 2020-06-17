
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

inicio:

    mov bx, 0
    mov si, offset mem
    mov cx, 0   ; los numeros que se va a guardar
    mov bh, 10
    mov bl, 0   ; el numero a formar
ciclo:
    mov ah, 7
    int 21h
    cmp al, 13    ; guarda y sale
    je fin 
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
    sub dl, 30h ;;;;;;;;;;;
    add al, dl
    mov bl, al
    jmp ciclo       
guardar:   ;debo tener el numero en al despues de multiplicar y sumar el dig
    mov ah, 2
    mov dl, al
    int 21h   
    ;mostrarNumero bl
    mov [si], bl
    
    inc si
    inc cx
    jmp ciclo
    
    
fin: int 20h


mem db 50 dup(0)
