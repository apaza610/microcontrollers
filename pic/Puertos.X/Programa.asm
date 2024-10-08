		;__CONFIG    _CP_OFF & _WDT_OFF & _PWRTE_ON & _XT_OSC		; Configuracion Fuses
		
PROCESSOR   12F675

		; CONFIG
		CONFIG  FOSC = INTRCCLK       ; Oscillator Selection bits (INTOSC oscillator: CLKOUT function on GP4/OSC2/CLKOUT pin, I/O function on GP5/OSC1/CLKIN)
		CONFIG  WDTE = OFF            ; Watchdog Timer Enable bit (WDT disabled)
		CONFIG  PWRTE = ON            ; Power-Up Timer Enable bit (PWRT enabled)
		CONFIG  MCLRE = OFF           ; GP3/MCLR pin function select (GP3/MCLR pin function is digital I/O, MCLR internally tied to VDD)
		CONFIG  BOREN = OFF           ; Brown-out Detect Enable bit (BOD disabled)
		CONFIG  CP = OFF              ; Code Protection bit (Program Memory code protection is disabled)
		CONFIG  CPD = OFF             ; Data Code Protection bit (Data memory code protection is disabled)
		
#include <xc.inc>
		
		ORG	0
		movlw	255
		END


