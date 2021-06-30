; Archivo:  02_delay_M_500kHz.s
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
REG1 EQU 0x20	

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
	;~5ms
;	MOVLW	1
;	MOVWF	REG1
;	MOVLW	206
	;~10ms
;	MOVLW	2
;	MOVWF	REG1
;	MOVLW	
	;~20ms
;	MOVLW	4
;	MOVWF	REG1
;	MOVLW	61
	;~50ms
;	MOVLW	9
;	MOVWF	REG1
;	MOVLW	28
	;~100ms
;	MOVLW	17
;	MOVWF	REG1
;	MOVLW	58
	;~200ms
;	MOVLW	33
;	MOVWF	REG1
;	MOVLW	118
	;~500ms
;	MOVLW	82
;	MOVWF	REG1
;	MOVLW	41
	;~1s
	MOVLW	163
	MOVWF	REG1
	MOVLW	85
RET:	
; ciclos cuando no hace salto con WREG
; |          ciclos cuando hace un salto con WREG
; |          |   ciclos cuando no hace salto con REG1			
; |          |   |          ciclos cuando hace un salto con REG1   
; |          |   |          |   ciclos que REG1 hace repetir el decremento de WREG
; |          |   |	    |   |	      ciclos para guardar valor en WREG, REG1 y RETURN
; |________  |   |__________|	|___________  |
;(3*(WREG-1)+2)+(3*(REG1-1)+2)+(767*(REG1-1))+5=ciclos
	DECFSZ	WREG,F
	GOTO	RET	
	DECFSZ	REG1,F	
	GOTO	RET	
	RETURN