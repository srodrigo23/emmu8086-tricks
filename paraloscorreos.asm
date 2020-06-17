org 100h

verificaCorreo macro mail, server, iguales ans, y, g, o
    local correoCorrecto, finMacro
    push ax
        extraeCorreo correo, correo_extraido
        comparaCadenas correo_extraido, yahoo, cadenasIguales
        mov ah, cadenasIguales
        cmp ah, 1
        je correoCorrecto
        comparaCadenas correo_extraido, gmail, cadenasIguales
        mov ah, cadenasIguales
        cmp ah, 1
        je correoCorrecto
        comparaCadenas correo_extraido, outlook, cadenasIguales
        mov ah, cadenasIguales
        cmp ah, 1
        je correoCorrecto
        mov correo_correcto, 0
        jmp finMacro
    correoCorrecto:
        mov correo_correcto, 1
finMacro:
    pop ax            
endm

verificaCelularBolivia macro cel, ans
    local correcto, finMacro
    push ax
        mov si, offset cel
        mov ah, [si]
        cmp ah, '6'
        je correcto
        cmp ah, '7'
        je correcto
        mov ans, 0
        jmp finMacro
    correcto:
        mov ans, 1    
finMacro:
    pop ax
endm

verificaContrasenia macro pass, ans
    push ax    
        mov si, offset pass
    cicloMayus:
        mov ah, [si]
        inc si
        cmp ah, '$'
        je incorrecta
        cmp ah, 'A'
        jb cicloMayus
        cmp ah, 'Z'
        ja cicloMayus
        mov si, offset pass
    cicloNumero:
        mov ah, [si]
        inc si
        cmp ah, '$'
        je incorrecta
        cmp ah, '0'
        jb cicloNumero
        cmp ah, '9'
        ja cicloNumero
        mov ans, 1
        jmp finMacro
    incorrecta:
        mov ans, 0
        jmp finMacro
finMacro:    
    pop ax
endm

comparaCadenas macro c1, c2, ans
    local ciclo, compConFin, sig, iguales, desiguales, finMacro
    push ax
    push bx
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
        ;imprimir cad_iguales
        mov ans, 1
        jmp finMacro
    desiguales:
        mov ans, 0
        ;imprimir cad_desiguales  
finMacro:
    ;mov ans, 1    
    pop bx
    pop ax
endm


extraeCorreo macro email, servidor
    local ciclo, guardarCorreo, cicloGuardado, finMacro;, email, servidor 
    push ax 
        mov si, offset email
        ciclo:
            mov al, [si]
            cmp al, '@'
            je guardarCorreo:
            inc si
            jmp ciclo
        guardarCorreo:
            mov di, offset servidor
            mov ah, 0
        cicloGuardado:
            inc si
            mov al, [si]
            cmp al, '.'
            je  finMacro
            mov [di], al
            inc di
            inc ah
            jmp cicloGuardado   
finMacro:
    mov [di], '$'
    pop ax
endm
    
inicio:
    extraeCorreo correo, correo_extraido
    comparaCadenas correo_extraido, gmail, cadenasIguales
    verificaContrasenia password, pass_correct 
    verificaCorreo correo, correo_extraido, cadenasIguales,  correo_correcto, yahoo, gmail, outlook
    
        
fin: int 20h

cel db '71777821'
cel_correcto db 0

correo  db 'alguien@yahoo.com$'

password db 'abcdeF1$'
pass_correct db 0

yahoo   db 'yahoo$'
gmail   db 'gmail$'
outlook db 'outlook$'

correo_correcto db 0

correo_extraido db 20 dup(0)

cadenasIguales db 0

