

 

 

mostrarnum16bits macro num
    local inicio, imprimir
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
endm 

org 100h

inicio:
     mostrarnum16bits d1
fin: int 20h

d1 dw 32456