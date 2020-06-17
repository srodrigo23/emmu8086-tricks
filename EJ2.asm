calcularMediana macro mem, cn, ans
    local ciclo
    push ax
    push bx
    push cx
        mov dx, 0
        mov ax, cn
        mov bh, 2
        div bh ;---> tengo en al la mitad
        mov si, offset mem
        mov ah, 0
        ;mov dl, al
        mov cx, ax
    ciclo:
        inc si
        loop ciclo
        mov bl, [si]
        mov ans, bl
    pop cx
    pop bx
    pop ax
endm

ordenarMemoria macro mem, cant
    local iteracion, ciclo, cambia, salidaRecorrido
    push ax
    push bx
    push cx
        mov bx, 0
        mov cx, cant              
        iteracion:        
            mov si, offset mem
            mov ah, 0  
            mov al, cl
            dec al
        ciclo:
            cmp ah, al
            je salidaRecorrido
            mov bh, [si]
            inc si
            mov bl, [si]
            cmp bl, bh
            jb cambia
            inc ah
            jmp ciclo
        cambia:
            dec si
            mov [si], bl
            inc si
            mov [si], bh
            inc ah
            jmp ciclo
        salidaRecorrido:
            loop iteracion
    pop cx
    pop bx
    pop ax
endm

mostrarMemoria macro mem, cant
    push cx
    push ax
        mov ax, 0            
        mov cx, cant
        mov si, offset mem
    cicloM:
        mov al, [si]         
        mostrarNumero al
        inc si
        loop cicloM
    pop ax
    pop cx    
endm

promedio_primos macro mem, cant, resProm, resp
    local ciclo, acumular, calcularProm
    push ax
    push bx
    push cx
    push dx
        
        mov cx, cant
        mov si, offset mem
        mov ah, 0 ; para la respuesta si es primo o no
        mov al, 0 ; para sacar el numero de memoria
        mov bh, 0 ; cantidad de primos encontrados
        mov bl, 0 ; acumulador
        mov dx, 0 ; para controlar la cantidad de numeros de la memoria
    ciclo:
        cmp dx, cx
        je calcularProm
        mov al, [si]
        primo al, resp ;-> saco el primo y verifico
        mov ah, resp
        cmp ah, 1 ;entonces  -> es primo
        je acumular
        inc si
        inc dx
        jmp ciclo
    acumular:
        inc bh ; numero de primos encontrados
        inc si
        inc dx
        add bl, al
        jmp ciclo
    calcularProm:
        mov ax, 0
        mov al, bl
        div bh
        mov resProm, al    
    pop dx
    pop cx
    pop bx
    pop ax
endm

mediana_todos macro mem, cant
    

endm

leerGuardarNumeros macro mem, cant
    push bx
    push cx
    push ax
        mov ax, 0
        mov bx, 0
        mov si, offset mem
        mov cx, 0   ; los numeros que se va a guardar
        mov bh, 10
        mov bl, 0   ; el numero a formar
    ciclo:
        mov ah, 7
        int 21h
        cmp al, 13    ; guarda y sale
        je salirMacro 
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
        sub dl, 30h
        add al, dl
        mov bl, al
        jmp ciclo       
    guardar:   ;debo tener el numero en al despues de multiplicar y sumar el dig
        mov ah, 2
        mov dl, al
        int 21h   
        ;mostrarNumero bl
        mov [si], bl
        mov bl, 0
        inc si
        inc cx
        jmp ciclo
    salirMacro:
        mov cant, cx
    pop ax
    pop cx
    pop bx
endm

primo macro n, res ; 0 -> no es primo 1 -> primo  
    local ciclo, contarDiv, verifica, esPrimo, finMacro
    push ax
    push cx
    push dx
        mov cl, 1   ;para los numeros a probar
        mov ch, 0
        mov dl, n
        ciclo:
            mov ax, 0        
            mov al, dl  ; usar el num original
            cmp cl, al  ; comparo los numeros a probar con la mitad
            je verifica ; mostra es primo
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
    pop dx            
    pop cx
    pop ax        
endm 

resetMemoria macro
    mov ax, 0
    mov bx, 0
    mov cx ,0
    mov dx, 0
endm

mostrarNumero macro num
    local ciclo, mostrar, cicloMostrar
    push ax
    push bx
    push cx
    push dx
        mov bl, num ; modificamos
        mov bh, 10    
        mov cx, 0
    ciclo: 
        mov ax, 0
        mov al, bl
        div bh
        cmp al, 0
        je mostrar
        mov dl, ah
        push dx
        inc cx
        mov bl, al
        jmp ciclo
    mostrar:
        mov dl, ah
        push dx
        inc cx        
        mov ax, 0
        mov ah, 2
    cicloMostrar:
        pop dx    
        add dl, 30h
        int 21h
        loop cicloMostrar
    pop dx
    pop cx
    pop bx
    pop ax
endm

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

org 100h

inicio:
    imprimirMemoria cad_ingrese_nums
    
    leerGuardarNumeros nums, cantNums
    ;mostrarMemoria nums, cantNums
    
    imprimirMemoria salto_linea
    promedio_primos nums, cantNums, promedio, esPrimoResp
    ;sacar promedio de los primos
    imprimirMemoria salto_linea
    imprimirMemoria cad_promedio
    mostrarNumero promedio
    imprimirMemoria salto_linea
    ordenarMemoria nums, cantNums
    
    calcularMediana nums, cantNums, mediana
    
    ;sacar el del medio y ponerlo en mediana
    imprimirMemoria cad_mediana
    mostrarNumero mediana    
fin: int 20h

cad_ingrese_nums db 'Ingrese los numeros separados por un espacio :', 10, 13,'$'
cad_promedio     db 'Promedio :$'
cad_mediana      db 'Mediana  :$'

salto_linea db 10, 13, '$'
esPrimoResp db ' '

nums     db 50 dup(0)
cantNums dw 0  ;---> guardo la cantidad de numeros

promedio db 0 ; valores experimentales
mediana  db 0