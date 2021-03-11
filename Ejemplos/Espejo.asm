; Este es un programa que imprime la linea de comandos al reves.


 datos segment

    rotulo db 128 dup ( ? )                                                     

 datos ends

                  
 pila segment stack 'stack'

    dw 256 dup (?)

 pila ends


 codigo segment

    assume  cs:codigo, ds:datos, ss:pila

                                                                             
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
         add si, cx
         dec cx
  ciclo: 
         mov al, byte ptr es:[si]
         mov byte ptr rotulo[di], al
         inc di
         dec si
         loop ciclo

         mov byte ptr rotulo[di],'$'

         mov ah,09h
         lea dx, rotulo
         int 21h

         mov ax, 4C00h
         int 21h

     
 codigo ends

 end inicio
