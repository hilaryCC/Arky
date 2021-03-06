;           Intituto Tecnológico de Costa Rica
; Escuela de Computación, Arquitectura de computadores IC3101
; Grupo 01, Tarea #1 Diamond, 24/02/2021
; Profesor: Kirstein Gätjens S.
; Estudiante: Castro Cabezas Hilary Sofía, carné: 2020100628
;
;                  - MANUAL DE USUARIO -
;    1. Ensamble el archivo "CasHil.asm" con tasm y tlink
;           a. tasm CasHil (Crea el archivo obj)
;           b. tlink CasHil (Crea el archivo ejecutable)
;    2. Ejecute el archivo creado utilizando DOSbox. En 
;       la misma línea de comando, separado por un único
;       espacio del nombre del archivo, ingrese el ancho
;       deseado del diamante y presione enter.
;       Ej: c:\>CasHil 07
;
;    ** El ancho del diamante debe ser un número natural
;       de dos dígitos, en otras palabras, entre el 00 
;       y el 99. En números de mas dígitos solo se 
;       tomarán en cuenta los primeros dos. Es preferible
;       que este número sea impar, en caso de que sea par
;       se desplegará un diamante del siguiente número,
;       por ejemplo, un 12 desplegará un diamante de 13.
; 
;
;
;             - ANÁLISIS DE RESULTADOS -
;  1. Leer la línea de comandos........................> A 
;  2. Verificar que los caracteres sean números .......> A
;  3. Convertir los caracteres a enteros...............> A
;  4. Calcular la altura del diamante..................> A
;  5. Desplegar la mitad superior del diamante.........> A
;  6. Desplegar la línea intermedia del diamante.......> A
;  7. Desplegar la mitad inferior del diamante.........> A
;  8. Desplegar un mensaje de error....................> A
;  9. Desplegar el mini-acerca-de......................> A
;  10. Numero par despliega diamante impar.............> A



datos segment                 ;Definir las variables

    linea db 128 dup (?) ;Guarda todos los ' ' y '*' en una sola linea para desplegar
    numero db 0     ;Guarda el numero final
    mitad db 0      ;Guarda la mitad del numero
    cantAst db 1    ;Guarda la cantidad de '*' a desplegar
    cantEsp db 1    ;Guarda la cantidad de ' ' a desplegar
    decenas db 0    ;Guarda el primer digito
    unidades db 0   ;Guarda el segundo digito
    msjError db 10, "(x) Por favor ingrese un numero de dos digitos (00 - 99) en la linea de comandos (ej: c:\>CasHil 13), preferiblemente ingrese un numero impar",10, '$'
    msjError2 db  10, "- NO ingrese letras, simbolos o numeros de un solo digito", 10, "- En numeros de mas de dos digitos, solo se tomaran en cuenta los primeros dos", 10, '$'
    acercaDe db "ITCR, Arquitectura de Computadores, Escuela de computacion, Tarea Diamond", 10, '$'
    acercaDe2 db "Castro Cabezas Hilary, 2020100628, grupo 01, version 1.0, entrega 24/02/2021", 10, 10, '$'

 datos ends

                  
 pila segment stack 'stack'

    dw 256 dup (?)

 pila ends

 codigo segment

    assume  cs:codigo, ds:datos, ss:pila  

printLinea proc
   ;agregar los espacios
   xor bx, bx
   xor di, di ;se lleva a 0 para apuntar desde la primera posicion de la linea
   espacios: mov byte ptr linea[di], 20h ;agrega un espacio
            inc bx 
            inc di ;apunta a la posicion siguiente en la linea
            cmp bl, cantEsp 
            jbe espacios 

   ;agregar los asteriscos
   xor bx, bx
   star: mov byte ptr linea[di], '*' ;agrega un asterisco
         inc bx
         inc di
         cmp bl, cantAst
         jb star
   ;Se agregan para un salto de linea y finalizacion de la cadena
   mov byte ptr linea[di], 0Dh
   inc di
   mov byte ptr linea[di], 0Ah
   inc di
   mov byte ptr linea[di], '$'

   ;Se imprime la linea
   mov ah, 09h
   lea dx, linea
   int 21h
   ret ;Se retorna a la linea donde se hizo la llamada
