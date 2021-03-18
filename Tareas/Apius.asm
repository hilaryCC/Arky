;           Intituto Tecnológico de Costa Rica
; Escuela de Computación, Arquitectura de computadores IC3101
; Grupo 01, Tarea #2 Apio Claudius, 17/03/2021
; Profesor: Kirstein Gätjens S.
; Estudiante: Castro Cabezas Hilary Sofía, carné: 2020100628
;
;                  - MANUAL DE USUARIO -
;    1. Ensamble el archivo "CasHil.asm" con tasm y tlink
;           a. tasm CasHil (Crea el archivo obj)
;           b. tlink CasHil (Crea el archivo ejecutable)
;    2. Ejecute el archivo creado utilizando DOSbox. En 
;       la misma línea de comando, separado por un único
;       espacio del nombre del archivo, ingrese el numero
;       en romano que desee traducir a braille.
;       Ej: c:\>CasHil CCCXCIX
;
;    ** Reglas basicas de los numeros romanos:
;       1. El valor de las letras se debe sumar para obtener el valor completo de la cantidad que se representa 
;       2. Es posible duplicar o triplicar una letra para acumular una mayor cantidad, pero las letras que se 
;          pueden duplicar o triplicar son solo las que representan potencias de diez, no así las que representan  
;          mitades de potencias
;       3. Las letras potencias de diez que se colocan inmediatamente antes de las que representan mitades de 
;          potencias se restan en lugar de sumar. Solo es posible restar una unica letra que sea potencia de 
;          diez y debe ser del nivel inmediato anterior a la letra mitad de potencia de la que es restada.
;    ** En la traduccion al braille, el asterisco * simboliza un punto y el punto . simboliza un espacio en blanco,
;       es decir, la A, la B y la C se representarian asi respectivamente:
;                                               *.       *.       **     
;                                               ..       *.       ..
;                                               ..       ..       ..
;
;             - ANÁLISIS DE RESULTADOS -
; 1. Leer la linea de comandos...........................> A
; 2. Verificar que lo ingresado sean mayusculas..........> A
; 3. Verificar que las letras sean validas...............> A
; 4. Revisar que el orden de las letras sea valido.......> A
; 5. Realizar la suma segun las reglas...................> A
; 6. Convertir de decimal a letras.......................> A
; 7. Traducir a braille las letras.......................> A
; 8. Desplegar las letras en braille.....................> A
; 9. Desplegar mensaje de error..........................> A
; 10. Deplegar mini-acerca-de............................> A
; 11. Traduce hasta el 3999..............................> A
; 12. Cuenta la cantidad de repeticiones.................> A

datos segment

  rotulo db 128 dup ( ? )
  rotulo1 db 128 dup ( ? )
  numero dw 0
  restar dw 0 
  anterior dw 0
  acercaDe db "ITCR, Arquitectura de Computadores, Escuela de computacion, Tarea Apio Claudius", 10, '$'
  acercaDe2 db "Castro Cabezas Hilary, 2020100628, grupo 01, version 1.0, entrega 17/03/2021", 10, 10, '$'
  msjError db "(X) Numero romano invalido", 10, 10, "Reglas basicas: ", 10, "1. El valor de las letras se debe sumar para obtener el valor completo de la cantidad que se representa", 10, '$'
  msjError1 db  "2. Es posible duplicar o triplicar una letra para acumular una mayor cantidad, pero las letras que se pueden duplicar o triplicar son solo las que representan potencias de diez, no así las que representan mitades de potencias", 10, '$'
  msjError2 db "3. Las letras potencias de diez que se colocan inmediatamente antes de las que representan mitades de potencias se restan en lugar de sumar. Solo es posible restar una unica letra $"
  msjError3 db "que sea potencia de diez y debe ser del nivel inmediato anterior a la letra mitad de potencia de la que es restada", 10, '$'
  unidades db "uno$dos$tres$cuatro$cinco$seis$siete$ocho$nueve$diez$once$doce$trece$catorce$quince$dieci$veinte$veinti$treinta$cuarenta$cincuienta$sesenta$setenta$ochenta$noventa$cien$ciento$cientos$quinientos$setecientos$novecientos$mil$y$"   

datos endS

pila segment stack 'stack'
   dw 256 dup(?)
pila endS



codigo segment
    Assume CS:codigo,DS:datos,SS:pila

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

