; Archivo:  01_PIN.s
; Micro:    PIC12F1572
; Autor:    Julio Mendoza
; Fecha:    2021-Junio
; Comp:	    pic-as(v2.32)

;-------------------------------------------------------------------------------
; Descripción
;   Ejemplo 1, lectura del estado lógico A3 y escribirlo en A2
;------------------------------------------------------------------------------- 

#include <xc.inc>

;-------------------------------------------------------------------------------
; Seccion de FUSES
;------------------------------------------------------------------------------- 
config FOSC = INTOSC	; oscilador interno
config WDTE = OFF	; WDT deshabilitado 
config MCLRE = OFF	; MCLR deshabilitado, A3 como entrada
config LVP = OFF	; LVP deshabilitado

;-------------------------------------------------------------------------------
; Código principal
;------------------------------------------------------------------------------- 

PSECT   start,class=ACODE,delta=2
; pin A2 como salida
	BANKSEL	TRISA 		; selecciona banco 
	BCF	TRISA,2		; A2 como salida
	BANKSEL PORTA
; loop infinito
LOOP:
	BTFSS	PORTA, 3	; pregunta el estado de A3
	GOTO	S2		; si es cero salta a S2
	BSF	LATA, 2		; poner en 1 A2
	GOTO	LOOP		; ir a LOOP 
S2:	;poner en 0 A2
	BCF	LATA, 2
	GOTO	LOOP		; ir a LOOP
