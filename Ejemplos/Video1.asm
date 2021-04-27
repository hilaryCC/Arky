; Este es un programa que recibe en la linea de comando un string
; lo despliega con una secuencia de colores en la primera fila de la pantalla

datos segment

    Rot db 128 dup(?)

datos ends

                  
pila segment stack 'stack'

    dw 256 dup (?)

pila ends


codigo segment

    assume  cs:codigo, ds:datos, ss:pila
                                                                             
 inicio: push ds
         pop es
         mov ax, datos
         mov ds, ax
         mov ax, pila
         mov ss, ax

         mov si, 80h
         mov cl, byte ptr ES:[si]
         xor ch, ch
         push cx
         xor di, di
         inc si  
         inc si
   cic1: mov al, byte ptr ES:[si]   
         mov byte ptr Rot[di], al 
         inc si
         inc di
         loop cic1

         mov ax, 0B800h
         mov es, ax 
         pop cx     
         dec cx      
         xor di, di
         mov ah, 1
         xor si, si
   cic2: mov al, byte ptr Rot[di]
         mov word ptr Es:[si], Ax  
         inc si
         inc di
         inc si 
         inc ah
         cmp ah,15
         jbe siga
         mov ah, 1           
   siga: loop cic2

         mov ax, 4C00h
         int 21h
     
codigo ends

end inicio