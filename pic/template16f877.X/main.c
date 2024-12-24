/* 
 * File:   main.c
 * Author: win
 * Software:  Turns ON and OFF a LED
 * Hadware: a LED connected to PIN B1
 * Created on October 31, 2024, 12:01 PM
 */

#include "PIC16F877A_External.h"

/* Function:    initMain() 
 * Returns: nothing
 * Description: inicializaciones para main()
 * Usage:   initMain()
 */
void initMain(){
    external_4MHz();
    
    //Setear puertos
    //TRISBbits.TRISB1 = 0;
    TRISB = 0;
    PORTB = 0;
}

int main(int argc, char** argv) {
    initMain();
    
    while(1){
        //toggle PIND1
        //delay 500 milliseconds
        //PORTBbits.RB1 = !PORTBbits.RB1;
        //__delay_ms(500);
        PORTB |= (1<<3);
        PORTB &= ~(1<<3);
        PORTB |= (1<<3);
        PORTB &= ~(1<<3);
        PORTB |= (1<<3);
        PORTB &= (0<<3);
        PORTB |= (1<<3);
        PORTB &= (0<<3);
        PORTB |= (1<<3);
        PORTB &= (0<<3);
    }

    return (EXIT_SUCCESS);
}

