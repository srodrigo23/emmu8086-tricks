imprimirMemoria macro m
    push ax
    push dx
        mov ax, 0
        mov ah, 9h
        mov dx, offset m
        int 21h
    pop dx
    pop ax
endm

leerValorEsperado macro ve
    local ciclo
    push bx
    push ax
        mov bh, ve
        mov ah, 1
    ciclo:
        int 21h
        cmp al, bh
        je fin
        imprimirMemoria salto_linea
        imprimirMemoria valor_no_permitido
        imprimirMemoria salto_linea
        jmp ciclo
    pop ax
    pop bx
endm

org 100h

inicio:
    leerValorEsperado '1'
    
    
        
fin: int 20h    

ve db '1'

salto_linea db 10, 13, '$'
valor_no_permitido db 'Valor no permitido$'