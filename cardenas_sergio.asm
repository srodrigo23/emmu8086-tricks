; ----------------------------------------------;
; NOMBRE  : SERGIO RODRIGO CARDENAS RIVERA      ;
; CI      : 5540408                             ;
; CODSIS  : 201001616                           ;
; GRUPO   : 1                                   ;
; CARRERA : ING. INFORMATICA                    ;
;-----------------------------------------------;


; ------- MACROS UTILIZADAS
; compara cadenas
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
mostrarnum16bits macro num
    local inicio, imprimir, finMacro
    push ax
    push bx
    push cx
    push dx
    	mov cx,0 
    	mov dx,0
    	mov ax, num 
    	inicio: 
    		cmp ax,0 
    		je imprimir	 
    		mov bx, 10		 
    		div bx				 
    		push dx			 
    		inc cx			 
    		xor dx,dx 
    		jmp inicio 
    	imprimir: 
    		cmp cx,0 
    		je finMacro
    		pop dx 		
    		add dx,48 		
    		mov ah,02h 
    		int 21h 
    		dec cx 
    		jmp imprimir
finMacro:
    pop dx
    pop cx
    pop bx
    pop ax
endm 

mostrarResultado macro
    mov ax, 0
    mov si, offset nom
    mov ah, [si]
    mostrarCar8bits ah
    inc si
    mov ah, [si]
    mostrarCar8bits ah
    
    mov si, offset ape
    mov ah, [si]
    mostrarCar8bits ah
    inc si
    mov ah, [si]
    mostrarCar8bits ah
    mostrarnum16bits promo
    
    mov si, offset nac
    mov ah, [si]
    mostrarCar8bits ah
    
    mostrarCar8bits '*'
    impMemoria nom
    mostrarCar8bits '*'
    impMemoria ape
    mostrarCar8bits '*'
    impMemoria ci
    mostrarCar8bits '*'
    impMemoria cel
    mostrarCar8bits '*'
    mostrarnum16bits promo
    mostrarCar8bits '*'
    impMemoria nac
endm

habilPorEdad macro ans
    local noHabil, finMacro
    push ax
    push bx
    push cx
    push dx
        mov dx, 0    
        mov ax, promo
        mov bx, anio_actual
        sub bx, ax ;dif anios
        mov cx, 18
        add cx, bx
        cmp cx, max_edad
        ja noHabil
        mov dh, 1
        jmp finMacro    
    noHabil:    
        mov dh, 0
finMacro:
    mov ans, dh
    pop dx
    pop cx
    pop bx
    pop ax 
endm
        
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

verificaCochalo macro ans
    local finMacro, correcto
    push ax
        comparaCadenas nac, punata, cadenasIguales
        mov ah, cadenasIguales
        cmp ah, 1
        je correcto
        
        comparaCadenas nac, sacaba, cadenasIguales
        mov ah, cadenasIguales
        cmp ah, 1
        je correcto
        
        comparaCadenas nac, quilla, cadenasIguales
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

org 100h


;--------PROGRAMA PRINCIPAL--------
inicio:
    impMemoria men_reg_cuartel
    impMemoria men_nombre
    leerSoloLetras nom
    saltoLinea
    
    impMemoria men_apel
    leerSoloLetras ape
    saltoLinea
    
    impMemoria men_ci
    leerSoloNumeros ci
    saltoLinea
    
    impMemoria men_cel
    leerSoloNumeros cel
    saltoLinea
    
    impMemoria men_promo
    leerNumero16bits promo
    saltoLinea
    
    impMemoria men_nac 
    leerSoloLetras nac
    saltoLinea
    ;-------------------
    ; para la edad
    ;-------------------
    habilPorEdad habil_edad
    mov ah, habil_edad
    cmp ah, 0
    je no_es_habil
    jmp verificar_datos
no_es_habil:
    impMemoria men_reg_fuera_edad
    jmp fin
    
verificar_datos:
     
    verificaCochalo loca_corr
    mov ah, loca_corr
    cmp ah, 0
    je mostrar_error
    
    verificaCelularBolivia cel, celular_corr
    mov ah, celular_corr
    cmp ah, 0
    je mostrar_error
       
    mostrarResultado
    jmp fin
    
mostrar_error:
      impMemoria men_reg_no_rea
 
fin: int 20h

;--------------RESERVAS------------
nom db 20 dup(0)
ape db 20 dup(0)
ci db 9 dup(0)
cel db 9 dup(0)

promo dw 0

nac db 20 dup(0)

men_reg_cuartel db '---REGISTRO AL CUARTEL---', 10, 13, '$'
men_nombre db 'Nombre: $'
men_apel   db 'Apellido: $'
men_ci db 'CI: $'
men_cel db 'Celular: $'
men_promo db 'Promo: $'
men_nac db 'Lugar de nac.: $'

; MENSAJES
men_reg_no_rea     db 'REGISTRO NO REALIZADO!!$'
men_reg_fuera_edad db 'No puede ser registrado por edad$'

anio_actual dw 2020
habil_edad db 0
max_edad dw 23

punata db 'punata$'
sacaba db 'sacaba$'
quilla db 'quillacollo$'

loca_corr   db 0
celular_corr  db 0
cadenasIguales db 0