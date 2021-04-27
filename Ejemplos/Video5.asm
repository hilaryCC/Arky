; Este es un programa que pinta la bandera de varios países.
; Deje sin comentarios la llamada a la macro del pais del que desea ver la bandera


datos segment
     X dw ?
datos ends

azul EQU 00010001b
roja EQU 01000100b
blanca EQU 07Fh
negra EQU 0
amarilla EQU 0Eh
verde EQU 22h
                  
pila segment stack 'stack'

    dw 256 dup (?)

pila ends

franjaH Macro color
local franja1
         mov cx, 80*N
         mov ah, color
         franja1:
           mov word ptr es:[si], ax
           inc si
           inc si          
         loop franja1
endM

franjaV Macro color
local franja1, salir, ciclo

         mov ah, color
         mov dx, N
ciclo:   cmp dx, 0
         jz salir
         mov cx, 25
         franja1:
           mov word ptr es:[si], ax
           add si, 160
         loop franja1
         dec dx
         sub si, 160*25-2
         jmp ciclo
salir:
endM

CostaRica Macro
   N = 4
   franjaH azul
   franjaH blanca
   franjaH roja
   franjaH roja
   franjaH blanca
   franjaH azul
   N = 1
   franjaH negra
EndM

Alemania Macro
   N = 8
   franjaH negra
   franjaH roja
   franjaH amarilla
   N = 1
   franjaH negra
EndM

Espana Macro
   N = 6
   franjaH Roja
   franjaH amarilla
   franjaH amarilla
   franjaH Roja
   N = 1
   franjaH negra
EndM

Colombia Macro
   N = 6
   franjaH amarilla
   franjaH amarilla
   franjaH Roja
   franjaH Azul
   N = 1
   franjaH negra
EndM


Italia Macro
   N = 1
   franjaV negra
   N = 26
   franjaV verde
   franjaV blanca
   franjaV roja
   N = 1
   franjaV negra
EndM

Belgica Macro
   N = 27
   franjaV Negra
   N = 26
   franjaV roja
   franjaV amarilla
   N = 1
   franjaV negra
EndM


Tecla Macro 
   xor ah,ah
   int 16h
EndM


codigo segment

    assume  cs:codigo, ds:datos, ss:pila
                                                                             
 inicio: mov ax, datos   ; protocolo de inicialización del programa.
         mov ds, ax
         mov ax, pila
         mov ss, ax

         mov ax, 0B800h
         mov es, ax
         xor si, si
         mov al, 219
        
         CostaRica
         Tecla 

         xor si, si
         mov al, 219
         Alemania
         Tecla 

         xor si, si
         mov al, 219
        ; Espana 
         Tecla 

         xor si, si
         mov al, 219
        ; Italia
         Tecla 

         xor si, si
         mov al, 219
        ; Belgica
         Tecla 

         xor si, si
         mov al, 219
        ; Colombia
         Tecla 


         mov ax, 4C00h    ; protocolo de finalización del programa.
         int 21h
     
codigo ends

end inicio