; Sokoban basado en el asterix
; Use las flechas para empujar los caracteres que encuentre en la pantalla y destruirlos al chocarlos con otros

Pila Segment Stack 'Stack'
	dw 2048 dup(?)
Pila Ends

Datos Segment
        FIL DB 20
        COL DB 50
        DIR DB 4
        ASTERIX DB '*',0AH   ; Fondo negro y asterisco verde CLARO
        PAUSA1 dw 1000
        PAUSA2 dw 100 
Datos Ends

Codigo Segment
	Assume DS:Datos,CS:Codigo,SS:Pila

Inicio: MOV AX,DATOS
        MOV DS,AX
        MOV AX,PILA
        MOV SS,AX
       
	
	MOV AX,0B800H
        MOV ES,AX
	CALL MOVIMIENTO
        MOV AX, 4C00h
        INT 21h

MOVIMIENTO PROC NEAR
; Este procedimiento pone el asterisco, hace una pasua y lo mueve un campo
  
DESPLEGAR:	MOV AL,160           ; Calculamos BX = FIL*160+Col*2 
	        MUL FIL
	        XOR BH, BH
	        MOV BL, COL
	        SHL BX,1
	        ADD BX,AX



        MOV DX,WORD PTR ES:[BX]     ; Salvamos lo que hay en la pantalla
        MOV AX,WORD PTR ASTERIX     ; Movemos al AX el asterisco

        cmp dl,32
        jne haycchar

        MOV WORD PTR ES:[BX],AX     ; Ponemos el asterisco en pantalla


        MOV CX, PAUSA1       ; Hacemos una pausa de 100 x 1000 nops
P1:     PUSH CX
        MOV CX, PAUSA2
P2:     NOP
        LOOP P2
        POP CX
        LOOP P1


        MOV WORD PTR ES:[BX],DX    ; Borramos el asterisco
        jmp revisartecla

haycchar: cmp dir,0
          je arriba
          cmp dir,1
          je izquierda
          cmp dir,2
          je derecha
          cmp dir,3
          je abajo

          jmp salirempujar      

arriba: mov si, bx
        sub si, 160
        cmp byte PTR ES:[si],32
        jne salirempujar
        mov WORD PTR ES:[si],dx  
        jmp salirempujar

abajo: mov si, bx
       add si, 160
       cmp byte PTR ES:[si],32
       jne salirempujar
       mov WORD PTR ES:[si],dx  
       jmp salirempujar

derecha: mov si, bx
       add si, 2
       cmp byte PTR ES:[si],32
       jne salirempujar
       mov WORD PTR ES:[si],dx  
       jmp salirempujar
 
izquierda: mov si, bx
       sub si, 2
       cmp byte PTR ES:[si],32
       jne salirempujar
       mov WORD PTR ES:[si],dx  
       jmp salirempujar


salirempujar: mov dl, 32 
              MOV WORD PTR ES:[BX],DX    ; Borramos el caracter


revisartecla:
		;INTERRUPCION DE TECLADO
		MOV AH,01H
		INT 16H
		JZ  auxilio         
            	JMP HAYTECLA
      auxilio:  JMP DESPLEGAR ; Algor  

;----------------------------MUEVE EL ASTERISCO---------------------------
ALGOR:

           CMP DIR, 0      ; Con saltos de conejo pues ya da fuera de rango
           JNE PREGUNTE1
           JMP CERO
PREGUNTE1: CMP DIR, 1      ; Con saltos de conejo pues ya da fuera de rango
           JNE PREGUNTE2
           JMP UNO
PREGUNTE2: CMP DIR, 2      ; Con saltos de conejo pues ya da fuera de rango
           JNE PREGUNTE3
           JMP DOS
PREGUNTE3: CMP DIR, 3      ; Con saltos de conejo pues ya da fuera de rango
           JNE PREGUNTE4
           JMP TRES
PREGUNTE4: CMP DIR, 4      ; Con saltos de conejo pues ya da fuera de rango
           JNE PREGUNTE5
           JMP CUATRO
