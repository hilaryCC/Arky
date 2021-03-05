; Este programa imprime un número en binario pero con Pipes en lugar de unos y Asteriscos en lugar de ceros.

datos segment

  N dw 630  
  Base dw 10
  
datos endS

pila segment stack 'stack'
   dw 256 dup(?)
pila endS



codigo segment
       Assume CS:codigo,DS:datos,SS:pila

Pipas proc near
;  imprime a la salida estándar el contenido del AX, cambiando 1's por pipes y 0's por asteriscos.   

   push ax
   push cx
   push dx

   mov cx, 16 
ciclo: shl ax, 1
   jc uno
   mov dl, '*'
   jmp prndigito
uno: mov dl, '|'     
prndigito: push ax
           mov ah, 02h
           int 21h
           pop ax
    loop ciclo

    call camlin

    pop dx
    pop cx
    pop ax

    ret
Pipas endp


printAX proc near    
; imprime a la salida estándar un número que supone estar en el AX
; supone que es un número positivo y natural en 16 bits.
; lo imprime en la base que indca la variable Base del Data Segment.  
    
    push AX
    push BX
    push CX                           
    push DX

    xor cx, cx
    mov bx, Base
ciclo1PAX: xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne ciclo1PAX
    mov ah, 02h
ciclo2PAX: pop DX
    add dl, 30h
    int 21h
    loop ciclo2PAX

    pop DX
    pop CX
    pop BX
    pop AX
    ret
printAX endP

CamLin Proc
   push ax
   push dx
   mov dl, 13
   mov ah, 02h
   int 21h
   mov dl, 10
   int 21h
   pop dx
   pop ax
   ret
CamLin EndP


main: mov ax, pila
      mov ss, ax

      mov ax, datos
      mov ds, ax

      mov ax, N
      call printax
      call camlin

      call Pipas

      mov ax, 4C00h

      int 21h 

codigo ends

end main
