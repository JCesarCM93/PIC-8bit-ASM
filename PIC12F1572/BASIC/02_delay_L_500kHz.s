; Archivo:  02_delay_L_500kHz.s
; Micro:    PIC12F1572
; Autor:    Julio Mendoza
; Fecha:    2021-Junio
; Comp:	    pic-as(v2.32)

;-------------------------------------------------------------------------------
; Descripción
;	Ejemplo 2, encendido y apagado de un LED conectado en A2 con un periodo 
;	máximo de 5ms, con frecuencia interna de 500KHz:125IPS
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
	BANKSEL	ANSELA 		; selecciona banco 
	BCF	ANSELA,2	; A2 como digital
	BANKSEL	TRISA 		; selecciona banco 
	BCF	TRISA,2		; A2 como salida
	BANKSEL PORTA
; loop infinito

LOOP:	
	BSF	PORTA, 2	; poner en 1 A2
	CALL	RETARDO
	BCF	PORTA, 2	; poner en 0 A2
	CALL	RETARDO
	GOTO	LOOP
	
	
	
RETARDO:
	;MOVLW	20	;~500uS
	;MOVLW	41	;~1mS
	;MOVLW	83	;~2mS
	MOVLW	208	;~5mS
RET:			;ciclos cuando no hace salto
			;|          ciclos cuando hace un salto
			;|          |  ciclos para guardar valor en WREG y RETURN
			;|________  |  | 
	DECFSZ	WREG,F 	;3*(WREG-1)+2 +3=ciclos
	GOTO	RET
	RETURN
	

	