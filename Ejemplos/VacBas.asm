; Este es un programa que trabaja cosas básicas en un vector de números enteros.

datos segment

  V db -10,5,20,5,0,10,-20,30,10,0
  N dw 10

  Base dw 10
datos endS

pila segment stack 'stack'
   dw 256 dup(?)
pila endS




codigo segment
       Assume CS:codigo,DS:datos,SS:pila


prom Proc
; Calcula el promedio del vector que recibe en [si].  El tamaño lo recibe en el CX.
; Retorna en el AX el promedio de los datos.  Supone enteros de 8 bits 

             push bx
             push cx
             push dx
             push si
                 
             xor ax, ax
             xor bx, bx
             xor dh, dh
 prom_ciclo: mov dl, byte ptr [si]
             add ax, dx
             inc bx
             inc si 
             loop prom_ciclo
             xor dx, dx
             idiv bx

             pop si
             pop dx
             pop cx
             pop bx

             ret 
prom EndP

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


      lea si, V
      mov Cx, N
      call prom
      call printax

      mov ax, 4C00h

      int 21h 

codigo ends

end main
