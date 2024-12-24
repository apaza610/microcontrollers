/*
 * File:   newmain.c
 * Author: win
 *
 * Created on October 19, 2024, 2:20 PM
 */

// CONFIG
#pragma config FOSC = XT        // Oscillator Selection bits (XT oscillator)
#pragma config WDTE = OFF       // Watchdog Timer (WDT disabled)
#pragma config PWRTE = ON       // Power-up Timer Enable bit (Power-up Timer is enabled)
#pragma config CP = OFF         // Code Protection bit (Code protection disabled)

#include <xc.h>
#include <pic16f84a.h>
#include <pic.h>
#include <stdint.h>
#include "comun.h"

void main(void) {
//    int8_t numero1 = 7;
//    int8_t numero2 = 128;
//    int8_t numero3;
    
    //int * puntero;
    //puntero = &numero3;  
    //int *ptr = (int *)malloc(2 * sizeof(int));
    
    TRISA = 0;              //salidas
    TRISB = 255;            //entradas
    //TRISAbits.TRISA4 = 1;   //entrada
//    TRISAbits.TRISA2 = 0;
//    TRISBbits.TRISB4 = 1;
    
    //numero3 = suma(numero1, numero2);
    OPTION_REGbits.nRBPU = 0;
    
    asm("nop");
    while(1){
        //asm("xorwf    PORTA, f");
        //PORTB ^= 255;
//        PORTAbits.RA2 = PORTBbits.RB4;
        //PORTA = PORTB;
//        PORTB = numero3;
//        PORTB = puntero;
        asm("nop");
        asm("nop");
    }
            
    return;
}
