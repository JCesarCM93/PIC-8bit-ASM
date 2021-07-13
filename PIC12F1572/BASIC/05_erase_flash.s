; Archivo:  05_erase_flash.s
; Micro:    PIC12F1572
; Autor:    Julio Mendoza
; Fecha:    2021-Julio
; Comp:	    pic-as(v2.32)

;-------------------------------------------------------------------------------
; Descripción
;	Ejemplo 5, borra la memoria después de la dirección 0x20
;------------------------------------------------------------------------------- 
#include <xc.inc>
NOP_4 MACRO
    NOP
    NOP
    NOP
    NOP 
ENDM
NOP_16 MACRO
    NOP_4
    NOP_4
    NOP_4
    NOP_4 ENDM
NOP_64 MACRO
    NOP_16
    NOP_16
    NOP_16
    NOP_16 ENDM
NOP_256 MACRO
    NOP_64
    NOP_64
    NOP_64
    NOP_64 ENDM
NOP_1K MACRO
    NOP_256
    NOP_256
    NOP_256
    NOP_256 ENDM
;-------------------------------------------------------------------------------
; Seccion de FUSES
;------------------------------------------------------------------------------- 
config FOSC = INTOSC	; oscilador interno
config WDTE = OFF	; WDT deshabilitado 
config MCLRE = ON	; MCLR habilitado, A3 como reset
config LVP = ON		; LVP habilitado
config PLLEN = ON 	; habilita 4x PLL 

;-------------------------------------------------------------------------------
; Código principal
;------------------------------------------------------------------------------- 	
REG0 EQU 0x70
 
PSECT   start,class=ACODE,delta=2    
	CALL	ERASE	;llama a rutina de borrado
	GOTO	$-0	;loop infinito
	
	
;-------------------------------------------------------------------------------
; Rutina para borrar la memoria
;------------------------------------------------------------------------------- 
ERASE:
	BANKSEL	PMADRL	;selecciona banco
	MOVLW	0X02
	MOVWF	REG0
	
LOOP_ERASE:
	SWAPF	REG0,W	;swap al registro del address
	MOVWF	PMADRL	;dirección baja
	MOVWF	PMADRH	;dirección alta
	BCF	PMCON1,6;
	BSF	PMCON1,4;especifica una operación de borrado
	BSF	PMCON1,2;habilita escritura
	MOVLW	0x55
	MOVWF	PMCON2	;inicia secuencia requerida para borrado
	MOVLW	0xAA
	MOVWF	PMCON2	
	BSF	PMCON1,1;setea WR para borrar
	NOP
	NOP
	INCF	REG0,F	;incrementa el registro 
	BTFSS	REG0,7	;pregunta si es mayor a 0x7F
	GOTO	LOOP_ERASE
	BCF	PMCON1,2
	RETURN
	NOP_1K
	NOP_1K