ErrorRom proc
    ;Despliega un mensaje en caso de que el numero romano ingresado sea invalido
    lea dx, msjError
    mov ah, 09h
    int 21h
    lea dx, msjError1
    int 21h
    lea dx, msjError2
    int 21h
    lea dx, msjError3
    int 21h
    mov ax, 4C00h
    int 21h 
ErrorRom endP

Revisar proc
    ;Verifica que las letras sean mayusculas y parte de los numeros romanos
    ;además cuenta la cantidad de veces que se repite una letra
    xor di, di
    xor bx, bx
    verificar: cmp byte ptr rotulo[di], 'I'
            je seguir
            cmp byte ptr rotulo[di], 'V'
            je seguir
            cmp byte ptr rotulo[di], 'X'
            je seguir
            cmp byte ptr rotulo[di], 'L'
            je seguir
            cmp byte ptr rotulo[di], 'C'
            je seguir
            cmp byte ptr rotulo[di], 'D'
            je seguir
            cmp byte ptr rotulo[di], 'M'
            je seguir
            call errorRom ;Si la letra ingresada no es ninguna de las anteriores, es por que es invalida
        seguir: inc di
                cmp di, cx
                jae sigI
                jmp verificar 

    sigI: xor di, di
    xor bx, bx
    contarI: cmp byte ptr rotulo[di], 'I' ;Compara cada letra y cuenta la cantidad segun las reglas
            jne seguirI1 
            inc bx
            cmp bl, 3
            jbe seguirI
            call errorRom
        seguirI1: xor bx, bx ;En caso de que dejen de ser repetidas, reinicia el contador
        seguirI: inc di ;Compara la siguiente letra
                cmp di, cx
                jae sigV ; Al llegar al final, se realiza el conteo de la siguiente letra
                jmp contarI ;Este proceso se repite con todas las letras     
    sigV: xor di, di
    xor bx, bx
    contarV: cmp byte ptr rotulo[di], 'V'
            jne seguirV
            inc bx
            cmp bl, 1
            jbe seguirV
            call errorRom 
        seguirV: inc di
                cmp di, cx
                jae sigX
                jmp contarV 

    sigX: xor di, di
    xor bx, bx
    contarX: cmp byte ptr rotulo[di], 'X'
            jne seguirX1
            inc bx
            cmp bl, 3
            jbe seguirX
            call errorRom
        seguirX1: xor bx, bx 
        seguirX: inc di
                cmp di, cx
                jae sigL
                jmp contarX 
    sigL: xor di, di
    xor bx, bx
    contarL: cmp byte ptr rotulo[di], 'L'
            jne seguirL
            inc bx
            cmp bl, 1
            jbe seguirL
            call errorRom 
        seguirL: inc di
                cmp di, cx
                jae sigC
                jmp contarL 
    sigC: xor di, di
    xor bx, bx
    contarC: cmp byte ptr rotulo[di], 'C'
            jne seguirC1
            inc bx
            cmp bl, 3
            jbe seguirC
            call errorRom
        seguirC1: xor bx, bx 
        seguirC: inc di
                cmp di, cx
                jae sigD
                jmp contarC 
    sigD: xor di, di
    xor bx, bx
    contarD: cmp byte ptr rotulo[di], 'D'
            jne seguirD
            inc bx
            cmp bl, 1
            jbe seguirD
            call errorRom 
        seguirD: inc di
                cmp di, cx
                jae sigM
                jmp contarD
    sigM: xor di, di
    xor bx, bx
    contarM: cmp byte ptr rotulo[di], 'M'
            jne seguirM1
            inc bx
            cmp bl, 3
            jbe seguirM
            call errorRom
        seguirM1: xor bx, bx 
        seguirM: inc di
                cmp di, cx
                jae volver
                jmp contarM
    volver: ret 
Revisar endP

