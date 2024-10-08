;*********************************************************************
;Genera onda cuadrada de 38 kHz usando PWM

;DATOS****************************************************************
		__CONFIG _FOSC_HS & _WDTE_OFF & _PWRTE_ON & _BOREN_OFF & _CP_OFF 

		LIST P=16F877A
		INCLUDE <P16F77.INC>
		
		CBLOCK 0x20					; RAM para el usuario
			Lectura
		ENDC

;CODIGO****************************************************************
			ORG		0					;Programa alojado en ROM
Inicio:		
			call	SeteaGPIO
			call	SeteaPWM

Main:		goto	Main

;SUBRUTINAS************************************************************
SeteaGPIO:	
			bsf		STATUS, RP0			; ir al Banco1
			clrf	TRISC				; puertoC como salida 00000000
			return
			
SeteaPWM:	
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
			
			bsf		T2CON, TMR2ON	;TurnON el Timer2
			
			bsf		CCP1CON, CCP1M3		;Habilitar
			bsf		CCP1CON, CCP1M2		;el
			bsf		CCP1CON, CCP1M1		;modo
			bsf		CCP1CON, CCP1M0		;PWM
			return
			
			END