; Este programa despliega una lluvia de letras de colores.


datos segment
  Cara db ?
  Color db ?
  Pos db ?
datos endS

PP EQU 75          ; Para la pausa
WSpace EQU 0720h

pila segment stack 'stack'
   dw 256 dup(?)
pila endS

Pause Macro N
local Cic1,Cic2
     push cx
     mov cx, N
cic1: push cx
     mov cx, N
cic2: nop
     loop cic2
     pop cx
     loop cic1
     pop cx
EndM

codigo segment
       Assume CS:codigo,DS:datos,SS:pila

rndBL proc
  push cx
  push dx
  mov ah, 2Ch
  int 21h
  mov ax, dx
  xor dx, dx
  xor bh, bh
  div bx
  xchg ax,dx
  pop dx
  pop cx
  ret
rndBL endP

column proc

     push ax
     push bx
     push cx
     push si

     xor bh, bh
     mov si, bx     
     shl si, 1
     mov cx, 24
     mov word ptr es:[si],ax
ciccolumn: 
     push ax
     mov bl, 100
     call rndBL
     add ax, PP
     pause 300
     pop ax
     cmp byte ptr es:[si+160],32
     jne salircolumn
    mov word ptr es:[si], WSpace
     add si, 160      
     mov word ptr es:[si],ax    
     loop ciccolumn
salircolumn:    

     pop si
     pop cx
     pop bx
     pop ax
     ret
column endp

main: mov ax, pila
      mov ss, ax

      mov ax, datos
      mov ds, ax

      mov ax, 0003h
      int 10h

      mov ah, 01h
      xor cx, cx
      int 10h

      mov ax, 0B800h
      mov es, ax

lluvia:
      mov bl, 26
      call rndBL
      add al, 'A'
      mov Cara, al
      mov bl, 15
      call rndBL
      inc al
      mov Color, al
      mov bl, 80
      call rndBL
      mov pos, al
      mov al, Cara
      mov ah, Color
      mov bl, Pos
      call column
     
      mov ah, 01h
      int 16h
      jz nohay
      jmp salir
nohay: jmp lluvia

salir: 
       mov ah, 01h
       mov ch, 6
       mov cl, 7
       int 10h

       mov ax, 4C00h
       int 21h 

codigo ends

end main