Reglas proc
    ;Revisa que el orden de las letras sea valido
    xor di, di
    xor bx, bx
    verificar1: cmp byte ptr rotulo[di], 'I' ; Se compara y revisa que cada letra tenga al frente otra letra valida
            jne s1
            inc di
            cmp di, cx
            je seguir1
            dec di
            cmp byte ptr rotulo[di+1], 'X'
            je seguir1
            cmp byte ptr rotulo[di+1], 'V'
            je seguir1
            cmp byte ptr rotulo[di+1], 'I'
            je seguir1
            call ErrorRom ; Si ninguna de las 3 condiciones anteriores se cumplen, es invalido el numero (se repite con todas las letras)

            s1: cmp byte ptr rotulo[di], 'V'
            jne s2
            inc di
            cmp di, cx
            je seguir1
            dec di
            cmp byte ptr rotulo[di+1], 'I'
            je seguir1
            call ErrorRom

            s2: cmp byte ptr rotulo[di], 'X'
            jne s3
            inc di
            cmp di, cx
            je seguir1
            dec di
            cmp byte ptr rotulo[di+1], 'D'
            je cerror
            cmp byte ptr rotulo[di+1], 'M'
            je cerror
            jmp seguir1
            cerror: call ErrorRom

            seguir1: inc di
                cmp di, cx
                jae salirC
                jmp verificar1

            s3: cmp byte ptr rotulo[di], 'L'
            jne s4
            inc di
            cmp di, cx
            je seguir1
            dec di
            cmp byte ptr rotulo[di+1], 'I'
            je seguir1
            cmp byte ptr rotulo[di+1], 'V'
            je seguir1
            cmp byte ptr rotulo[di+1], 'X'
            je seguir1
            call ErrorRom

            s4: cmp byte ptr rotulo[di], 'C'
            jne s5

            s5: cmp byte ptr rotulo[di], 'D'
            jne s6
            inc di
            cmp di, cx
            je seguir1
            dec di
            cmp byte ptr rotulo[di+1], 'M'
            je cerror1
            jmp seguir1
            cerror1: call ErrorRom

            s6: cmp byte ptr rotulo[di], 'M'
            jne seguir1
    salirC: ret
Reglas endP
    
RomDec proc
    ;Realiza la suma de los valores de las letras segun las reglas
    xor di, di
    xor bx, bx
    xor ax, ax
    valores: cmp byte ptr rotulo[di], 'I' ; Se compara para buscar el valor de cada letra
            jne jV
            push bx ;El bx lleva la cuenta por lo que se debe guardar antes de modificarlo
            mov ax, 1 ;ax tiene el valor de la letra actual
            mov bx, anterior ;bx tiene el valor de la letra anterior (izquierda de la actual)
            jmp sumRes  
        jV: cmp byte ptr rotulo[di], 'V'
            jne jX
            push bx
            mov ax, 5
            mov bx, anterior
            jmp sumRes
        jX: cmp byte ptr rotulo[di], 'X'
            jne juL
            push bx
            mov ax, 10
            mov bx, anterior
            jmp sumRes
        juL: cmp byte ptr rotulo[di], 'L'
            jne juC
            push bx
            mov ax, 50
            mov bx, anterior
            jmp sumRes
        juC: cmp byte ptr rotulo[di], 'C'
            jne jD
            push bx
            mov ax, 100
            mov bx, anterior
            jmp sumRes
        jD: cmp byte ptr rotulo[di], 'D'
            jne jM
            push bx
            mov ax, 500
            mov bx, anterior
            jmp sumRes
        jM: cmp byte ptr rotulo[di], 'M'
            push bx
            mov ax, 1000
            mov bx, anterior
            jmp sumRes 
        seguirRD: inc di
                cmp di, cx
                je numFinal
                jmp valores
    sumRes: cmp bx, ax ; Se compara para saber si el numero guardado en anterior debe ser restado o sumado al numero
            jae sum ; Si actual es menor o igual que anterior, anterior se suma al numero
            add restar, bx ; Si es mayor, se debe restar al numero
            mov anterior, ax ; Actual pasa a ser el anterior
            pop bx
            jmp seguirRD 
        sum: add numero, bx
            mov anterior, ax
            pop bx
            jmp seguirRD 

    numFinal: mov bx, anterior
            add numero, bx 
            mov ax, numero
            mov bx, restar
            sub ax, bx
            mov numero, ax
            ret
RomDec endP

AddNum proc
    ;Agrega el nombre del numero a la variable rotulo1
    push ax
 printA: cmp byte ptr unidades[di], '$'
        je salirAN
        mov al, byte ptr unidades[di]
        mov byte ptr rotulo1[si], al
        inc si
        inc di
        jmp printA
 salirAN: mov byte ptr rotulo1[si], ' '
        inc si
        pop ax       
        ret

