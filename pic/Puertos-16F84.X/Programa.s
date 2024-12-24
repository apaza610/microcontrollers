  CONFIG  FOSC = XT             ; Oscillator Selection bits (XT oscillator)
  CONFIG  WDTE = OFF            ; Watchdog Timer (WDT disabled)
  CONFIG  PWRTE = ON            ; Power-up Timer Enable bit (Power-up Timer is enabled)
  CONFIG  CP = OFF              ; Code Protection bit (Code protection disabled)

// config statements should precede project file includes.
#include <xc.inc>
	PSECT MyCode,class=CODE,delta=2  
	
MyCode:	    
	    banksel TRISA
	    clrf    TRISB	    ;Son salidas
	    movlw   0FFh
	    movwf   TRISA	    ;Son entradas
	    
	    banksel PORTA
	    clrf    PORTB
Main:	    	    
	    xorwf    PORTB, f
	    goto    Main
	    END

