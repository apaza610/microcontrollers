# 1 "principal.asm"
# 1 "<built-in>" 1
# 1 "principal.asm" 2
;ZONA DE DATOS******************************************************************
; __CONFIG _CP_OFF & _WDT_OFF & _PWRTE_ON & _XT_OSC

    LIST P=16F877 ;Procesador
    #INCLUDE "P16F877.INC" ;Definicion de operandos usados


;ZONA DE CODIGO*****************************************************************
 ORG 0 ;Programa empieza en memory address 0

Inicio bsf STATUS, RP0
 clrf TRISB
 movlw b'11111111'
 movwf TRISA
 bcf STATUS,RP0
Principal
 movf PORTA,W ;leer el PuertoA
 movwf PORTB ;write al PuertoB
 goto Principal ;bucle infinito

 END
