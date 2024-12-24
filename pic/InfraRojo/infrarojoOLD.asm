;*********************************************************************
;DATOS****************************************************************
		__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_ON & _XT_OSC

		LIST P=16F877A
		INCLUDE <P16F77.INC>
		
		CBLOCK 0x20					; RAM para el usuario
			Guarda_W
			Guarda_STATUS
			tiempoBurst
			tiempoSpace
		ENDC

;CODIGO****************************************************************
			INCLUDE <macrosapz.inc>
			ORG		0					; Programa alojado en ROM
			goto	Inicio
			ORG		4
			goto	SrvInterup
			
Inicio:		
			call	InicializarPORTA			; PortA como salidas
			call	InicializarPORTB			; PORTB como entradas
			call	InicializarTMR0
			bcf		STATUS, RP0

BucleInf:	nop
			goto	BucleInf
						
;SUBRUTINAS************************************************************
InicializarTMR0:	
			banksel	OPTION_REG
			movlw	b'00000101'			;Prescaler
			movwf	OPTION_REG
			bsf		OPTION_REG, T0CS	;Pausa timer0
			return
			
InicializarPORTA:
			banksel	ADCON1		; TurnOff
			movlw	0x06		; ADC
			movwf	ADCON1		; 
			
			banksel	TRISA
			clrf	TRISA
			banksel	PORTA
			clrf	PORTA
			return
			
InicializarPORTB:
			SETF	TRISB
			banksel	OPTION_REG
			bcf		OPTION_REG, NOT_RBPU
			bcf		OPTION_REG, INTEDG
			movlw	b'10010000'	; Enable interrupcion
			movwf	INTCON
			return

SetearTMR0burst:
			banksel	TMR0
			movfw	tiempoBurst
			movwf	TMR0
			banksel	OPTION_REG
			bcf		OPTION_REG, T0CS	;Play timer0
BucleBurst:	btfss	INTCON, T0IF
			goto	BucleBurst
			bcf		INTCON, T0IF
			return
			
SetearTMR0space:
			banksel	TMR0
			movfw	tiempoSpace
			movwf	TMR0
			banksel	OPTION_REG
			bcf		OPTION_REG, T0CS	;Play timer0
			banksel	INTCON
BucleSpace:	btfss	INTCON, T0IF
			goto	BucleSpace
			bcf		INTCON, T0IF
			return

CrearOnda:
			banksel	PORTA
			SETF	PORTA				;poner pin en alto
			call	SetearTMR0burst		;esperar tantos segundos
			banksel	PORTA
			clrf	PORTA				;poner pin en bajo
			call	SetearTMR0space		;esperar tantos segundos
			return
			
;SERVICIO INTERRUPCION*************************************************
SrvInterup:	
			movwf	Guarda_W			;Guardar W y STATUS
			swapf	STATUS, W			;para que esten
			movwf	Guarda_STATUS		;inalterados
			bcf		STATUS, RP0			;al volver
			
			btfsc	INTCON, INTF			;Determinar
			call	Interrupcion_INT		;la
			btfsc	INTCON, RBIF			;causa
			call	Interrupcion_RBI		;de
			btfsc	INTCON, T0IF			;la
			call	Interrupcion_T0I		;interrupcion
			
			swapf	Guarda_STATUS, W	;restaurar contenido
			movwf	STATUS				;de registros
			swapf	Guarda_W, F			;antes de
			swapf	Guarda_W, W			;volver
			
			bcf		INTCON, INTF			;Borrar flags
			movf	PORTB, F				;causantes
			bcf		INTCON, RBIF			;de las
			bcf		INTCON, T0IF			;interrupciones
			banksel	OPTION_REG
			bsf		OPTION_REG, T0CS		;Pausa timer0
			retfie							;Regresa y reHabilita interrupcion
			
Interrupcion_INT:		;20DF10EF   00100000 11011111   00010000 11101111
			SetearTmps	d'115', d'185', CrearOnda	;INICIO burst 9000us space 4500us
			
			SetearTmps	d'247', d'247', CrearOnda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'247', CrearOnda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'229', CrearOnda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'247', CrearOnda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'247', CrearOnda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'247', CrearOnda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'247', CrearOnda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'247', CrearOnda	;ZERO   burst 562us space 562us
			
			SetearTmps	d'247', d'229', CrearOnda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'229', CrearOnda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'247', CrearOnda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'229', CrearOnda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'229', CrearOnda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'229', CrearOnda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'229', CrearOnda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'229', CrearOnda	;UNO   	burst 562us space 1687us
			
			SetearTmps	d'247', d'247', CrearOnda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'247', CrearOnda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'247', CrearOnda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'229', CrearOnda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'247', CrearOnda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'247', CrearOnda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'247', CrearOnda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'247', CrearOnda	;ZERO   burst 562us space 562us
			
			SetearTmps	d'247', d'229', CrearOnda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'229', CrearOnda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'229', CrearOnda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'247', CrearOnda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'229', CrearOnda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'229', CrearOnda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'229', CrearOnda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'229', CrearOnda	;UNO   	burst 562us space 1687us
			
			SetearTmps	d'247', d'0', CrearOnda		;PARADA burst 562us space 562us
			return
			
Interrupcion_RBI:			
			nop			
			return
			
Interrupcion_T0I:
			nop
			return
			
			END