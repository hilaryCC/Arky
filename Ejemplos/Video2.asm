; Este es un programa que recibe en la linea de comando un string
; lo despliega en una posiciÃ³n particular de la pantalla con un color de frente y de fondo dados.

datos segment

    Rot db 128 dup(?)

    Fil db 20
    Col db 10
    ColF db 9   ; Azul Claro
    ColB db 3   ; Cyan Oscuro

datos ends

                  
pila segment stack 'stack'

    dw 256 dup (?)

pila ends


codigo segment

    assume  cs:codigo, ds:datos, ss:pila

PrnRot Proc
; Recibe en el DS:[si] un puntero al rÃ³tulo.  Supone que es un asciiz
; Recibe en el DX la coordenada donde se debe desplegar (DL=Fila y DX=Columna)
; Recibe en el BX el color (BL=Foreground y BH=Background) 

         push ax 
         push bx 
         push cx 
         push dx 
         push di 
         push si 
         push es        

         mov ax, 0B800h
         mov es, ax 

         mov Al, Dl
         mov cl, 80
         mul cl
         mov cl, dh
         xor ch, ch
         add ax, cx
         shl ax, 1
         mov di, ax
         
         mov ah, bl
         and ah,0Fh
         mov cl, 4
         shl bh, cl
         or ah, bh         

cicPrnRot:
         cmp byte ptr [si],0
         je salirprnRot

         mov al, byte ptr [si]
         mov word ptr Es:[di], ax  
         inc di
         inc di
         inc si 
         jmp cicPrnRot

salirprnRot:

        pop es
        pop si
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        ret 

PrnRot EndP








                                                                             
 inicio: push ds
         pop es
         mov ax, datos
         mov ds, ax
         mov ax, pila
         mov ss, ax

         mov si, 80h
         mov cl, byte ptr ES:[si]
         xor ch, ch
         xor di, di
         inc si  
         inc si
   cic1: mov al, byte ptr ES:[si]   
         mov byte ptr Rot[di], al 
         inc si
         inc di
         loop cic1
         dec di
         mov byte ptr Rot[di],0



         mov dl, Fil
         mov dh, Col
         mov bh, ColB
         mov bl, ColF
         lea si, Rot
         call prnRot



         mov ax, 4C00h
         int 21h
     
codigo ends

end inicio