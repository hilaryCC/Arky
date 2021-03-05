; Este programa de ASM lo que hace es recibir un nÃºmero en la linea de comandos en la base que indica
 ; la variable BaseF y lo despliega en la base que indica la variable BaseD a la salida estandar.



 datos segment

    numero db 128 dup ( 0 )
    BaseF dw 36
    BaseD dw 10

 datos ends

                  
 pila segment stack 'stack'

    dw 256 dup (?)

 pila ends


codigo segment

    assume  cs:codigo, ds:datos, ss:pila

printAX proc near    
; imprime a la salida estandar un nÃºmero que supone estar en el AX
; supone que es un numero positivo y natural en 16 bits.
; lo imprime en la base que indca la variable Base del Data Segment.  
    
    push AX
    push BX
    push CX                           
    push DX

    xor cx, cx
    mov bx, BaseD
ciclo1PAX: xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne ciclo1PAX
    mov ah, 02h
ciclo2PAX: pop DX
    add dl, 30h
    cmp dl, 39h
    jbe prnPAX
    add dl, 7
prnPAX: int 21h
    loop ciclo2PAX
   
    pop DX
    pop CX
    pop BX
    pop AX
    ret
printAX endP


CamBas Proc Near
; Recibe en DS:[si] un puntero a la secuencia de bytes que es el numero a convertir.
; Recibe el numero en un formato de asciiz y lo retorna en el AX.

   push Bx
   push Dx
   push Si
   
   xor Ax, Ax

CB_ciclo: 
   mov bl, byte ptr [si]
   sub bl, 30h
   cmp bl, 9
   jbe CB_sume    
   sub bl, 7
CB_sume: xor bh, bh
   add ax, bx
   inc si
   cmp byte ptr [si],0
   je CB_Salir
   mul baseF
   jmp CB_ciclo

CB_Salir:

   pop Si
   pop Dx
   pop Bx

   ret
CamBas EndP

                                                                             
 inicio: mov ax, ds
         mov es, ax

         mov ax, datos
         mov ds, ax

         mov ax, pila
         mov ss, ax

         mov si, 80h
         mov cl, byte ptr es:[si]
         xor ch, ch              

         xor di, di
         inc si
         dec cx

ciclo:   inc si
         mov al, byte ptr es:[si]
         mov byte ptr numero[di], al
         inc di

         loop ciclo

         ; mov numero[di], 0  ; almacenamos el numero como un AsciiZ (formato like C) 

         lea si, numero
         call CamBas
         call printAX

         mov ax, 4C00h
         int 21h

     
 codigo ends

 end inicio
