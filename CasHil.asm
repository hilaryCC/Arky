;           Intituto Tecnológico de Costa Rica
; Escuela de Computación, Arquitectura de computadores IC3101
; Grupo 01, Tarea del Acueducto, 21/05/2021
; Profesor: Kirstein Gätjens S.
; Estudiante: Castro Cabezas Hilary Sofía, carné: 2020100628
;
;                  - MANUAL DE USUARIO -
;    1. Ensamble el archivo "CasHil.asm" con tasm y tlink
;           a. tasm CasHil (Crea el archivo obj)
;           b. tlink CasHil (Crea el archivo ejecutable)
;    2. Ejecute el archivo creado utilizando DOSbox. NO es necesario
;       agregar nada a la linea de comandos, no es relevante en el 
;       programa. Solamente debe ingresar el nombre y presionar la 
;       tecla ENTER.
;       Ej: c:\>CasHil 
;
;
;                                  ACUEDUCTO
; El juego del Acueducto consiste en llevar el agua de la fuente de agua '>' 
; hasta la casa '■'. Cada nivel es un laberinto de piedra con varias piezas de
; madera que se pueden mover para ayudar al agua a llegar al destino.
; Durante el juego, se pueden utilizar las flechas del teclado para mover el 
; cursor (el cual no se podrá ver si se posiciona sobre un muro de piedra). 
; Es importante tener en cuenta el algoritmo de recorrido del agua a la hora de 
; analizar cada nivel. El agua sigue el orden: abajo, derecha, izquierda y 
; arriba, esto en caso de encontrarse con un obstaculo que le impida moverse.
;
; **Para ganar, es importante que el agua no tenga por donde escapar, de otra manera
; el agua seguirá recorriendo toda la pantalla hasta llenarla por completo y esto
; implicaría perder el nivel.
; 
;                                    TECLAS
; ESC: Interrumpe el juego actual y sale (no funciona dentro del nivel).
; F1: Despliega en una ventana la ayuda del juego.
; Alt-A: Despliega el acerca de en una ventana.
; Flechas: Permiten mover el cursor si no hay una pieza de madera seleccionada 
; o la pieza de madera en caso de que esté seleccionada.
; Space Bar: Selecciona la pieza de madera de la posición actual del cursor. Si
; hay una pieza seleccionada la suelta. Si en la posición actual no
; hay una pieza de madera no hace nada.
; Enter: Pone a funcionar el algoritmo del agua para ver si se gana el nivel.
; Alt-R: Resetea el nivel. Es decir los despliega de nuevo a como estaba en el 
; archivo.
; +: Avanza al siguiente nivel.
; -: Retrocede al nivel anterior. 
; RePag: Disminuye la velocidad del agua //EXTRA
; AvPag: Aumenta la velocidad del agua //EXTRA
; x: Se rinde del nivel actual. Pierde automaticamente //EXTRA
;
; //Extra: Se agregaron estas funciones de manera extra a lo pedido para el programa
;
; Para los archivos de los niveles, se tienen las siguientes reglas:
; El cambio de línea indica que esa fila tiene el resto de
; los caracteres en blanco. Si el archivo trae menos de las 24 líneas necesarias las líneas 
; faltantes se supondrá que son espacios en blanco. Los caracteres válidos son: X representa 
; un muro de piedra. Un espacio en blanco claramente es un espacio vacío. # representa una pieza de
; madera de las que podemos mover. La @ representa la fuente y la casa será el asterisco. Si en al 
; archivo se encuentra algo que no está asignado se debe dar un mensaje de error y avanzar con el nivel siguiente
;
; Entonces, por ejemplo, archivos que contengan TAB's se verán como un error de sintaxis y no se mostraran.
; En caso de existir un error, este se despliega y se espera la interacción del jugador para
; cambiar de nivel. También se verá como error si el archivo tiene mas de 80 columnas y/o mas de 24 filas.
;
;
;             - ANÁLISIS DE RESULTADOS -
; 1. Pedir las teclas por la entrada estandar............> A
; 2. Identificar la naturaleza del caracter (ascii, etc).> A
; 3. Procesar cada caracter..............................> A
; 4. Desplegar mini-acerca-de (F1).......................> A
; 5. Desplegar la ayuda (Alt+A)..........................> A
; 6. Reiniciar el nivel (Alt+R)..........................> A
; 7. Desplegar el laberinto..............................> A
; 8. Desplegar la barra de información...................> A
; 9. Cambiar de nivel (avanzar o retroceder).............> A
; 10. Desplegar coordenadas..............................> A
; 11. Mostrar si se tiene una pieza de madera............> A
; 12. Mover el cursor....................................> A
; 13. Mover la pieza de madera...........................> A
; 14. Mostrar el numero de nivel.........................> A
; 15. Cambiar la velocidad del agua......................> A
; 16. Desplegar error de sintaxis dentro del archivo.....> A
; 17. Salir del programa (ESC)...........................> A
; 18. Algoritmo para ganar el nivel......................> A
; 19. Mostrar recorrido del agua.........................> A
; 20. Quita el agua al perder un nivel...................> A



