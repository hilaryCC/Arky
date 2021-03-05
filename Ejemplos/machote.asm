; Este es el machote para tener las partes basicas de un programa.

datos segment

  X db ?

datos endS

pila segment stack 'stack'
   dw 256 dup(?)
pila endS



codigo segment
       Assume CS:codigo,DS:datos,SS:pila




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

CamLin Proc
   ;Imprime un cambio de linea
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

     ;Aqui lo principal del programa

      mov ax, 4C00h

      int 21h 

codigo ends

end main
