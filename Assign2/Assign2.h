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
//                              Definitions
//--------------------------------------------------------------------------------------------------------------------
#define C4 262
#define D4 294
#define E4 330
#define F4 349
#define G4 392
#define A4 440
#define B4 494
#define C4S 277
#define D4S 311
#define F4S 370
#define G4S 415
#define A4S 466


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

sbit MPB = P3 ^ 7;													 // Pushbuttom MPB on 8051 development board

sbit LD1 = P2 ^ 0;                         // LED LD1   
sbit LD2 = P2 ^ 1;                         // LED LD2
sbit LD3 = P2 ^ 2;                         // LED LD3
sbit LD4 = P2 ^ 3;                         // LED LD4  
sbit LD5 = P2 ^ 4;                         // LED LD5   
sbit LD6 = P2 ^ 5;                         // LED LD6
sbit LD7 = P2 ^ 6;                         // LED LD7
sbit LD8 = P2 ^ 7;                         // LED LD8    

unsigned char	phase;
unsigned int	frequency;
bit rising = 1;
bit positive = 1;
bit	state = 1;



//--------------------------------------------------------------------------------------------------------------------
//                              Function prototypes
//--------------------------------------------------------------------------------------------------------------------
void main(void);
void General_Init(void);
void Timer_Init(void);
void Voltage_Reference_Init(void);
void DAC_Init(void);
void Interrupts_Init(void);
unsigned char get_sine(unsigned char);

#endif    

             