printLinea endP
errorP proc ;Se imprimen los mensajes de error
   mov ah, 09h
   lea dx, msjError
   int 21h
   lea dx, msjError2
   int 21h
   mov ax, 4C00h
   int 21h
errorP endP

 inicio: mov ax, ds ;ds apunta al psp, por eso se guarda en el es
         mov es, ax

         mov ax, datos
         mov ds, ax

         mov ax, pila
         mov ss, ax           

         mov si, 80h ;La linea de comandos inicia en el 80h del psp              
         mov cl, byte ptr es:[si] 

         xor ch, ch               
         xor di, di 

         ;Imprimir el acerda de
         mov ah, 09h
         lea dx, acercaDe
         int 21h
         lea dx, acercaDe2
         int 21h              

         ;Capturar decenas
         inc si
         inc si
         mov al, byte ptr es:[si]
         cmp al, 57 ;se verifica que se ingreso un numero (el ascii del 9 es 57)
         ja errorP  ;para esto se compara que el caracter este entre el 48 y el 57 en el ascii
         cmp al, 48 ;el ascii del 0 es 48 (48 < n < 57)
         jb errorP
         sub al, 30h ;se le resta el 0 (48), para obtener el numero en decimal
         mov decenas, al

         ;Capturar unidades (se realiza la misma verificacion que a las decenas)
         inc si
         mov al, byte ptr es:[si]
         cmp al, 57
         ja errorP
         cmp al, 48
         jb errorP
         sub al, 30h
         mov unidades, al

         ;Sumar ambos numeros
         mov al, decenas ;Se multiplica el primer digito por 10 para obtener las decenas
         mov bl, 10
         mul bl ; multiplicacion = (al x bl), el resultado se guarda en al
         mov decenas, al
         add al, unidades 
         mov numero, al ;se suman las decenas y las unidades y se guardan en numero

         ;Obtener mitad del numero
         mov bl, 2
         mov al, numero
         xor dx, dx
         div bx ; division = (dx: ax / bx), en dx se almacena el residuo y en ax el resultado
         mov mitad, al
         mov cantEsp, al

         ;Ciclos para la impresion del diamante
         xor cx, cx
         mov cl, mitad ;la mitad del numero es la altura de la parte superior e inferior (sin contar el centro) del diamante
         xor ax, ax    ;los ciclos se repiten esa cantidad de veces por medio del cx
         cmp numero, 1 ;Si el numero es 1 o 0, se salta 
         jbe inferior
         ;Para dividir mas rapido entre 2, se hace un shift a las derecha
         ;mov ax, (numero a dividir)
         ;shr ax, 1 -> no importa la vase en la que se encuentre, siempre va a ser la mitad del numero
         superior:call printLinea ;Ciclo parte superior (se aumentan la cantidad de asteriscos en 2, se disminuyen los espacios)
                  inc cantAst
                  inc cantAst
                  dec cantEsp
                  loop superior
         
         call printLinea ;Imprimir la parte central
         xor cx, cx
         mov cl, mitad
         dec cantAst
                  
         inferior:dec cantAst ;Ciclo parte superior (se aumentan la cantidad de espacios, se disminuyen los espacios en 2)
                  inc cantEsp
                  call printLinea
                  cmp numero, 1 ;Si el numero es 1 o 0, se termina el programa (luego de desplegar un asterisco)
                  jbe terminar
                  dec cantAst
                  loop inferior

         ;Imprimir mensaje y numero final
         terminar: mov ax, 4C00h
         int 21h

 codigo ends

 end inicio
