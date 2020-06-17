verificaPassword macro pass, ans
    local ciclo ,verificaLetra, siguiente, preparaRespuesta, noCumple, finMacro
    push ax
    push bx
        ;por lo menos una mayuscula y un numero
        mov si, offset pass
        mov bh, 0 ; numeros
        mov bl, 0 ; letras
    ciclo:    
        mov ah, [si]
        cmp ah, '$'
        je preparaRespuesta
        
        cmp ah, '0'
        
        jb siguiente
        cmp ah, '9'
        
        ja verificaLetra
        
        inc bh
        jmp siguiente
    
    verificaLetra:
        cmp ah, 'A'
        jb siguiente
        cmp ah, 'Z'
        ja siguiente
        
        inc bl    
    siguiente:
        inc si
        jmp ciclo
    
    preparaRespuesta:
        cmp bh, 0
        je noCumple
        cmp bl, 0
        je noCumple 
        mov ans, 1
        jmp finMacro
    noCumple:
        mov ans, 0    
finMacro:
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


verificaCorreo macro ans
    local correoCorrecto, finMacro
    push ax
        extraeCorreo correo, servidor
        
        comparaCadenas servidor, yahoo, cadenasIguales
        mov ah, cadenasIguales
        cmp ah, 1
        je correoCorrecto
        comparaCadenas servidor, gmail, cadenasIguales
        mov ah, cadenasIguales
        cmp ah, 1
        je correoCorrecto
        comparaCadenas servidor, outlook, cadenasIguales
        mov ah, cadenasIguales
        cmp ah, 1
        je correoCorrecto
        mov ans, 0
        jmp finMacro
    correoCorrecto:
        mov ans, 1
finMacro:
    pop ax            
endm



verificaBoliviano macro ciudad, ans
    local finMacro, correcto
    push ax
        comparaCadenas ciudad, lp, cadenasIguales
        mov ah, cadenasIguales
        cmp ah, 1
        je correcto
        
        comparaCadenas ciudad, oru, cadenasIguales
        mov ah, cadenasIguales
        cmp ah, 1
        je correcto
        
        comparaCadenas ciudad, pt, cadenasIguales
        mov ah, cadenasIguales
        cmp ah, 1
        je correcto
        
        comparaCadenas ciudad, cbba, cadenasIguales
        mov ah, cadenasIguales
        cmp ah, 1
        je correcto
        
        comparaCadenas ciudad, scr, cadenasIguales
        mov ah, cadenasIguales
        cmp ah, 1
        je correcto
        
        comparaCadenas ciudad, trj, cadenasIguales
        mov ah, cadenasIguales
        cmp ah, 1
        je correcto
        
        comparaCadenas ciudad, pd, cadenasIguales
        mov ah, cadenasIguales
        cmp ah, 1
        je correcto
        
        comparaCadenas ciudad, bn, cadenasIguales
        mov ah, cadenasIguales
        cmp ah, 1
        je correcto
        
        comparaCadenas ciudad, stcr, cadenasIguales
        mov ah, cadenasIguales
        cmp ah, 1
        je correcto
        
        mov ans, 0
        jmp finMacro
    correcto:
        mov ans, 1      
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


leerLetras macro mem
    local ciclo, minusculas, finCadena
    push ax
        mov si, offset mem
        mov ah, 7
    ciclo:
        int 21h
        cmp al, 13
        je finCadena
        mov [si], al
        mostrarCar8bits al
        inc si
        jmp ciclo
            
    finCadena:
        mov [si], '$'
    pop ax
endm



leerPassword macro m
    local cicloLeer, salirCiclo
    push ax
    push bx
    push dx
        mov ax, 0
        mov si, offset m
    cicloLeer:
        mov ah, 7
        int 21h
        cmp al, 13
        je salirCiclo
        mov [si], al
        inc si
        mov ah, 2
        mov dl, '*'
        int 21h        
        jmp cicloLeer        
    salirCiclo:
        mov [si], '$'        
    pop dx
    pop bx
    pop ax
endm      

    

leerSoloNumeros macro mem
    local cicloLeer, salirCiclo
    push ax
    push bx
    push dx
        mov si, offset mem
    cicloLeer:
        mov ah, 7
        int 21h
        cmp al, 13
        je salirCiclo
        cmp al, '0'
        jb cicloLeer
        cmp al, '9'
        ja cicloLeer
        mov [si], al
        inc si
        mostrarCar8bits al
        jmp cicloLeer        
    salirCiclo:
        mov [si], '$'        
    pop dx
    pop bx
    pop ax    
endm

