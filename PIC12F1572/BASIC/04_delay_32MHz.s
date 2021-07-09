; Archivo:  04_delay_32MHz.s
; Micro:    PIC12F1572
; Autor:    Julio Mendoza
; Fecha:    2021-Julio
; Comp:	    pic-as(v2.32)

;-------------------------------------------------------------------------------
; Descripción
;	Ejemplo 4, encendido y apagado de un LED conectado en A2 con un periodo 
;	máximo de 5ms, con frecuencia interna de 32MHz:8MIPS
;------------------------------------------------------------------------------- 

#include <xc.inc>

;-------------------------------------------------------------------------------
; Seccion de FUSES
;------------------------------------------------------------------------------- 
config FOSC = INTOSC	; oscilador interno
config WDTE = OFF	; WDT deshabilitado 
config MCLRE = OFF	; MCLR deshabilitado, A3 como entrada
config LVP = OFF	; LVP deshabilitado
config PLLEN = ON 	; habilita 4x PLL 

;-------------------------------------------------------------------------------
; Código principal
;------------------------------------------------------------------------------- 
REG0 EQU 0x20	
REG1 EQU 0x21	

PSECT   start,class=ACODE,delta=2
	BANKSEL	OSCCON
	MOVLW	0x70
	MOVWF	OSCCON
	CLRF	OSCTUNE
    	CLRF	BORCON
PLL_OK:
    	BTFSS	OSCSTAT,6
    	GOTO	PLL_OK
    
    
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
	MOVLW	41
	MOVWF	REG1
	MOVLW	190
	MOVWF	REG0
	MOVLW	23
RET:	
;3*(WREG-1)+770*(REG0-1)+196355*(REG1-1)+13=ciclos
	DECFSZ	WREG,F  (2+(255*3))*255
	GOTO	RET	
	DECFSZ	REG0,F	2+255*3
	GOTO	RET	
	DECFSZ	REG1,F	
	GOTO	RET	
	RETURN