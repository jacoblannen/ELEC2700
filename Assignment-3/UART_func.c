/*_____________________________________________________________________________________________________________________

        Project:		ELEC2700 Assignment 3 - Ultrasonic Radar        
        Author:         Jacob Lannen (#3162100)
        Date:           12/06/2014

        Description:
        This program  contains all the functions used to control the UART Serial I/O port on the C8051F120 Dev Kit
_______________________________________________________________________________________________________________________*/

#include "c8051F120.h"
#include "A3_XX.h"

/*----------FUNCTION DECLARATIONS----------*/
void UART_transmit(unsigned char);
void UART_transmit_str(unsigned char *dat);
unsigned char UART_recieve(void);

/*--------------------------------------------------------------------------------------------------------------------
        Function:         UART_Init
        Description:      Initialises UART0
--------------------------------------------------------------------------------------------------------------------*/
void UART_Init()
{
    SFRPAGE = UART0_PAGE;
    SCON0 = 0x52;			//Set UART mode (8-bit asynch, autostart)
}

/*--------------------------------------------------------------------------------------------------------------------
        Function:         UART_transmit
        Description:      transmit data to the UART
--------------------------------------------------------------------------------------------------------------------*/
void UART_transmit(unsigned char dat)
{
	while(!TI0);

	TI0 = 0;			//When transmission ends, load new data into SBUF0

	SBUF0 = dat;
}

/*--------------------------------------------------------------------------------------------------------------------
        Function:         UART_transmit_str
        Description:      transmit string to the UART
--------------------------------------------------------------------------------------------------------------------*/
void UART_transmit_str(unsigned char *dat)
{
	while(*dat)
	{
		UART_transmit(*dat++);		//Loop transmition of characters until end of string
	}
}

/*--------------------------------------------------------------------------------------------------------------------
        Function:         UART_recieve
        Description:      Recieve data from the UART
--------------------------------------------------------------------------------------------------------------------*/
unsigned char UART_recieve()
{
	while(!RI0);

	RI0 = 0;

	return(SBUF0);					//When receive flag set return SBUF0
}

