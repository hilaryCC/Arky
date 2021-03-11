; Este programa despliega el texto que recibe en la linea de comandos encerrado en un marquito de asteriscos.
; Suponemos un límite de 10 palabras, cada una de máximo 20 caracteres

datos segment

  R0 db 10 dup (21 dup('$'))

  N dw 0  ; Cantidad de palabras sacadas de la línea de comandos

  T dw 0  ; Me lleva el tamaño de la palabra más grande
  C dw 0  ; Contador candidato a ser el tamaño más grande

  B dw 0  ; contador que dice cuantos blancos debo agregar por palabra

datos endS

pila segment stack 'stack'
   dw 256 dup(?)
pila endS



codigo segment
       Assume CS:codigo,DS:datos,SS:pila

uno proc
; despliega a la salida estandar un asterisco

  push ax
  push dx
  mov dl, '*'
  mov ah, 02h
  int 21h
  pop dx
  pop ax
  ret
uno endP

Space proc
; despliega a la salida estandar un espacio en blanco

  push ax
  push dx
  mov dl, 32
  mov ah, 02h
  int 21h
  pop dx
  pop ax
  ret
Space endP

CamLin proc
; despliega a la salida estandar un Cambio de Línea

  push ax
  push dx
  mov dl, 0Dh
  mov ah, 02h
  int 21h
  mov dl, 0Ah
  mov ah, 02h
  int 21h
  pop dx
  pop ax
  ret
CamLin endP


main: mov ax, pila
      mov ss, ax

      push ds
      pop es
      mov ax, datos
      mov ds, ax


      mov si, 80h
      mov cl, byte ptr es:[si]
      xor ch,ch
      inc si
      inc si
      dec cx
      lea bx, R0    ; apunta al inicio de la primera palabra
      xor di, di    ; con el dx recorreremos cada palabra
cicLC: mov al, byte ptr es:[si]
      cmp al, ' '    
      je cambiopal
      mov byte ptr [bx+di], al
      inc di
      inc C
      jmp sig
cambiopal: ; mov byte ptr [bx+di], '$'
      inc N
      xor di, di
      add bx, 21

      mov ax, C
      cmp ax, T
      jg mayor
      mov C, 0
      jmp sig
 mayor: mov T, ax
      mov C, 0

 sig: inc si 
      loop cicLC
      inc N


      mov cx, T
      add cx, 4
cicl1: call uno
      loop cicl1
      call CamLin



      lea bx, R0
      xor di, di

      mov cx, N
      mov ah, 02
cicprn:  call uno
      call space 

      push T
      pop B  

  cicIP: mov dl, byte ptr [bx+di]
      cmp dl, '$'
      je salircicIP
      int 21h
      dec B
      inc di 
      jmp cicIP 
      
salircicIP:
           
      add bx, 21
      xor di, di

 cicSpc: cmp B,0
      je salircicSpc
      call space
      dec B
      call cicSpc
    
salircicSpc:

      call space
      call uno
      call CamLin
      loop cicprn    

      mov cx, T
      add cx, 4
cicl2: call uno
      loop cicl2

      mov ax, 4C00h

      int 21h 

codigo ends

end main