PREGUNTE5: CMP DIR, 5
           JNE PREGUNTE6
           JMP CINCO
PREGUNTE6: CMP DIR, 6
           JNE PREGUNTE7
           JMP SEIS

PREGUNTE7: CMP DIR, 7
           JNE PREGUNTE8
           JMP SIETE
PREGUNTE8: Jmp Repetir


CERO:  CMP FIL,0
       JE CD0   
       DEC FIL
CD0:   MOV DIR, 0
       JMP REPETIR

UNO:   CMP COL,0
       JE CD1   
       DEC COL
CD1:   MOV DIR, 1
       JMP REPETIR

DOS:   CMP COL,79
       JE CD2   
       INC COL
CD2:   MOV DIR, 2
       JMP REPETIR

TRES:  CMP FIL,24
       JE CD3   
       INC FIL
CD3:   MOV DIR, 3
       JMP REPETIR



SIETE:  CMP FIL,0
        JE CD7A   ; Cambio la direccion a 6
        DEC FIL
        CMP COL,79
        JE CD7B   ; Cambio la direccion a 4
        INC COL
        JMP REPETIR
CD7A:   MOV DIR, 6
        JMP REPETIR
CD7B:   MOV DIR, 4
        JMP REPETIR

SEIS:   CMP FIL,24
        JE CD6A   ; Cambio la direccion a 7
        INC FIL
        CMP COL,79
        JE CD6B   ; Cambio la direccion a 5
        INC COL
        JMP REPETIR
CD6A:   MOV DIR, 7
        JMP REPETIR
CD6B:   MOV DIR, 5
        JMP REPETIR

CINCO:  CMP FIL,24
        JE CD5A   ; Cambio la direccion a 4
        INC FIL
        CMP COL,0
        JE CD5B   ; Cambio la direccion a 6
        DEC COL
        JMP REPETIR
CD5A:   MOV DIR, 4
        JMP REPETIR
CD5B:   MOV DIR, 6
        JMP REPETIR

CUATRO: CMP FIL,0
        JE CD4A   ; Cambio la direccion a 5
        DEC FIL
        CMP COL,0
        JE CD4B   ; Cambio la direccion a 7
        DEC COL
        JMP REPETIR
CD4A:   MOV DIR, 5
        JMP REPETIR
CD4B:   MOV DIR, 7
		JMP REPETIR

;------------------------------------------------------------------------		
;PROCESA LA TECLA DE FUNCION EXTENDIDA
HAYTECLA:	        XOR AH,AH
			INT 16H
			CMP AL,27	;SI ES ESC
			JZ SALIR
			
			CMP AL,0
			JZ REVISE_DIR
			JMP ALGOR
			
REVISE_DIR:	CMP AH,47H	;SI ES HOME
			JNE S1 
			MOV DIR,4
			JMP salircambiodir
		S1:	CMP AH,49H	;SI ES PG UP
			JNZ S2
			MOV DIR,7
			JMP salircambiodir
		S2:	CMP AH,4FH	;SI ES END
			JNZ S3
			MOV DIR,5
			JMP salircambiodir
		S3:	CMP AH,51H	;SI ES PG DN
			JNZ S4
                        MOV DIR,6 
			JMP salircambiodir
		S4:	CMP AH,72	;SI ES flecha arriba
			JNZ S5
                        MOV DIR,0  
			JMP salircambiodir
		S5:	CMP AH,75	;SI ES flecha izquierda
			JNZ S6
                        MOV DIR,1  
			JMP salircambiodir
		S6:	CMP AH,77	;SI ES flecha derecha
			JNZ S7
                        MOV DIR,2  
			JMP salircambiodir
		S7:	CMP AH,80	;SI ES flecha abajo
			JNZ S8
                        MOV DIR,3  
			JMP salircambiodir
                S8:
      
     
 salircambiodir:        jmp algor    ; jmp desplegar
                

		
			
REPETIR: JMP DESPLEGAR

SALIR:  RET

MOVIMIENTO ENDP

Codigo ENDS
END Inicio