/*
 * File:   principal.c
 * Author: win
 *
 * Created on July 1, 2024, 8:13 PM
 */

// CONFIG
#pragma config FOSC = XT        // Oscillator Selection bits (XT oscillator)
#pragma config WDTE = OFF       // Watchdog Timer Enable bit (WDT disabled)
#pragma config PWRTE = OFF      // Power-up Timer Enable bit (PWRT disabled)
#pragma config BOREN = ON       // Brown-out Reset Enable bit (BOR enabled)
#pragma config LVP = ON         // Low-Voltage (Single-Supply) In-Circuit Serial Programming Enable bit (RB3/PGM pin has PGM function; low-voltage programming enabled)
#pragma config CPD = OFF        // Data EEPROM Memory Code Protection bit (Data EEPROM code protection off)
#pragma config WRT = OFF        // Flash Program Memory Write Enable bits (Write protection off; all program memory may be written to by EECON control)
#pragma config CP = OFF         // Flash Program Memory Code Protection bit (Code protection off)

// #pragma config statements should precede project file includes.
// Use project enums instead of #define for ON and OFF.

#include <xc.h>
#define _XTAL_FREQ 10000000 //para poder usar _delay_ms()

void main(void) {
    ADCON1 = 0b00000110; //que todo el puerto sea digital
    TRISA = 0b11111111; //como entradas
    
    TRISB = 0b00000000; //como salidas
    PORTB = 0b00000000;
    

    while(1){
        if(PORTAbits.RA0 == 1){
            __delay_ms(20); //debounce
            if(PORTAbits.RA0 == 1){
                PORTB = 0b00001111;
            }
        }
        else{
            PORTB = 0b11110000;
        }
    }
    return;
}
