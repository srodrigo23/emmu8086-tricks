
org 100h

imprimir macro cad
    mov ax, 0
    mov ah, 9h
    mov dx, offset cad
    int 21h
endm

primo macro n, res ; 0 -> no es primo 1 -> primo
    local ciclo, contarDiv, verifica, esPrimo, finMacro
    mov cl, 1   ;para los numeros a probar
    mov ch, 0
    ciclo:
        mov ax, 0
        mov al, n ; usar el num original
        cmp cl, al  ; comparo los numeros a probar con la mitad  
        je verifica  ; mostra es primo
        div cl
        cmp ah, 0
        je contarDiv
        inc cl
        jmp ciclo
    contarDiv:
        inc ch
        inc cl
        jmp ciclo
    verifica:
        cmp ch, 1
        je esPrimo
        mov res, 0
        jmp finMacro
    esPrimo:
        mov res, 1
finMacro:            
    pop cx
    pop bx
    pop ax        
endm 

inicio:
    primo num ans    
fin:
    int 20h
    
num db 7
ans db 0