datos segment

  acercaDe db "ITCR, Arquitectura de Computadores, Escuela de computacion, Tarea Acueducto", 0
  acercaDe2 db "Castro Cabezas Hilary, 2020100628, grupo 01, version 1.0, 21/5/2021", 0
  ayuda db  "                                   ACUEDUCTO                                    "
        db  "El juego del Acueducto consiste en llevar el agua de la fuente de agua '>'      " 
        db  "hasta la casa '", 254,"'. Cada nivel es un laberinto de piedra con varias piezas de    "
        db  "madera que se pueden mover para ayudar al agua a llegar al destino.             "
        db  "Durante el juego, se pueden utilizar las flechas del teclado para mover el      " 
        db  "cursor.                                                                         " 
        db  "Es importante tener en cuenta el algoritmo de recorrido del agua a la hora de   " 
        db  "analizar cada nivel. El agua sigue el orden: abajo, derecha, izquierda y        " 
        db  "arriba, esto en caso de encontrarse con un obstaculo que le impida moverse.     "
        db  "** Para ganar, es importante que el agua no tenga por donde escapar.            "
        db  "                                                                                "
        db  "                                   TECLAS                                       "
        db  "ESC: Interrumpe el juego actual y sale.                                         "
        db  "F1: Despliega la ayuda del juego.                                               "
        db  "Alt-A: Despliega el acerca de (informacion).                                    "
        db  "Flechas: Permiten mover el cursor o una pieza de madera seleccionada            "
        db  "Space Bar: Selecciona la pieza de madera de la posicion actual del cursor. Si   "
        db  "hay una pieza seleccionada la suelta.                                           "
        db  "Enter: Pone a funcionar el algoritmo del agua para ver si se gana el nivel.     "
        db  "Alt-R: Resetea el nivel.                                                        "
        db  "+ -: Avanza o retrocede de nivel (respectivamente).                             "
        db  "RePag  AvPag: Disminuye o aumenta la velocidad del agua (respectivamente).*     "
        db  "x : 'se rinde', se pierde automaticamente el nivel.*", 0
        
  HandleE dw ?    ; Handle para el archivo de entrada 
  NombreE db "acue000.txt",0  ; dirección donde están todos los niveles
  Buffy db ?      ; procesaremos caracter por caracter
  nivelActual dw 0 ;LLeva cual es el nivel actual
  info db "000",0, "-", 0, "000 000",0, "+ seguir  - volver",0, "F1 -help   alt+a -info   alt+r -reset", 0 ;nivel, madera, coordenadas (filaxcolumna), etc
  ;000-000 000+ seguir  - volverF1 -help   alt+a -info   alt+r -reset
  K dw 0   ;  almacenará el tamaño del archivo
  Row db 0 ;fila
  Col db 0 ;columna
  fuenteL db 0 ;linea de la fuente
  fuenteC db 0 ;columna de la fuente
  fuente dw 0 ;indice de la fuente
  casa dw 0 ;indice de la casa
  errorSint db "Error dentro del archivo, presione + o - para avanzar", 0
  perder db "                   Has perdido el nivel, vuelve a intentarlo                    ",0
  ganar db "                              Has ganado el nivel                               ",0
  agua1 db 176, 01h ;fondo negro, y agua azul (horizontales)
  tecla db 43 ;numero de la tecla de nivel
  madera db 0 ;avisa si se tiene un pedazo de madera o no
  dir db 1 ;direccion
  fFuente db 0 ;flag de la fuente
  fCasa db 0 ;flag de la casa

  COLOR EQU 02h 
  PP dw 500 ;para la pausa o velocidad del agua
  COLORFondo EQU 01110111b
  


datos endS

pila segment stack 'stack'
   dw 256 dup(?)
