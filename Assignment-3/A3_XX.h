/*_____________________________________________________________________________________________________________________

        Project: 		ELEC2700 Assignment 3 - Ultrasonic Radar
        Author:         Jacob Lannen (#3162100)
        Date:           21/05/2014

        Description:
        This program is used as the main header file for the A3_XX.c file, containing the global variables used

        Revisions:
		Changed definitions of LCD variables to allow integration of previously used LCD functions

_______________________________________________________________________________________________________________________*/

#ifndef A3_XX_h
#define A3_XX_h

//--------------------------------------------------------------------------------------------------------------------
//                              Global Variables
//--------------------------------------------------------------------------------------------------------------------
sbit PB1 = P1 ^ 0;                           // Pushbutton PB1
sbit PB2 = P1 ^ 1;                           // Pushbutton PB2
sbit PB3 = P1 ^ 2;                           // Pushbutton PB3   
sbit PB4 = P1 ^ 3;                           // Pushbuttom PB4
sbit PB5 = P1 ^ 4;                           // Pushbutton PB5
sbit PB6 = P1 ^ 5;                           // Pushbutton PB6
sbit PB7 = P1 ^ 6;                           // Pushbutton PB7   
sbit PB8 = P1 ^ 7;                           // Pushbuttom PB8

sbit SMODE = P3 ^ 7;												// Pushbutton on F120 development board

sbit LD1 = P2 ^ 0;                         // LD0   
sbit LD2 = P2 ^ 1;                         // LD1
sbit LD3 = P2 ^ 2;                         // LD2
sbit LD4 = P2 ^ 3;                         // LD3  
sbit LD5 = P2 ^ 4;                         // LD4   
sbit LD6 = P2 ^ 5;                         // LD5
sbit LD7 = P2 ^ 6;                         // LD6
sbit LD8 = P2 ^ 7;                         // LD7    


#define LCD P3
#define LCD_EN 0x40
#define LCD_RS 0x10


sbit USonicTX		= P0 ^ 2;											// TX for ultrasonic
sbit USonicRX		= P0 ^ 3;											// RX 
sbit Servo_Ctrl = P0 ^ 4;											// Servo control pin


//--------------------------------------------------------------------------------------------------------------------
//                              Function prototypes
//--------------------------------------------------------------------------------------------------------------------
void main(void);
void General_Init(void);
void Timer_Init();
void Interrupts_Init();
void External_INT0_ISR(void);

void LCD_Init(void);
void LCD_Reset(void);
void LCD_Com(char);
void LCD_Data(unsigned char);
void LCD_string(unsigned char*);
void LCD_clr(void);
void LCD_newline(void);
void delay_milsec(int);
void delay_usec(int);
void Delay(int);

#endif  

             



