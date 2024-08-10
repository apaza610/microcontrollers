/*
 * File:   newavr-main.c
 * Author: win
 *
 * Created on July 3, 2024, 12:41 PM
 */

#include <avr/io.h>
#include <util/delay.h>

#define F_CPU   1000000
#define BAUD 9600
#define BRC (F_CPU/16/BAUD - 1)

int main(void) {
    UBRR0H = BRC>>8;
    UBRR0L = BRC;
    
    while (1) {
        //sleep(2);
    }
}
