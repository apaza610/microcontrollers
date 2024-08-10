/*
 * File:   newmain1.c
 * Author: win
 *
 * Created on August 7, 2024, 9:08 PM
 */

#include <avr/io.h>

#define F_CPU   8000000UL
#define BAUD    9600
#define UBBRval (F_CPU/16UL/BAUD)-1 // vale 51

void USART_Inicia(void){
    UBRRH = (UBBRval >> 8);         // Set the baud rate
    UBRRL = UBBRval;
    
    UCSRB |= (1 << RXEN) | (1 << TXEN);                     // Habilitar transmisor y receptor
	UCSRC |= (1 << URSEL) | (1 << UCSZ1) | (1 << UCSZ0);    // Set frame format: 8data 1stopbit   
}

void USART_Transmite(unsigned char dato){
    while(!(UCSRA & (1<<UDRE)));    // Esperar por empty tramsmit buffer
    UDR = dato;                     // Poner dato en buffer (envio automatico)
}

void USART_TranString(const char* str){
    while(*str){
        USART_Transmite(*str++);
    }
}

unsigned char USART_Recive(void){
    while(!(UCSRA & (1<<RXC)));     // Esperar por dato a ser recivido
    return UDR;                     // get and return received data from buffer
}

int main(void) {
    unsigned char valor_recibido;
    unsigned char valor_aumentao;
    
    USART_Inicia();
    USART_TranString("Comenzando el programa!\r\n");
    while (1) {
        valor_recibido = USART_Recive();
        valor_aumentao = valor_recibido + 1;
        USART_Transmite(valor_aumentao);
    }
    return 0;
}
