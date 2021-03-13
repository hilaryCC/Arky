datos segment

  rotulo db 128 dup ( ? )
  lnUno db 128 dup ( ? )
  lnDos db 128 dup ( ? )
  lnTres db 128 dup ( ? )
  numero db 0
  restar db 0 
  anterior db 0
  acercaDe db "ITCR, Arquitectura de Computadores, Escuela de computacion, Tarea Apio Claudius", 10, '$'
  acercaDe2 db "Castro Cabezas Hilary, 2020100628, grupo 01, version 1.0, entrega 17/03/2021", 10, 10, '$'
  msjError db "Error",10,'$'
  unidades db "dos$", "tres$", "cuatro$", "cinco$", "seis$", "siete$", "ocho$", "nueve$", "diez$"

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
    lea dx, msjError
    mov ah, 09h
    int 21h
    mov ax, 4C00h
    int 21h 
ErrorRom endP

Revisar proc
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
            call errorRom 
        seguir: inc di
                cmp di, cx
                jae sigI
                jmp verificar 

    sigI: xor di, di
    xor bx, bx
    contarI: cmp byte ptr rotulo[di], 'I'
            jne seguirI
            inc bx
            cmp bl, 3
            jbe seguirI
            call errorRom 
        seguirI: inc di
                cmp di, cx
                jae sigV
                jmp contarI     
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
            jne seguirX
            inc bx
            cmp bl, 3
            jbe seguirX
            call errorRom 
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
            jne seguirC
            inc bx
            cmp bl, 3
            jbe seguirC
            call errorRom 
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
            jne seguirM
            inc bx
            cmp bl, 3
            jbe seguirM
            call errorRom 
        seguirM: inc di
                cmp di, cx
                jae volver
                jmp contarM
    volver: ret 
Revisar endP

Reglas proc
    xor di, di
    xor bx, bx
    verificar1: cmp byte ptr rotulo[di], 'I'
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
            call ErrorRom

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
            call errorRom 
        seguir: inc di
                cmp di, cx
                jae sigI
                jmp verificar 
RomDec endP

main: mov ax, ds
    mov es, ax

    mov ax, pila
    mov ss, ax

    mov ax, datos
    mov ds, ax

    mov si, 80h              
    mov cl, byte ptr es:[si] 

    xor ch, ch               
    xor di, di
    inc si
    dec cx

    mov ah, 09h
    lea dx, acercaDe
    int 21h
    lea dx, acercaDe2
    int 21h

    push cx
    cmp cx, 0
    ja ciclo
    call ErrorRom
    ciclo: inc si
        mov al, byte ptr es:[si]
        mov byte ptr rotulo[di], al
        inc di
        loop ciclo

    pop cx
    call Revisar
    call Reglas
    mov ax, 4C00h

    int 21h 

codigo ends

end main