pila endS



codigo segment
       Assume CS:codigo,DS:datos,SS:pila

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

Pnivel proc
  push ax
  push bx
  push dx
  push si
  lea si, info
  mov ax, nivelActual
  call agregarNum
  lea si, info
  mov dh, 0
  mov dl, 24
  mov bx, COLOR
  call PrnRot
  lea si, info
  add si, 4
  mov dh, 6
  mov dl, 24
  mov bx, 06h
  call PrnRot
  lea si, info
  add si, 6
  mov dh, 10
  mov dl, 24
  mov bx, 07h
  call PrnRot
  lea si, info
  add si, 14
  mov dh, 21
  mov dl, 24
  mov bx, 01h
  call PrnRot
  lea si, info
  add si, 33
  mov dh, 43
  mov dl, 24
  mov bx, 03h
  call PrnRot
  pop si
  pop dx
  pop bx
  pop ax
  ret
Pnivel endP

goUp macro
  cmp madera, 0
  jne mMaderaup
  mov ah, 03h
  xor bx, bx
  int 10h
  cmp dh, 0
  je salirup
  dec dh
  xor bx, bx
  mov ah, 02h
  int 10h
  call coordenadas
  jmp salirup
  mMaderaup: 
    mov dir, 1
    call moverMadera
  salirup: 
endM

goLeft macro
  cmp madera, 0
  jne mMaderaleft
  xor bx, bx
  mov ah, 03h
  int 10h
  cmp dl, 0
  je salirleft
  dec dl
  xor bx, bx
  mov ah, 02h
  int 10h
  call coordenadas
  jmp salirleft
  mMaderaleft: 
    mov dir, 2
    call moverMadera
  salirleft: 
endM

goDown macro
  cmp madera, 0
  jne mMaderadown
  xor bx, bx
  mov ah, 03h
  int 10h
  cmp dh, 23
  je salirdown
  inc dh
  xor bx, bx
  mov ah, 02h
  int 10h
  call coordenadas
  jmp salirdown
  mMaderadown: 
    mov dir, 3
    call moverMadera
  salirdown: 
endM

goRight macro
  cmp madera, 0
  jne mMaderaright
  xor bx, bx
  mov ah, 03h
  int 10h
  cmp dl, 79
  je salirright
  inc dl
  xor bx, bx
  mov ah, 02h
  int 10h
  call coordenadas
  jmp salirright
  mMaderaright:
    mov dir, 4
    call moverMadera
  salirright: 
endM

coordenadas proc
  ;busca las coordenadas del cursor y las actualiza
  push ax
  push bx
  push cx
  push dx
  push si

  mov ah, 03h
  xor bx, bx
  int 10h
  xor ax, ax
  mov al, dh
  lea si, info
  add si, 6
  call agregarNum
  xor ax, ax
  mov al, dl
  lea si, info
  add si, 10
  call agregarNum
  mov cx, 7
  mov si, 6
  mov bx, 3860
  prcoo: mov dh, 0111b 
        mov dl, byte ptr info[si]
        mov word ptr es:[bx], dx
        inc si
        inc bx
        inc bx
        loop prcoo

  pop si
  pop dx
  pop cx
  pop dx
  pop ax
  ret
coordenadas endP

cPos MACRO
  ;calcula la posicion en la pantalla, devuelve el indice en el bx
  MOV AL,160           ; Calculamos BX = FIL*160+Col*2 
  MUL row
  XOR BH, BH
  MOV BL, col
  SHL BX,1
  ADD BX,AX
endM

rePrn proc
  ;quita el agua de la pantalla
  push ax
  push bx
  push cx
  push dx
  mov row, 0
  mov col, 0
  mov cx, 25
  xor si, si

  filas: push cx
    mov cx, 80
    column: 
      cmp byte ptr es:[si], 219
      je againre
      cmp byte ptr es:[si], '#'
      je againre
      cmp byte ptr es:[si], 254
      je againre
      cmp byte ptr es:[si], 62
      je againre
      mov dh, 1111b
      mov dl, 32
      mov word ptr es:[si], dx
      againre: inc col
      inc si
      inc si
      loop column
    inc row
    pop cx
    loop filas
  call Pnivel
  pop dx
  pop cx
  pop bx
  pop ax
  ret
rePrn endP

