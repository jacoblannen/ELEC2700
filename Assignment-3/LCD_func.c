/*_____________________________________________________________________________________________________________________

        Project:		ELEC2700 Assignment 3 - Ultrasonic Radar        
        Author:         Jacob Lannen (#3162100)
        Date:           21/05/2014

        Description:
        This program acts as a header file to the main A3_XX.c and contains all the functions used to
		control the LCD display on the NH10020 Peripheral Interface Board

        Revisions:
		N/A

_______________________________________________________________________________________________________________________*/

#include "c8051F120.h"
#include "A3_XX.h"

/*----------FUNCTION DECLARATIONS----------*/
void LCD_Init(void);
void LCD_Reset(void);
void LCD_Com(char);
void LCD_Data(unsigned char);
void LCD_string(unsigned char*);
void LCD_clr(void);
void LCD_newline(void);
void delay_milsec(int);
void delay_usec(int);


/*--------------------------------------------------------------------------------------------------------------------
	Function: 		LCD_Reset

	Description: 	Reset LCD for use in initialisation

	Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void LCD_Reset()
{
	LCD = 0xFF;
	delay_milsec(50);
	LCD = 0x83+LCD_EN;
	LCD = 0x83;
	delay_milsec(5);
	LCD = 0x83+LCD_EN;
	LCD = 0x83;
	delay_milsec(1);
	LCD = 0x83+LCD_EN;
	LCD = 0x83;
	delay_milsec(1);
	LCD = 0x82+LCD_EN;
	LCD = 0x82;
	delay_milsec(100);
}

/*--------------------------------------------------------------------------------------------------------------------
	Function: 		LCD_Init

	Description: 	Initialise LCD

	Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void LCD_Init()
{
	LCD_Reset();		//Run LCD reset routine
	LCD_Com(0x28);		//Set LCD format: 4-bit input, 2 line, 5x7 font
	LCD_Com(0x0C);		//Turn display on
	LCD_Com(0x01);
	LCD_Com(0x06);		//Set input mode: auto increment, no shift
	LCD_Com(0x80);		//Reset cursor position
}

/*--------------------------------------------------------------------------------------------------------------------
	Function: 		LCD_Com

	Description: 	sends commands to the LCD

	Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void LCD_Com(char cmd)
{
	LCD=((cmd >> 4) & 0x0F)|LCD_EN|0x80;	//Bitmask upper nibble of command byte and send it to LCD
	LCD=((cmd >> 4) & 0x0F)|0x80;			//Toggle enable

	LCD=(cmd & 0x0F)|LCD_EN|0x80;			//Send lower nibble to LCD
	LCD=(cmd & 0x0F)|0x80;					//Toggle enable
	
	delay_milsec(100);
}

/*--------------------------------------------------------------------------------------------------------------------
	Function: 		LCD_Data

	Description: 	sends data to the LCD

	Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void LCD_Data(unsigned char dat)
{
	LCD=(((dat >> 4) & 0x0F)|LCD_EN|LCD_RS|0x80);	//Same as LCD_cmd, but LCD_RS is enables to show that data is being received rather than commands
	LCD=(((dat >> 4) & 0x0F)|LCD_RS|0x80);

	LCD=((dat & 0x0F)|LCD_EN|LCD_RS|0x80);
	LCD=((dat & 0x0F)|LCD_RS|0x80);
	
	delay_milsec(100);
}

/*--------------------------------------------------------------------------------------------------------------------
	Function: 		LCD_string

	Description: 	receives a string and loops LCD_Data until end of string

	Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void LCD_string(unsigned char *str)
{
	while(*str)		//Loop til end of string
	{
		LCD_Data(*str++);
	}
	delay_milsec(100);
}

/*--------------------------------------------------------------------------------------------------------------------
	Function: 		LCD_clr

	Description: 	Clear LCD display and reset cursor

	Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void LCD_clr()
{
	LCD_Com(0x01);	//Clear LCD
	LCD_Com(0x02);	//Reset cursor
}

/*--------------------------------------------------------------------------------------------------------------------
	Function: 		LCD_newline

	Description: 	Sets cursor to start on line 2

	Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void LCD_newline()
{
	LCD_Com(0xC0);
}

/*--------------------------------------------------------------------------------------------------------------------
	Function: 		Delay_msec and Delay_usec

	Description: 	functions to create a delay of an input number of milliseconds or microseconds

	Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void Delay_milsec(int milsec)
{
	int i, j;
	for(i=0; i<milsec; i++)
		for(j=0; j<2709; j++);
}

void Delay_usec(int usec)
{
	int k, l;
	for(k=0; k<usec; k++)
		for(l=0; l<20; l++);
}

