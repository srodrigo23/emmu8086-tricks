
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

leerNumero16bits macro mem
    local ingresaNumero
    local guardaNumero
    mov ax, 0
    mov bx, 0
    mov cx, 10 ; la base del numero 10 
    mov dx, 0
    ingresaNumero:    
        mov ah, 1  ; para la entrada
        int 21h    ;entramos
        cmp al, 13 ; enter
        je guardaNumero
        cmp al, '0' 
        jb ingresaNumero
        cmp al, '9'
        ja ingresaNumero
        
        mov dl, al ;guardo lo ingresado
        sub dl, 30h; resto para operar
        mov ax, bx ;muevo el numero para formar
        push dx
        mul cx     ;multiplico por 10
        pop dx
        add ax, dx ; sumo el digito
        mov bx, ax ; llevo a bx el numero q estoy formando
        mov ax, 0  ;limpio registro
        jmp ingresaNumero
    
    guardaNumero:
        mov mem, bx
endm


org 100h


inicio:    
    leerNumero16bits anio
    
    
    
        
fin: int 20h
            
anio dw 0            

proc saltoLinea
    mov ah, 2
    mov dl, 10
    int 21h
    mov dl, 13
    int 21h
    ret
saltoLinea endp