Archivos proc
  ;Abre el archivo de juego mas cercano (000-999)
  againarch: mov row, 0
  mov col, 0
  mov madera, 0
  mov si, 4
  mov byte ptr info[si], '-'
  mov ah, 01h
  mov ch, 6
  mov cl, 7
  xor bx, bx
  int 10h

  mov ax, 0B800h
  mov es, ax 
  abrirTXT: 
        mov ah, 3Dh ; abrir el archivo de entrada 
        xor al, al  ; código 0 para abrirlo como solo lectura
        lea dx, nombreE
        int 21h
        jnc sigue2
        jmp error
  sigue2: call cleanS
        mov handleE, ax

        ;Tamaño del archivo
        mov ah, 42h ; movemos el file pointer del archivo de entrada al final
        mov al, 2 ;   significa que es a partir del final del archivo
        mov bx, handleE
        xor dx, dx      
        xor cx, cx   ; se ponga al final del archivo
        int 21h 
        mov K, ax   

        mov ah, 42h ; movemos el file pointer del archivo de entrada al final
        mov al, 0 ;   significa que es a partir del inicio
        mov bx, handleE
        xor dx, dx      
        xor cx, cx   ; el desplazamiento se almacena en CX:DX  
        int 21h 
        xor si, si

  proceso:
        cmp K, 0
        jne leer
        jmp cerrar

  leer:
        mov ah, 3Fh  ; leemos el caracter del archivo
        mov cx, 1
        lea dx, buffy
        mov bx, handleE
        int 21h
        jc bunerror
        jmp escribir
        bunerror: jmp cerrar

  escribir:
        ; Aca escribimos el caracter en la pantalla
        cmp col, 80
        jne cmparch
        inc row
        mov col, 0

       cmparch:  cmp row, 24
        jb cmpbuffy
        jmp cerrar

        cmpbuffy: cmp buffy, 0Ah
        je camlinar
        cmp buffy, 0Dh
        jne cmpbuffy2
        jmp continuarP
       cmpbuffy2: cmp buffy, 'X'
        je desparch
        cmp buffy, 'x'
        je desparch
        cmp buffy, '@'
        je desparch
        cmp buffy, '*'
        je desparch
        cmp buffy, '#'
        je desparch
        cmp buffy, 32
        je desparch
       cnfuente: jmp error2

        camlinar: inc row
                  mov col, 0
                  jmp continuarP

        desparch: cPos 
                cmp buffy, 'X'
                jne cm1
                mov dh, 1000b
                mov dl, 219
                jmp desppant 
               cm1: cmp buffy, 'x'
                jne cm2
                mov dh, 1000b
                mov dl, 219
                jmp desppant
               cm2: cmp buffy, '@'
                jne cm3
                cmp fFuente, 0
                jne cnfuente
                mov fFuente, 1
                mov fuente, bx
                push ax
                push bx
                push dx
                mov al, row
                mov fuenteL, al
                mov al, col
                mov fuenteC, al
                pop dx
                pop bx
                pop ax
                mov dh, 0011b
                mov dl, '>'
                jmp desppant
               cm3: cmp buffy, '*'
                jne cm4
                cmp fCasa, 0
                jne error2
                mov fCasa, 1
                mov dh, 0100b
                mov dl, 254
                mov casa, bx
                jmp desppant
               cm4: cmp buffy, '#'
                jne cm5
                mov dh, 0110b
                mov dl, byte ptr buffy
                jmp desppant
               cm5: cmp buffy, 32
                jne cm6
                mov dh, 1111b
                mov dl, byte ptr buffy
                jmp desppant
               cm6: mov dh, 1111b  
                mov dl, byte ptr buffy
               desppant: MOV WORD PTR ES:[BX],dx
                inc col

        jmp continuarP


  continuarP: dec K
      
        jmp proceso

        jc error2

  cerrar: cmp fFuente, 0
        je error2
        cmp fCasa, 0
        je error2
        mov fFuente, 0
        mov fCasa, 0    
        mov ah, 3Eh ; cerrar el archivo de entrada 
        mov bx, handleE
        int 21h 
        jmp salir
  error: 
        jmp salir

  error2: call cleanS
    call Pnivel
    mov fFuente, 0
    mov fCasa, 0    
    mov ah, 3Eh ; cerrar el archivo de entrada 
    mov bx, handleE
    int 21h 
    lea si, errorsint
    mov dl, 12
    mov dh, 13
    mov bh, 0100b
    mov bl, 1111b
    call PrnRot
    mov ah, 02h
    xor bx, bx
    mov dl, 12
    mov dh, 57
    int 10h
    ret

  salir: 
    mov ah, 02h
    xor bx, bx
    mov dh, fuenteL
    mov dl, fuenteC
    int 10h
    call Pnivel 
    call coordenadas
    salir2: ret

