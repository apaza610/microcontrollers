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
			registro1
			registro2
			registro3
			registro4
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
			call	InicializarPWM
			call	InicializarPORTC
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

InicializarPORTC:
			bsf		STATUS, RP0			; ir al Banco1
			clrf	TRISC				; puertoC como salida 00000000
			return
			
InicializarPWM:
			banksel	PR2					;configurar
			movlw	d'25'				;periodo
			movwf	PR2					;

			banksel	CCPR1L			;configurar
			movlw	b'00001101'		;DutyCycle
			movwf	CCPR1L			;usando
			bcf		CCP1CON, CCP1X	;de
			bcf		CCP1CON, CCP1Y	;resolucion
			
			bcf		T2CON, T2CKPS1		;eligiendo
			bcf		T2CON, T2CKPS0		;prescaler
			
			;bsf		T2CON, TMR2ON	;TurnON el Timer2
			
			bsf		CCP1CON, CCP1M3		;Habilitar
			bsf		CCP1CON, CCP1M2		;el
			bsf		CCP1CON, CCP1M1		;modo
			bsf		CCP1CON, CCP1M0		;PWM
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

Onda:
			banksel	PORTA
			SETF	PORTA				;poner pin en alto
			bsf		T2CON, TMR2ON		;TurnON el Timer2
			call	SetearTMR0burst		;esperar tantos segundos
			banksel	PORTA
			clrf	PORTA				;poner pin en bajo
			bcf		T2CON, TMR2ON		;TurnOFF el Timer2
			call	SetearTMR0space		;esperar tantos segundos
			return
			
Retardo:	bsf		PORTC, RC3
			movlw	d'254'
			movwf	registro1
Retardo1	call	Retardo2
			incf	registro1, f
			btfss	STATUS, Z
			goto	Retardo1
			nop
			return

Retardo2:	call	Retardo3
			incf	registro2, f
			btfss	STATUS, Z
			goto	Retardo2
			return
			
Retardo3:	call	Retardo4
			incf	registro3, f
			btfss	STATUS, Z
			goto	Retardo3
			return
			
Retardo4:	incf	registro4, f
			btfss	STATUS, Z
			goto	Retardo4
			bcf		PORTC, RC3
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
			SetearTmps	d'115', d'185', Onda	;INICIO burst 9000us space 4500us
			
			SetearTmps	d'247', d'247', Onda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'247', Onda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'229', Onda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'247', Onda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'247', Onda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'247', Onda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'247', Onda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'247', Onda	;ZERO   burst 562us space 562us
			
			SetearTmps	d'247', d'229', Onda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'229', Onda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'247', Onda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'229', Onda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'229', Onda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'229', Onda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'229', Onda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'229', Onda	;UNO   	burst 562us space 1687us
			
			SetearTmps	d'247', d'247', Onda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'247', Onda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'247', Onda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'229', Onda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'247', Onda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'247', Onda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'247', Onda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'247', Onda	;ZERO   burst 562us space 562us
			
			SetearTmps	d'247', d'229', Onda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'229', Onda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'229', Onda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'247', Onda	;ZERO   burst 562us space 562us
			SetearTmps	d'247', d'229', Onda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'229', Onda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'229', Onda	;UNO   	burst 562us space 1687us
			SetearTmps	d'247', d'229', Onda	;UNO   	burst 562us space 1687us
			
			SetearTmps	d'248', d'0', Onda		;PARADA burst 562us space 562us
			call	Retardo
			return
			
Interrupcion_RBI:			
			nop			
			return
			
Interrupcion_T0I:
			nop
			return
			
			END