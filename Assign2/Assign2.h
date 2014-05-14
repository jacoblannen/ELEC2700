/*_____________________________________________________________________________________________________________________

Project:
Module:
Author:
Date:

Description:

Revisions:


_______________________________________________________________________________________________________________________*/

#ifndef Assign2_h
#define Assign2_h

//--------------------------------------------------------------------------------------------------------------------
// Definitions
//--------------------------------------------------------------------------------------------------------------------
#define C3 0xFD22
#define D3 0xFD70
#define E3 0xFDB7
#define F3 0xFDD9
#define G3 0xFE14
#define A3 0xFE4A
#define B3 0xFE7C
#define C3S 0xFD4A
#define D3S 0xFD98
#define F3S 0xFDF8
#define G3S 0xFE30
#define A3S 0xFE62

#define C4 0xFE90
#define D4 0xFEB8
#define E4 0xFEDC
#define F4 0xFEEC
#define G4 0xFF0A
#define A4 0xFF25
#define B4 0xFF3D
#define C4S 0xFEA4
#define D4S 0xFECA
#define F4S 0xFEFC
#define G4S 0xFF18
#define A4S 0xFF31

#define C5 0xFF48
#define D5 0xFF5C
#define E5 0xFF6E
#define F5 0xFF76
#define G5 0xFF85
#define A5 0xFF93
#define B5 0xFF9F
#define C5S 0xFF52
#define D5S 0xFF65
#define F5S 0xFF7E
#define G5S 0xFF8C
#define A5S 0xFF99

#define LCD P3
#define LCD_EN 0x40
#define LCD_RS 0x10

//--------------------------------------------------------------------------------------------------------------------
// Global Variables
//--------------------------------------------------------------------------------------------------------------------
sbit PB1 = P1 ^ 0; // Pushbutton PB1
sbit PB2 = P1 ^ 1; // Pushbutton PB2
sbit PB3 = P1 ^ 2; // Pushbutton PB3
sbit PB4 = P1 ^ 3; // Pushbuttom PB4
sbit PB5 = P1 ^ 4; // Pushbutton PB5
sbit PB6 = P1 ^ 5; // Pushbutton PB6
sbit PB7 = P1 ^ 6; // Pushbutton PB7
sbit PB8 = P1 ^ 7; // Pushbuttom PB8

sbit MPB = P3 ^ 7;	// Pushbuttom MPB on 8051 development board

sbit LD1 = P2 ^ 0; // LED LD1
sbit LD2 = P2 ^ 1; // LED LD2
sbit LD3 = P2 ^ 2; // LED LD3
sbit LD4 = P2 ^ 3; // LED LD4
sbit LD5 = P2 ^ 4; // LED LD5
sbit LD6 = P2 ^ 5; // LED LD6
sbit LD7 = P2 ^ 6; // LED LD7
sbit LD8 = P2 ^ 7; // LED LD8

unsigned char	phase = 0;
unsigned char	volume = 7;
unsigned char	octave = 4;
unsigned int	frequency;
bit	state = 1;



//--------------------------------------------------------------------------------------------------------------------
// Function prototypes
//--------------------------------------------------------------------------------------------------------------------
void main(void);
void General_Init(void);
void Timer_Init(void);
void Voltage_Reference_Init(void);
void DAC_Init(void);
void Interrupts_Init(void);
void LCD_Init(void);
void LCD_Reset(void);
void LCD_Com(char);
void LCD_Data(unsigned char);
void LCD_string(unsigned char*);
void LCD_clr(void);
void LCD_newline(void);
void delay_cycle(int);
void delay(int);
void volume_disp(void);
unsigned char get_sine(unsigned char);

#endif 