Archivos endP


cleanS proc
    ;Limpia la pantalla con la interrupcion 10h
    push ax
    push bx
    push cx
    push dx
    push si

    mov ah, 06h ;funcion para hacer scroll tambien con 7h
    mov al,0h ;cantidad de filas a enrollar
    mov bh, 07h;atributos de color fondo y texto
    mov CX,00h;fila inicial en ch, columna inicial en cl
    mov DX, 184fh;fila final en dh, columna final en cl
    int 10h;ejecuta las interrupciones de video

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
cleanS endP

agregarNum proc
    ;Agrega un numero a la hilera de caracteres
    ;hilera en si, numero en ax
    ;pone primero todo en 000 
        
        push AX
        push BX
        push CX
        push DX
        push si

        xor cx, cx
        mov bx, 10
        mov byte ptr [si], '0'
        mov byte ptr [si+1], '0'
        mov byte ptr [si+2], '0'
        inc si
        inc si

    ciclo1PAXan: xor dx, dx
        div bx
        jmp compararan
       endcomp: inc cx
        cmp ax, 0
        jne ciclo1PAXan
        jmp endan
    compararan:
        cmp dx, 0
        jne unoan
        mov byte ptr [si], '0'
        dec si
        jmp seguir
      unoan:  cmp dx, 1
        jne dosan
        mov byte ptr [si], '1'
        dec si
        jmp seguir
      dosan:  cmp dx, 2
        jne tresan
        mov byte ptr [si], '2'
        dec si
        jmp seguir
      tresan:  cmp dx, 3
        jne cuatroan
        mov byte ptr [si], '3'
        dec si
        jmp seguir
      cuatroan:  cmp dx, 4
        jne cincoan
        mov byte ptr [si], '4'
        dec si
        jmp seguir
      cincoan:  cmp dx, 5
        jne seisan
        mov byte ptr [si], '5'
        dec si
        jmp seguir
      seisan:  cmp dx, 6
        jne sietean
        mov byte ptr [si], '6'
        dec si
        jmp seguir
      sietean:  cmp dx, 7
        jne ochoan
        mov byte ptr [si], '7'
        dec si
        jmp seguir
      ochoan:  cmp dx, 8
        jne nuevean
        mov byte ptr [si], '8'
        dec si
        jmp seguir
      nuevean:  cmp dx, 9
        jne seguir
        mov byte ptr [si], '9'
        dec si

      seguir: jmp endcomp

      endan:

        pop si
        pop DX
        pop CX
        pop BX
        pop AX
        ret

agregarNum endP

printAX proc
    ; imprime a la salida estándar un número que supone estar en el AX
    ; supone que es un número positivo y natural en 16 bits.
    ; lo imprime en decimal.  
    
    push AX
    push BX
    push CX
    push DX

    xor cx, cx
    mov bx, 10
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

CamLin Proc
   ;Imprime un cambio de linea
   push ax
   push dx
   mov dl, 13
   mov ah, 02h
   int 21h
   mov dl, 10
   int 21h
   pop dx
   pop ax
   ret
CamLin EndP

PrnRot Proc
    ; Recibe en el DS:[si] un puntero al rotulo.  Supone que es un asciiz
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

hayMadera proc
  ;Revisa si hay un pedazo de madera en esa posicion
  push ax
  push bx
  push cx
  push dx
  push si

  mov ax, 0B800h
  mov es, ax

  cmp madera, 0
  jne yahay

  nohay: mov ah, 03h
  xor bx, bx
  int 10h
  mov row, dh
  mov col, dl
  cPos
  mov dx, word ptr Es:[bx]
  cmp dl, 35
  je haygato
  jmp salirma

  haygato: mov si, 4
  mov byte ptr info[si], '#'
  call Pnivel
  mov madera, 1
  mov ah, 03h
  xor bx, bx
  int 10h
  mov ah, 01h
  mov cl, 0
  int 10h
  jmp salirma

  yahay: mov si, 4
    mov byte ptr info[si], '-'
    call Pnivel
    mov madera, 0
    mov ah, 01h
    mov ch, 6
    mov cl, 7
    xor bx, bx
    int 10h
    jmp salirma
  salirma: 
    pop si
    pop dx
    pop cx 
    pop bx
    pop ax
    ret
