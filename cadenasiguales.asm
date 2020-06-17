
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h
imprimir macro c
    push ax
    push dx
        mov ax, 0
        mov ah, 9h
        mov dx, offset c
        int 21h
    pop dx
    pop ax    
endm

mostrar macro m
    local ciclo, finMostrar
    push ax
    push dx
        mov ah, 2
        mov si, offset m     
    ciclo:
        mov dl, [si]
        cmp dl, '$'
        je finMostrar
        int 21h
        inc si
        jmp ciclo
finMostrar:
    pop dx
    pop ax
endm

iguales macro c1, c2
    local ciclo
    
    mov ah, 2
    mov si, offset c1
    mov di, offset c2
ciclo:
    mov bl, [si]
    mov bh, [di]
    cmp bl, '$'
    je compConFin
    jmp sig
compConFin:
    cmp bh, '$'
    je iguales
sig:    
    cmp bh, bl
    jne desiguales
    inc si
    inc di
    jmp ciclo
iguales:
    imprimir cad_iguales
    jmp finmacro

desiguales:
    imprimir cad_desiguales
    
finmacro:    
endm

inicio:
    iguales cad1, cad2
    
fin: int 20h


cad2 db 'AAAAAAAAAaaaa$'
cad1 db 'AAAAAAAAAaaaa$'

cad_iguales    db 'iguales', 10, 13, '$'
cad_desiguales db 'desiguales', 10, 13, '$'
