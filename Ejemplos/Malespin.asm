; Este programa recibe un texto en minúscula en la línea de comandos y lo pasa a malespin
; Cambios:  A-E   I-O   F-G   T-B   P-M 

;  TUANIS       PELIS        BRETEJI



datos segment

  X db ?

datos endS

pila segment stack 'stack'
   dw 256 dup(?)
pila endS



codigo segment
       Assume CS:codigo,DS:datos,SS:pila

main: mov ax, pila
      mov ss, ax

      push ds
      pop es

      mov ax, datos
      mov ds, ax

      mov si, 80h
      mov cl, byte ptr Es:[si]
      xor ch, ch     ; CX queda el tamaño de la línea de comandos
      inc si  ; se salta el tamaño
      inc si  ; se salta el espacio en blanco
      dec cx  ; quita del tamaño el espacio en blanco

      mov ah, 02h    ; para llamar la rutina que imprime a la salida estandar un solo caracter
ciclo: mov dl, byte ptr Es:[si]      
      cmp dl, 'a'
      jne S1  
      mov dl, 'e'
      jmp print
 S1:  cmp dl, 'e'
      jne S2  
      mov dl, 'a'
      jmp print
 S2:  cmp dl, 'i'
      jne S3  
      mov dl, 'o'
      jmp print
 S3:  cmp dl, 'o'
      jne S4  
      mov dl, 'i'
      jmp print
 S4:  cmp dl, 't'
      jne S5  
      mov dl, 'b'
      jmp print
 S5:  cmp dl, 'b'
      jne S6  
      mov dl, 't'
      jmp print
 S6:  cmp dl, 'p'
      jne S7  
      mov dl, 'm'
      jmp print
 S7:  cmp dl, 'm'
      jne S8  
      mov dl, 'p'
      jmp print
 S8:  cmp dl, 'f'
      jne S9  
      mov dl, 'g'
      jmp print
 S9:  cmp dl, 'g'
      jne print  
      mov dl, 'f'

print:int 21h
      inc si
      loop ciclo


      mov ax, 4C00h

      int 21h 

codigo ends

end main