hayMadera endP

moverMadera proc
  ;Se mueve la madera seleccionada
  push ax
  push bx
  push cx
  push dx
  push si

  cmp dir, 1 ;si es flecha arriba
  jne fizqmm
  cmp row, 0
  jbe cnup
  cPos
  mov si, bx
  sub si, 160
  cmp byte ptr es:[si], 32
  jne cnup
  mov dh, 0110b
  mov dl, '#'
  mov word ptr es:[si], dx
  mov dh, 1111b
  mov dl, 32
  mov word ptr es:[bx], dx
  dec row
  mov ah, 02h
  xor bx, bx
  mov dh, row
  mov dl, col
  int 10h
  call coordenadas
  cnup: jmp salirmm

  fizqmm: cmp dir, 2 ;si es flecha izq
  jne fabamm
  cmp col, 0
  je cnizq
  cPos
  mov si, bx
  dec si
  dec si
  cmp byte ptr es:[si], 32
  jne cnizq
  mov dh, 0110b
  mov dl, '#'
  mov word ptr es:[si], dx
  mov dh, 1111b
  mov dl, 32
  mov word ptr es:[bx], dx
  dec col
  mov ah, 02h
  xor bx, bx
  mov dh, row
  mov dl, col
  int 10h
  call coordenadas
  cnizq: jmp salirmm

  fabamm: cmp dir, 3 ;si es flecha abajo
  jne fdermm
  cmp row, 23
  je cndown
  cPos
  mov si, bx
  add si, 160
  cmp byte ptr es:[si], 32
  jne cndown
  mov dh, 0110b
  mov dl, '#'
  mov word ptr es:[si], dx
  mov dh, 1111b
  mov dl, 32
  mov word ptr es:[bx], dx
  inc row
  mov ah, 02h
  xor bx, bx
  mov dh, row
  mov dl, col
  int 10h
  call coordenadas
  cndown: jmp salirmm

  fdermm: cmp dir, 4 ;si es flecha der
  jne cnder
  cmp col, 79
  je cnder
  cPos
  mov si, bx
  inc si
  inc si
  cmp byte ptr es:[si], 32
  jne cnder
  mov dh, 0110b
  mov dl, '#'
  mov word ptr es:[si], dx
  mov dh, 1111b
  mov dl, 32
  mov word ptr es:[bx], dx
  inc col
  mov ah, 02h
  xor bx, bx
  mov dh, row
  mov dl, col
  int 10h
  call coordenadas
  cnder:

  salirmm: 
  mov ah, 02h
  xor bx, bx
  mov dh, row
  mov dl, col
  int 10h
  pop si
  pop dx
  pop cx
  pop bx
  pop ax
  ret
moverMadera endP