AddNum endP

DecLet proc
    ;Convierte de numero decimal al nombre del numero
    mov ax, numero
    xor bx, bx
    xor si, si

 primero: cmp ax, 3000
        jb m2 
        mov di, 8
        call AddNum
        mov di, 219
        call AddNum
        sub ax, 3000
        jmp comparar0
        m2: cmp ax, 2000
            jb m1
            mov di, 4
            call AddNum
            mov di, 219
            call AddNum
            sub ax, 2000
            jmp comparar0
        m1: cmp ax, 1000
            jb c9
            mov di, 0
            call AddNum
            mov di, 219
            call AddNum
            sub ax, 1000
            jmp comparar0
        c9: cmp ax, 900
            jb c8
            mov di, 207
            call AddNum
            sub ax, 900
            jmp comparar0
        c8: cmp ax, 800
            jb c7
            mov di, 37
            call AddNum
            dec si
            mov di, 176
            call AddNum
            sub ax, 800
            jmp comparar0
        c7: cmp ax, 700
            jb c6
            mov di, 195
            call AddNum
            sub ax, 700
            jmp comparar0
        c6: cmp ax, 600
            jb c5
            mov di, 26
            call AddNum
            dec si
            mov di, 176
            call AddNum
            sub ax, 600
            jmp comparar0
        c5: cmp ax, 500
            jb c4
            mov di, 184
            call AddNum
            sub ax, 500
            jmp comparar0
        c4: cmp ax, 400
            jb c3 
            mov di, 13
            call AddNum
            dec si
            mov di, 176
            call AddNum
            sub ax, 400
            jmp comparar0
        c3: cmp ax, 300
            jb c2
            mov di, 8
            call AddNum
            dec si
            mov di, 176
            call AddNum
            sub ax, 300
            jmp comparar0
        c2: cmp ax, 200
            jb c1
            mov di, 4
            call AddNum
            dec si
            mov di, 176
            call AddNum
            sub ax, 200
            jmp comparar0
        c1: cmp ax, 100
            jb d9
            mov di, 184
            call AddNum
            sub ax, 500
            jmp comparar0
        d9: cmp ax, 90
            jb d8
            mov di, 156
            call AddNum
            cmp ax, 90
            ja cont9
            sub ax, 90
            jmp comparar0
          cont9: mov di, 223
                call AddNum
                sub ax, 90
                jmp comparar0  
        d8: cmp ax, 80
            jb d7
            mov di, 148
            call AddNum
            cmp ax, 80
            ja cont8
            sub ax, 80
            jmp comparar0
          cont8: mov di, 223
                call AddNum
                sub ax, 80
                jmp comparar0
        d7: cmp ax, 70
            jb d6
            mov di, 140
            call AddNum
            cmp ax, 70
            ja cont7
            sub ax, 70
            jmp comparar0
          cont7: mov di, 223
                call AddNum
                sub ax, 70
                jmp comparar0
        d6: cmp ax, 60
            jb d5
            mov di, 132
            call AddNum
            cmp ax, 60
            ja cont6
            sub ax, 60
            jmp comparar0
          cont6: mov di, 223
                call AddNum
                sub ax, 60
                jmp comparar0
        d5: cmp ax, 50
            jb d4 
            mov di, 121
            call AddNum
            cmp ax, 50
            ja cont5
            sub ax, 50
            jmp comparar0
          cont5: mov di, 223
                call AddNum
                sub ax, 50
                jmp comparar0
        d4: cmp ax, 40
            jb d3
            mov di, 112
            call AddNum
            cmp ax, 40
            ja cont4
            sub ax, 40
            jmp comparar0
          cont4: mov di, 223
                call AddNum
                sub ax, 40
                jmp comparar0
        d3: cmp ax, 30
            jb d2
            mov di, 104
            call AddNum
            cmp ax, 30
            ja cont3
            sub ax, 30
            jmp comparar0
          cont3: mov di, 223
                call AddNum
                sub ax, 30
                jmp comparar0
        d2: cmp ax, 20
            jb d19
            cmp ax, 20
            je veinte
            mov di, 97
            call AddNum
            dec si
            sub ax, 20
            jmp comparar0
          veinte: mov di, 90
                call AddNum
                sub ax, 20
                jmp comparar0
        d19: cmp ax, 19
            jb d14
            mov di, 84
            call AddNum
            dec si
            mov di, 42
            call AddNum
            sub ax, 19
            jmp comparar0
        d18: cmp ax, 18
            jb d14
            mov di, 84
            call AddNum
            dec si
            mov di, 37
            call AddNum
            sub ax, 18
            jmp comparar0
        d17: cmp ax, 17
            jb d14
            mov di, 84
            call AddNum
            dec si
            mov di, 31
            call AddNum
            sub ax, 17
            jmp comparar0
        d16: cmp ax, 16
            jb d14
            mov di, 84
            call AddNum
            dec si
            mov di, 26
            call AddNum
            sub ax, 16
            jmp comparar0
        d15: cmp ax, 15
            jb d14
            mov di, 77
            call AddNum
            sub ax, 15
            jmp comparar0
        d14: cmp ax, 14
            jb d13
            mov di, 69
            call AddNum
            sub ax, 14
            jmp comparar0
        d13: cmp ax, 13
            jb d12
            mov di, 63
            call AddNum
            sub ax, 13
            jmp comparar0
        d12: cmp ax, 12
            jb d11
            mov di, 58
            call AddNum
            sub ax, 12
            jmp comparar0
        d11: cmp ax, 11
            jb d1
            mov di, 53
            call AddNum
            sub ax, 11
            jmp comparar0
        d1: cmp ax, 10
            jb u9
            mov di, 48
            call AddNum
            sub ax, 10
            jmp comparar0
        u9: cmp ax, 9
            jb u8
            mov di, 42
            call AddNum
            sub ax, 9
            jmp comparar0
        u8: cmp ax, 8
            jb u7
            mov di, 37
            call AddNum
            sub ax, 8
            jmp comparar0
        u7: cmp ax, 7
            jb u6
            mov di, 31
            call AddNum
            sub ax, 7
            jmp comparar0
        u6: cmp ax, 6
            jb u5
            mov di, 26
            call AddNum
            sub ax, 6
            jmp comparar0
        u5: cmp ax, 5
            jb u4
            mov di, 20
            call AddNum
            sub ax, 5
            jmp comparar0
        u4: cmp ax, 4
            jb u3
            mov di, 13
            call AddNum
            sub ax, 4
            jmp comparar0
        u3: cmp ax, 3
            jb u2
            mov di, 8
            call AddNum
            sub ax, 3
            jmp comparar0
        u2: cmp ax, 2
            jb u1
            mov di, 4
            call AddNum
            sub ax, 2
            jmp comparar0
        u1: cmp ax, 1
            jb comparar0
            mov di, 0
            call AddNum
            sub ax, 1
            jmp comparar0
    comparar0: cmp ax, 0
            jbe return
            jmp primero
    return: dec si
            mov byte ptr rotulo1[si], '$'
            ret    