saltoLinea macro
    push ax
    push dx
       mov ah, 2
       mov dl, 10
       int 21h
       mov dl, 13
       int 21h
    pop dx
    pop ax   
endm

leerSoloLetras macro mem
    local ciclo, minusculas, finCadena
    push ax
        mov si, offset mem
        mov ah, 7
    ciclo:
        int 21h
        cmp al, 13
        
        je finCadena
        cmp al, 'A'
        jb ciclo
        cmp al, 'z'
        Ja al ciclo
        cmp al, 'Z'
        ja minusculas
        
        mov [si], al
        mostrarCar8bits al
        inc si
        jmp ciclo
        
    minusculas:
        cmp al, 'a'
        jb ciclo
        
        mov [si], al
        mostrarCar8bits al
        inc si
        jmp ciclo     
        
    finCadena:
        mov [si], '$'
    pop ax
endm


impMemoria macro mem
    local ciclo, finCiclo
    push ax
    push bx
        mov di, offset mem
    ciclo:
        mov ah, [di]
        cmp ah, '$'
        je finCiclo
        mov bh, ah
        mostrarCar8bits bh 
        inc di
        jmp ciclo   
    finCiclo:
    pop bx    
    pop ax    
endm

mostrarCar8bits macro mem
    push ax
    push dx
        mov ah, 2
        mov dl, mem
        int 21h
    pop dx
    pop ax
endm

org 100h

inicio:
    impMemoria cad_Facebook
    
    impMemoria cad_Nombre
    leerSoloLetras nombre
    saltoLinea
    
    impMemoria cad_apellido
    leerSoloLetras apellido
    saltoLinea
    
    impMemoria cad_Ci
    leerSoloNumeros ci
    saltoLinea
        
    impMemoria cad_Celular
    leerSoloNumeros celular
    saltoLinea
    
    impMemoria cad_Ciudad
    leerSoloLetras ciudad
    saltoLinea
    
    impMemoria cad_Correo
    leerLetras correo
    saltoLinea
    
    impMemoria cad_Password
    leerPassword password
    saltoLinea
    
    SaltoLinea
    
    verificaCelularBolivia celular, celular_corr
    mov ah, celular_corr
    cmp ah, 0
    je errorCelular 
    
    
    verificaBoliviano ciudad, ciudad_corr
    mov ah, ciudad_corr
    cmp ah, 0
    je errorCiudad 
    
    verificaCorreo correo_corr
    mov ah, correo_corr
    cmp ah, 0
    je errorCorreo 
    
    verificaPassword password password_corr
    mov ah, password_corr
    cmp ah, 0
    je errorPassword 
    
    impMemoria registro_exitoso
    jmp fin
    
errorCorreo:
    impMemoria cad_correo_no_valido
    jmp fin    

errorCiudad:
    impMemoria cad_ciudad_erronea
    jmp fin    
    
errorCelular:
    impMemoria cad_celular_no_bolivia
    jmp fin
errorPassword:
    impMemoria cad_password_no_valido
    jmp fin
    
fin: int 20h

cad_Facebook db 'FACEBOOK', 10, 13, '$'
cad_Nombre   db 'Nombre :$'
cad_Apellido db 'Apellido :$'
cad_Ci       db 'Ci :$'
cad_Celular  db 'Celular :$'
cad_Ciudad   db 'Ciudad :$'
cad_Correo   db 'Correo :$'
cad_Password db 'Contrasenia :$'

cad_celular_no_bolivia db 'Tu num. de celular no es de bolivia!!!$'
cad_correo_no_valido   db 'Tu correo no es valido!!!$'
cad_ciudad_erronea     db 'Tu no eres Boliviano$'
cad_password_no_valido db 'Tu password no es valido!!!$'

registro_exitoso db 'REGISTRO EXITOSO$'

nombre   db 20 dup(0)
apellido db 20 dup(0)
ci       db 8  dup(0)
celular  db 9  dup(0)
ciudad   db 11 dup(0)
correo   db 30 dup(0)
password db 30 dup(0)

servidor db 10 dup(0)
yahoo   db 'yahoo$'
gmail   db 'gmail$'
outlook db 'outlook$'

celular_corr  db 0
ciudad_corr   db 0
correo_corr   db 0
password_corr db 0

cbba db 'cochabamba$'
lp   db 'lapaz$'
oru  db 'oruro$'
pt   db 'potosi$'
scr  db 'chuquisaca$'
trj  db 'tarija$'
bn   db 'beni$'
pd   db 'pando$'
stcr db 'santacruz$'

cadenasIguales db 0