starLvl proc
  ;inicia el nivel, el agua empieza a correr y si llega a la casa, se gana
  mov madera, 0
  mov si, 4
  mov byte ptr info[si], '-'
  call Pnivel
  mov ah, 01h
  mov ch, 6
  mov cl, 7
  xor bx, bx
  int 10h
  mov ah, 02h
  xor bx, bx
  mov dh, fuenteL
  mov dl, fuenteC
  mov row, dh
  mov col, dl
  int 10h
  mov bx, fuente
  mov si, bx
  mov bx, casa
  mov PP, 500
  call coordenadas
  
 aguas:
      pause 100
      mov ah, 01h
      int 16h
      jz cicloa

      xor ah, ah
      int 16h
      
      cmp al, 0
      je noascag
      jmp esascii1

      noascag: cmp ah, 19 ;si es alt + r
        jne noascag1
        jmp endlvl1

      noascag1: cmp ah, 81 ;+avPag  ir mas rapido
        jne noascag2
        cmp PP, 10
        jbe cicloa
        sub PP, 25
        jmp cicloa

       noascag2: cmp ah, 73 ;-  re mas lento
        jne cicloa
        cmp PP, 5000
        jae cicloa
        add PP, 25
        jmp cicloa
      
      esascii1: cmp al, 120 ;Si es x
        jne cicloa
        jmp perdiolvl

  cicloa: 
  add si, 160
  cmp row, 23
  je ader
  mov bx, casa
  cmp bx, si
  je ganolvl1
  cmp byte ptr es:[si], 32
  jne ader
  inc row
  mov ax, word ptr agua1
  mov word ptr es:[si], ax
  pause PP
  jmp aguas

 ader: sub si, 158
  cmp col, 79
  je aizq
  mov bx, casa
  cmp bx, si
  je ganolvl1
  cmp byte ptr es:[si], 32
  jne aizq
  inc col
  mov ax, word ptr agua1
  mov word ptr es:[si], ax
  pause PP
  jmp aguas

  ganolvl1: jmp ganolvl

 aizq: sub si, 4
  cmp col, 0 
  je aup
  mov bx, casa
  cmp bx, si
  je ganolvl1
  cmp byte ptr es:[si], 32
  jne aup
  dec col
  mov ax, word ptr agua1
  mov word ptr es:[si], ax
  pause PP
  jmp aguas

 aup: sub si, 158
  cmp row, 0
  je gaopi
  mov bx, casa
  cmp bx, si
  je ganolvl
  cmp byte ptr es:[si], 32
  jne gaopi
  dec row
  mov ax, word ptr agua1
  mov word ptr es:[si], ax
  pause PP
  jmp aguas

 gaopi: mov bx, casa ;arriba
  cmp si, bx
  je ganolvl
  add si, 162 ;derecha
  cmp si, bx
  je ganolvl
  add si, 158 ;Izquierda
  cmp si, bx
  je ganolvl
  sub si, 162 ;abajo
  cmp si, bx
  je ganolvl
  jmp perdiolvl

  ganolvl: 
      lea si, ganar
      mov dl, 24
      xor dh, dh
      mov bh, 1010b
      mov bl, 1111b
      call PrnRot
      mov ax, nivelActual
      inc ax
      mov nivelActual, ax
      jmp endlvl

  perdiolvl: 
      lea si, perder
      mov dl, 24
      xor dh, dh
      mov bh, 0100b
      mov bl, 1111b
      call PrnRot

      ciclo6: pause 100
        mov ah, 01h
        int 16h
        jz ciclo5
        xor ah, ah
        int 16h
        jmp ciclo6
      ciclo5: pause 100
        mov ah, 01h
        int 16h
        jz ciclo5
      xor ah, ah
      int 16h
      call rePrn
      ret

  endlvl: mov madera, 0
    mov si, 4
    mov byte ptr info[si], '-'
    mov ah, 01h
    mov ch, 6
    mov cl, 7
    xor bx, bx
    int 10h

    ciclo7: pause 100
        mov ah, 01h
        int 16h
        jz ciclo4
    xor ah, ah
    int 16h
    jmp ciclo7
    ciclo4: pause 100
        mov ah, 01h
        int 16h
        jz ciclo4
    xor ah, ah
    int 16h
  endlvl1:  call sigNivel
    call archivos 
        ret

starLvl endP

sigNivel proc
  ;busca el proximo archivo

  push ax
  push bx
  push dx
  push si

  mov madera, 0
  mov si, 4
  mov byte ptr info[si], '-'
  mov ah, 01h
  mov ch, 6
  mov cl, 7
  xor bx, bx
  int 10h

  mov ax, nivelActual
  cmp ax, 999
  ja ceroos1
  jmp camb
  ceroos1: xor ax, ax
    mov nivelActual, ax
  camb: lea si, nombreE
  add si, 4
  call agregarNum
  
  abrirTXTsn: mov ah, 3Dh ; abrir el archivo de entrada 
      xor al, al  ; código 0 para abrirlo como solo lectura
      lea dx, nombreE
      int 21h
      jnc cerrarsn
      jmp errorsn 

  cerrarsn: mov handleE, ax     
        mov ah, 3Eh ; cerrar el archivo de entrada
        mov bx, handleE
        int 21h 

        jmp salirsin
  errorsn: mov ax, nivelActual
        cmp ax, 999
        jae ceroos
        inc ax
        lea si, nombreE
        add si, 4
        call agregarNum
        mov nivelActual, ax
        jmp abrirTXTsn
        ceroos: mov ax, 0h
        lea si, nombreE
        add si, 4
        call agregarNum
        mov nivelActual, ax
        jmp abrirTXTsn
    salirsin: pop si
    pop dx
    pop bx
    pop ax
    ret
sigNivel endP

