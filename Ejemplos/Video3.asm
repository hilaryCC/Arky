; Este es un programa que recibe en la linea de comando una palabra
; lo despliega y permite moverlo con las flechas.

datos segment

    Rot db 128 dup(?)
    
    Pant db 128 dup(?)    

    Fil db 15
    Col db 30
    ColB db 0   ; Negro
    ColF db 14  ; Amarillo

    Tam dw ?

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

GetRot Proc
; Recibe en el DS:[si] un puntero al rÃ³tulo donde se va a salvar.  Supone que es un asciiz
; Recibe en el DX la coordenada donde se debe salvar (DL=Fila y DX=Columna)
; Recibe en el CX la cantidad de caracteres de el rotulo a salvar

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
         mov bl, 80
         mul bl
         mov bl, dh
         xor bh, bh
         add ax, bx
         shl ax, 1
         mov di, ax
         
cicGetRot:
         
         mov al, byte ptr Es:[di]  
         mov byte ptr [si], al
         inc di
         inc di
         inc si 
         loop cicGetRot

         mov byte ptr [si],0     

        pop es
        pop si
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        ret 

GetRot EndP





                                                                             
 inicio: push ds
         pop es
         mov ax, datos
         mov ds, ax
         mov ax, pila
         mov ss, ax

         mov si, 80h
         mov cl, byte ptr ES:[si]
         xor ch, ch
         mov Tam, cx        
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


imprime:

         mov dl, Fil
         mov dh, Col
         mov cx, Tam
         lea si, Pant
         call GetRot

         mov dl, Fil
         mov dh, Col
         mov bh, ColB
         mov bl, ColF
         lea si, Rot
         call prnRot

         xor ah, ah
         int 16h

         mov dl, Fil
         mov dh, Col
         mov bh, ColB
         mov bl, ColF
         lea si, Pant
         call prnRot

         cmp al, 27  ; ESC se sale del programa
         jne scancode
         jmp Salir 

scancode: cmp al, 0 ; viene una tecla sin ascii (como una flecha por ejemplo).
         je flechas
         jmp imprime
flechas: cmp ah, 72
         jne flecha2
         jmp arriba
flecha2: cmp ah, 80
         jne flecha3
         jmp abajo
flecha3: cmp ah, 75
         jne flecha4
         jmp izquierda
flecha4: cmp ah, 77
         jne flecha5
         jmp derecha
flecha5: jmp imprime

arriba: cmp fil, 0
        je arr1
        dec fil 
        jmp imprime 
arr1:   mov fil, 24
        jmp imprime

abajo:  cmp fil, 24
        je aba1
        inc fil 
        jmp imprime 
aba1:   mov fil,0
        jmp imprime

izquierda: cmp col, 0
        je izq1
        dec col 
        jmp imprime 
izq1:   mov col,79
        jmp imprime

derecha: cmp col, 79
        je der1
        inc col 
        jmp imprime 
der1:   mov col,0
        jmp imprime

Salir:
         mov ax, 4C00h
         int 21h
     
codigo ends

end inicio