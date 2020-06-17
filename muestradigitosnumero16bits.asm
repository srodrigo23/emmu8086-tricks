
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

inicio:
    mov ax, n1
    mov cx, 2
    mov cx, 0
ciclo:
    div  cx
    cmp  ax, 0
    je   cont
    add  dx, 30h 
    push dx
    inc cx
    xchg ax, bx
    mov  ah, 2
    int  21h
    xchg ax, bx
    
    mov  bx, 0
    mov  dx, 0
    jmp  ciclo
cont:
    push ax
    inc cx
    mov ax, 0
    mov ah, 2
c2:
    pop dx
    int 21h     
    loop c2
    
       
fin: int 20h

n1 dw 123