antNivel proc
  ;busca el proximo archivo

  push ax
  push bx
  push dx
  push si

  mov madera, 0
  mov si, 4
  mov byte ptr info[si], '-'
  mov ah, 01h
  mov ch, 6
  mov cl, 7
  xor bx, bx
  int 10h

  mov ax, nivelActual
  cmp ax, 0
  jb nuevees1
  jmp camb1
  nuevees1: mov ax, 999
    mov nivelActual, ax
  camb1: lea si, nombreE
  add si, 4
  call agregarNum
  abrirTXTan: mov ah, 3Dh ; abrir el archivo de entrada 
      xor al, al  ; código 0 para abrirlo como solo lectura
      lea dx, nombreE
      int 21h
      jnc cerraran
      jmp erroran 

  cerraran: mov handleE, ax     
        mov ah, 3Eh ; cerrar el archivo de entrada
        mov bx, handleE
        int 21h 

        jmp saliran
  erroran: mov ax, nivelActual
        cmp ax, 0
        jbe nuevees
        dec ax
        lea si, nombreE
        add si, 4
        call agregarNum
        mov nivelActual, ax
        jmp abrirTXTan
        nuevees: mov ax, 999
        lea si, nombreE
        add si, 4
        call agregarNum
        mov nivelActual, ax
        jmp abrirTXTan
    saliran: pop si
    pop dx
    pop bx
    pop ax
    ret
antNivel endP

main: mov ax, pila
      mov ss, ax

      mov ax, datos
      mov ds, ax

      mov ax, 0B800h
      mov es, ax

     ;Aqui lo principal del programa
     call cleanS
     call sigNivel
     call archivos
     
     ciclo:
      pause 100
      mov ah, 01h
      int 16h
      jz ciclo

      xor ah, ah
      int 16h 

      cmp al, 0
      je noasc
      jmp esascii
     noasc: cmp ah, 59 ;Si es F1
      jne talt
      call cleanS
      lea si, ayuda
      xor dx, dx
      xor bh, bh
      mov bl, 0111b
      call PrnRot
      mov ah, 02h
      xor bx, bx
      mov dh, 24
      mov dl, 40
      int 10h
      ciclo2: pause 100
        mov ah, 01h
        int 16h
        jz ciclo2
      xor ah, ah
      int 16h   
      call cleanS
      call archivos
      jmp ciclo

     talt: cmp ah, 30 ;Si es alt + a
      jne nrst
      call cleanS
      lea si, acercade
      mov dh, 2
      mov dl, 11
      mov bh, 0101b
      mov bl, 1111b
      call PrnRot
      lea si, acercade2
      inc dl
      mov dh, 6
      call PrnRot
      mov ah, 02h
      xor bx, bx
      mov dh, 13
      mov dl, 40
      int 10h
      ciclo1: pause 100
        mov ah, 01h
        int 16h
        jz ciclo1
      xor ah, ah
      int 16h   
      call cleanS
      call archivos
      jmp ciclo

     nrst: cmp ah, 19 ;si es alt + r
      jne farriba
      call archivos
      jmp ciclo

     farriba: cmp ah, 72 ;si es flecha arriba
      jne fizq
      goUp 
      jmp ciclo

     fizq: cmp ah, 75 ;si es flecha izq
      jne faba
      goLeft 
      jmp ciclo

     faba: cmp ah, 80 ;si es flecha abajo
      jne fder
      goDown 
      jmp ciclo

     fder: cmp ah, 77 ;si es flecha der
      jne volcic
      goRight 
     volcic: jmp ciclo

      esascii: cmp al, 27 ;Si es esc
        jne sigascii
        jmp endgame

       sigascii: cmp al, 43 ;+  avanzar nivel
        jne sigascii1
        mov ax, nivelActual 
        inc ax
        mov nivelActual, ax
        call sigNivel
        call archivos
        jmp ciclo

       sigascii1: cmp al, 45 ;-  anterior
        jne sigascii2
        mov ax, nivelActual 
        dec ax
        mov nivelActual, ax
        call antNivel
        call archivos
        jmp ciclo

      sigascii2: cmp al, 32 ;espacio, agarrar madera
        jne sigascii3
        call hayMadera
        jmp ciclo

      sigascii3: cmp al, 13 ;enter, iniciar nivel
        jne again
        call starLvl
        jmp ciclo

    again: jmp ciclo  

    endGame: 
      call cleanS
      mov ah, 01h
      mov ch, 6
      mov cl, 7
      int 10h
      mov ah, 02h
      xor bx, bx
      xor dx, dx
      int 10h
      mov ax, 4C00h

      int 21h 

codigo ends

end main