/*_____________________________________________________________________________________________________________________

        Assignment: Assignment 2 (Electronic Keyboard)      
        Module:         
        Author:     Jacob Lannen    
        Date:       14/04/2014    

        Description:
        This program will use the provided peripherals (LEDs, push buttons, etc) 
		to create a simple electronic keyboard, playing 12 notes 

        Notes:          

        Revisions:

_____________________________________________________________________________________________________________________*/
#include <compiler_defs.h>
#include <C8051F120_defs.h>     // SFR declarations
#include "Assign2.h"


/*--------------------------------------------------------------------------------------------------------------------
        Function:         Main

        Description:      Main routine

        Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void main(void)
{
	General_Init();
	Timer_Init();
  	Voltage_Reference_Init();
	DAC_Init();
  	Interrupts_Init();
	LD1 = 1;

	sine[]={128, 131, 134, 137, 140, 143, 146, 149, 152, 155, 158, 162, 165, 167, 170, 173, 176, 179, 182, 185, 188, 190, 193,\
	196, 198, 201, 203, 206, 208, 211, 213, 215, 218, 220, 222, 224, 226, 228, 230, 232, 234, 235, 237, 238, 240, 241,\
	243, 244, 245, 246, 248, 249, 250, 250, 251, 252, 253, 253, 254, 254, 254, 255, 255, 255, 255, 255, 255, 255, 254,\
	254, 254, 253, 253, 252, 251, 250, 250, 249, 248, 246, 245, 244, 243, 241, 240, 238, 237, 235, 234, 232, 230, 228,\
	226, 224, 222, 220, 218, 215, 213, 211, 208, 206, 203, 201, 198, 196, 193, 190, 188, 185, 182, 179, 176, 173, 170,\
	167, 165, 162, 158, 155, 152, 149, 146, 143, 140, 137, 134, 131, 128, 124, 121, 118, 115, 112, 109, 106, 103, 100,\
	97, 93, 90, 88, 85, 82, 79, 76, 73, 70, 67, 65, 62, 59, 57, 54, 52, 49, 47, 44, 42, 40, 37, 35, 33, 31, 29, 27, 25,\
	23, 21, 20, 18, 17, 15, 14, 12, 11, 10, 9, 7, 6, 5, 5, 4, 3, 2, 2, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3,\
	4, 5, 5, 6, 7, 9, 10, 11, 12, 14, 15, 17, 18, 20, 21, 23, 25, 27, 29, 31, 33, 35, 37, 40, 42, 44, 47, 49, 52, 54,\
	57, 59, 62, 65, 67, 70, 73, 76, 79, 82, 85, 88, 90, 93, 97, 100, 103, 106, 109, 112, 115, 118, 121, 124};


	while(1)
	{	
		// Do stuff here ??

		// Try this code out to test the pushbuttons and LEDs as defined in Assign2.h
	/*	LD1 = ~PB1;	// Note the ~ means "complement"
		LD2 = ~PB2;
		LD3 = ~PB3;
		LD4 = ~PB4;
		LD5 = ~PB5;
		LD6 = ~PB6;
		LD7 = ~PB7;

		if ((~MPB) || (~PB8))  // What does this do.....Note that MPB is the P3.7 push button on the 8051 board
			LD8 = 1;
		else 
			LD8 = 0;
	*/
		TR2 = 1;
	}
}

/*--------------------------------------------------------------------------------------------------------------------
        Function:         General_Init

        Description:      Initialise ports, watchdog....

        Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void General_Init()
{
	WDTCN = 0xde;
	WDTCN = 0xad;
  	SFRPAGE = CONFIG_PAGE;
	P0MDOUT = 0x00;
	P1MDOUT = 0x00;
	P2MDOUT = 0xff;		// Need to make pushpull outputs to drive LEDs properly
	P3MDOUT = 0xff;	

	XBR2 = 0x40;
}

/*--------------------------------------------------------------------------------------------------------------------
        Function:         Timer_Init

        Description:      Initialise timer ports and registers

        Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void Timer_Init()
{
    SFRPAGE   = TMR2_PAGE;
    TMR2CN    = 0x04;
    TMR2CF    = 0x0A;
    RCAP2L    = 0xFF;
    RCAP2H    = 0xFF;
}

/*--------------------------------------------------------------------------------------------------------------------
        Function:         Voltage_Reference_Init

        Description:      Initialise voltage references (Needed for DAC)

        Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void Voltage_Reference_Init()
{
	SFRPAGE   = ADC0_PAGE;
  	REF0CN    = 0x03; // Turn on internal bandgap reference and output buffer to get 2.4V reference (pg 107)
}

/*--------------------------------------------------------------------------------------------------------------------
        Function:         DAC_Init

        Description:      Initialise DAC0. 

        Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void DAC_Init()
{
    SFRPAGE   = DAC0_PAGE;
    DAC0CN    = 0x84;
}

/*--------------------------------------------------------------------------------------------------------------------
        Function:         Interrupts_Init

        Description:      Initialise interrupts

        Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void Interrupts_Init()
{
	IE        = 0xA0;  // Global enable interrupt + timer 2 interrupt
}

/*--------------------------------------------------------------------------------------------------------------------
        Function:         Timer2_ISR

        Description:      

        Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void Timer2_ISR (void) interrupt 5
{
  	unsigned char SFRPAGE_SAVE = SFRPAGE;        // Save Current SFR page
  	DAC0= sine[phase];
	phase+= frequency;
	TF2 = 0;        // Reset Interrupt
  	SFRPAGE = SFRPAGE_SAVE; 							      // Restore SFR page
}



