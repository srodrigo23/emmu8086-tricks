
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt
; captura 2 numeros y mostrarlos en binario
org 100h

inicio:
    mov ah, 1
    int 21h
    mov bh, al; guarda lo capturado
    int 21h
    mov bl, al; guarda el otro numero
    sub bx, 3030h ; resto los numeros para operar
    
    mov ah, 2 ; salto de linea 
    mov dl, 10
    int 21h
    mov dl, 13
    int 21h ; salto de linea
    
    mov al, bh
    mov cx, 8

p0:
    mov dl, 18h
    rol al, 1
    rcl dl, 1
    push ax
    int 21h
    pop ax
    loop p0
    
    mov ah, 2
    mov dl, 10
    int 21h
    mov dl, 13
    int 21h
    mov cx, 8
    mov al, bl

p1:
    mov dl, 00011000b
    rol al, 1
    rcl dl, 1
    push ax
    int 21h
    pop ax
    loop p1
    
    mov ah, 2
    mov dl, 10
    int 21h
    mov dl, 13
    int 21h
    
    add bh, bl
    mov cx, 8
    mov al, bh
p2:
    mov dl, 18h
    rol al, 1
    rcl dl, 1
    push ax
    int 21h
    pop ax
    loop p2

fin:
    int 20h

    

     
    
    
    
    
    
    


