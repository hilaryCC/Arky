; Este programa calcula el factorial de un número en un procedimiento.

datos segment

  N dw 6

datos endS

pila segment stack 'stack'
   dw 256 dup(?)
pila endS



codigo segment
       Assume CS:codigo,DS:datos,SS:pila

Fac Proc
; Calcula el factorial de un número.
; Recibe el N a calcular el factorial en el Cx
; Regresa el factorial en el AX

   push cx
   push dx

ciclo: dec cx
      cmp cx, 1              
      je salir
      mul cx
      jmp ciclo 
       
salir:  

   
   pop dx
   pop cx
   
   ret   

Fac EndP


printAX proc
; imprime a la salida estándar un número que supone estar en el AX
; supone que es un número positivo y natural en 16 bits.
; lo imprime en decimal.  
    
    push AX
    push BX
    push CX
    push DX

    xor cx, cx
    mov bx, 10
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


main: mov ax, pila
      mov ss, ax

      mov ax, datos
      mov ds, ax

      ; ax acumula el resultado de las multiplicaciones
      ; cx llevamos el indice por el que multiplicamos.

      mov ax, N

      mov cx, N
      call fac
       
      call printAX

      mov ax, 4C00h

      int 21h 

codigo ends

end main
