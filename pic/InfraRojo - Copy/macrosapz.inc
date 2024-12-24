;****************Libreria MACROS.INC****************************
SetearTmps	MACRO	tiempoUNO, tiempoDOS, CrearOnda
		bcf		STATUS, RP0
		movlw	tiempoUNO
		movwf	tiempoBurst
		movlw	tiempoDOS
		movwf	tiempoSpace
		call	CrearOnda
		;goto	destino
ENDM

SETF	MACRO	registro
		movlw	0xFF
		movwf	registro
ENDM