DecLet endP

LetBrai proc
    ;Traduce el nombre del numero a braille y lo despliega
    xor di, di
    mov ah, 02h
    primeraLn: cmp byte ptr rotulo1[di], 'i'
            jne sS1
            mov dl, '.'
            int 21h
            mov dl, '*'
            int 21h
            jmp sgtL
        sS1: cmp byte ptr rotulo1[di], 's'
            jne sT1
            mov dl, '.'
            int 21h
            mov dl, '*'
            int 21h
            jmp sgtL
        sT1: cmp byte ptr rotulo1[di], 't'
            jne sA1
            mov dl, '.'
            int 21h
            mov dl, '*'
            int 21h
            jmp sgtL
        sA1: cmp byte ptr rotulo1[di], 'a'
            jne sE1
            mov dl, '*'
            int 21h
            mov dl, '.'
            int 21h
            jmp sgtL
        sE1: cmp byte ptr rotulo1[di], 'e'
            jne sH1
            mov dl, '*'
            int 21h
            mov dl, '.'
            int 21h
            jmp sgtL
        sH1: cmp byte ptr rotulo1[di], 'h'
            jne sL1
            mov dl, '*'
            int 21h
            mov dl, '.'
            int 21h
            jmp sgtL
        sL1: cmp byte ptr rotulo1[di], 'l'
            jne sO1 
            mov dl, '*'
            int 21h
            mov dl, '.'
            int 21h
            jmp sgtL
        sO1: cmp byte ptr rotulo1[di], 'o'
            jne sR1 
            mov dl, '*'
            int 21h
            mov dl, '.'
            int 21h
            jmp sgtL
        sR1: cmp byte ptr rotulo1[di], 'r'
            jne sU1
            mov dl, '*'
            int 21h
            mov dl, '.'
            int 21h
            jmp sgtL
        sU1: cmp byte ptr rotulo1[di], 'u'
            jne sV1
            mov dl, '*'
            int 21h
            mov dl, '.'
            int 21h
            jmp sgtL
        sV1: cmp byte ptr rotulo1[di], 'v'
            jne sZ1 
            mov dl, '*'
            int 21h
            mov dl, '.'
            int 21h
            jmp sgtL
        sZ1: cmp byte ptr rotulo1[di], 'z'
            jne sY1
            mov dl, '*'
            int 21h
            mov dl, '.'
            int 21h
            jmp sgtL
        sY1: cmp byte ptr rotulo1[di], 'y'
            jne sC1
            mov dl, '*'
            int 21h
            mov dl, '*'
            int 21h
            jmp sgtL 
        sC1: cmp byte ptr rotulo1[di], 'c'
            jne sD1
            mov dl, '*'
            int 21h
            mov dl, '*'
            int 21h
            jmp sgtL
        sD1: cmp byte ptr rotulo1[di], 'd'
            jne sM1
            mov dl, '*'
            int 21h
            mov dl, '*'
            int 21h
            jmp sgtL
        sM1: cmp byte ptr rotulo1[di], 'm'
            jne sN1
            mov dl, '*'
            int 21h
            mov dl, '*'
            int 21h
            jmp sgtL 
        sN1: cmp byte ptr rotulo1[di], 'n'
            jne sQ1
            mov dl, '*'
            int 21h
            mov dl, '*'
            int 21h
            jmp sgtL
        sQ1: cmp byte ptr rotulo1[di], 'i'
            jne sEsp
            mov dl, '*'
            int 21h
            mov dl, '*'
            int 21h
            jmp sgtL
        sEsp: cmp byte ptr rotulo1[di], ' '
            jne sEnd
            mov dl, '.'
            int 21h
            mov dl, '.'
            int 21h
            jmp sgtL
        sEnd: cmp byte ptr rotulo1[di], '$'
            je segundaLn
        sgtL: inc di
            mov dl, ' '
            int 21h
            mov dl, ' '
            int 21h
            jmp primeraLn
    segundaLn: xor di, di
            call CamLin
    sgdaLn: cmp byte ptr rotulo1[di], 'i'
            jne sS2
            mov dl, '*'
            int 21h
            mov dl, '.'
            int 21h
            jmp sgtL2
        sS2: cmp byte ptr rotulo1[di], 's'
            jne sT2
            mov dl, '*'
            int 21h
            mov dl, '.'
            int 21h
            jmp sgtL2
        sT2: cmp byte ptr rotulo1[di], 't'
            jne sA2
            mov dl, '*'
            int 21h
            mov dl, '*'
            int 21h
            jmp sgtL2
        sA2: cmp byte ptr rotulo1[di], 'a'
            jne sE2
            mov dl, '.'
            int 21h
            mov dl, '.'
            int 21h
            jmp sgtL2
        sE2: cmp byte ptr rotulo1[di], 'e'
            jne sH2
            mov dl, '.'
            int 21h
            mov dl, '*'
            int 21h
            jmp sgtL2
        sH2: cmp byte ptr rotulo1[di], 'h'
            jne sL2
            mov dl, '*'
            int 21h
            mov dl, '*'
            int 21h
            jmp sgtL2
        sL2: cmp byte ptr rotulo1[di], 'l'
            jne sO2 
            mov dl, '*'
            int 21h
            mov dl, '.'
            int 21h
            jmp sgtL2
        sO2: cmp byte ptr rotulo1[di], 'o'
            jne sR2 
            mov dl, '.'
            int 21h
            mov dl, '*'
            int 21h
            jmp sgtL2
        sR2: cmp byte ptr rotulo1[di], 'r'
            jne sU2 
            mov dl, '*'
            int 21h
            mov dl, '*'
            int 21h
            jmp sgtL2
        sU2: cmp byte ptr rotulo1[di], 'u'
            jne sV2
            mov dl, '.'
            int 21h
            mov dl, '.'
            int 21h
            jmp sgtL2
        sV2: cmp byte ptr rotulo1[di], 'v'
            jne sZ2 
            mov dl, '*'
            int 21h
            mov dl, '.'
            int 21h
            jmp sgtL2
        sZ2: cmp byte ptr rotulo1[di], 'z'
            jne sY2
            mov dl, '.'
            int 21h
            mov dl, '*'
            int 21h
            jmp sgtL2
        sY2: cmp byte ptr rotulo1[di], 'y'
            jne sC2
            mov dl, '.'
            int 21h
            mov dl, '*'
            int 21h
            jmp sgtL2 
        sC2: cmp byte ptr rotulo1[di], 'c'
            jne sD2
            mov dl, '.'
            int 21h
            mov dl, '.'
            int 21h
            jmp sgtL2
        sD2: cmp byte ptr rotulo1[di], 'd'
            jne sM2
            mov dl, '.'
            int 21h
            mov dl, '*'
            int 21h
            jmp sgtL2
        sM2: cmp byte ptr rotulo1[di], 'm'
            jne sN2
            mov dl, '.'
            int 21h
            mov dl, '.'
            int 21h
            jmp sgtL2 
        sN2: cmp byte ptr rotulo1[di], 'n'
            jne sQ2
            mov dl, '.'
            int 21h
            mov dl, '*'
            int 21h
            jmp sgtL2
        sQ2: cmp byte ptr rotulo1[di], 'i'
            jne sEsp2
            mov dl, '*'
            int 21h
            mov dl, '.'
            int 21h
            jmp sgtL2
        sEsp2: cmp byte ptr rotulo1[di], ' '
            jne sEnd2
            mov dl, '.'
            int 21h
            mov dl, '.'
            int 21h
            jmp sgtL2
        sEnd2: cmp byte ptr rotulo1[di], '$'
            je terceraLn
        sgtL2: inc di
            mov dl, ' '
            int 21h
            mov dl, ' '
            int 21h
            jmp sgdaLn
    terceraLn: xor di, di
            call CamLin
        tcrLn: cmp byte ptr rotulo1[di], ' '
            jne lstOp
            mov dl, '.'
            int 21h
            mov dl, '.'
            int 21h
            jmp sgtL3
        lstOp: cmp byte ptr rotulo1[di], '$'
            jne tcrLn1
            call CamLin
            ret
        tcrLn1: cmp byte ptr rotulo1[di], 105
            ja sgdaOp
            mov dl, '.'
            int 21h
            mov dl, '.'
            int 21h
            jmp sgtL3
        sgdaOp: cmp byte ptr rotulo1[di], 116
            ja traOp
            mov dl, '*'
            int 21h
            mov dl, '.'
            int 21h
            jmp sgtL3
        traOp: cmp byte ptr rotulo1[di], 122
            ja lstOp
            mov dl, '*'
            int 21h
            mov dl, '*'
            int 21h
            jmp sgtL3
        sgtL3: inc di
            mov dl, ' '
            int 21h
            mov dl, ' '
            int 21h
            jmp tcrLn

LetBrai endP

main: mov ax, ds
    mov es, ax

    mov ax, pila
    mov ss, ax

    mov ax, datos
    mov ds, ax

    mov si, 80h              
    mov cl, byte ptr es:[si] 

    xor ch, ch
    cmp cx, 1
    ja seg1
    call ErrorRom

    seg1: xor di, di
    inc si
    dec cx

    mov ah, 09h
    lea dx, acercaDe
    int 21h
    lea dx, acercaDe2
    int 21h

    push cx ;El cx guarda el tamaño del numero romano, por lo que se guarda para usarlo luego
    ciclo: inc si
        mov al, byte ptr es:[si]
        mov byte ptr rotulo[di], al
        inc di
        loop ciclo

    pop cx
    call Revisar
    call Reglas
    call RomDec
    mov ax, numero
    ;call printAX ;Quitar estos comentario para desplegar el numero en decimal
    ;call CamLin
    call DecLet
    lea dx, rotulo1
    mov ah, 09h
    ;int 21h ;Quitar estos comentario para desplegar el nombre del numero en español
    ;call CamLin
    call LetBrai
    mov ax, 4C00h

    int 21h 

codigo ends

end main
