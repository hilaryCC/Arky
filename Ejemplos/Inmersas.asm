; Este programa busca si las letras de una palabra están inmersas en otra palabra.
; Recibe las palabras separadas por un espacio en blanco.
; Las palabras son de máximo 20 caracteres

datos segment

  Pal1 db 21 dup('$') ; Primera palabra
  Pal2 db 21 dup('$') ; Segunda palabra
  C dw 0  ; Cantidad de letras de la primera palabra que son las letras a buscar
  C2 dw 0  ; Cantidad de letras de la segunda palabra que son las letras a buscar

  RotuloSI db "Todas las letras estaban!$"
  RotuloNO db "Una letra no estaba$"

  Base dw 10

datos endS

pila segment stack 'stack'
   dw 256 dup(?)
pila endS



codigo segment
       Assume CS:codigo,DS:datos,SS:pila

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
      
      lea bx, pal1  ; apunta al inicio de la primera palabra
      xor di, di    ; con el di recorreremos cada palabra
cicLC1: mov al, byte ptr es:[si]
      cmp al, ' '    
      je copiar2
      mov byte ptr [bx+di], al
      inc di
      inc C
      inc si 
      loop cicLC1

copiar2: lea bx, pal2   ; Vamos a leer la segunda palabra
         xor di, di
         inc si
         dec cx
cicLC2: mov al, byte ptr es:[si]
      cmp al, ' '    
      je buscar
      mov byte ptr [bx+di], al
      inc di
      inc C2
      inc si 
      loop cicLC2

buscar:

      xor si, si
      dec si
siletra:
      inc si
      cmp si, C
      je siestaba
      mov al, pal1[si]         
      xor di, di
      mov cx, C2
      mov dx, cx
      dec dx
cicbus:
      cmp al, pal2[di]         
      je siletra
      cmp di, dx
      je NO
      inc di
      loop cicbus 
siestaba:
      lea dx, rotuloSI
      jmp imprimirR
No:   lea dx, rotuloNO
imprimirR: mov ah, 09h      
      int 21h
      mov ax, 4C00h
      int 21h 

codigo ends

end main
