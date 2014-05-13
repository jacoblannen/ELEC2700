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
	phase = 0;

	while(state == 0)
	{
		TR2 = 1;
	}
	while(state == 1)
	{	
		TR2 = 1;
		P2=0;
		while(PB2==0)
		{
			LD2=1;
			if(PB1 == 1)
			{
				frequency = C4;
			}else{
				LD1=1;
				frequency = C4S;
			}
		}
		while(PB3==0)
		{
			LD3=1;
			if(PB1 == 1)
			{
				frequency = D4;
			}else{
				LD1=1;
				frequency = D4S;
			}
		}
		while(PB4==0)
		{
			LD4=1;
			if(PB1==0)
			{
				LD1=1;
			}
			frequency = E4;
		}
		while(PB5==0)
		{
			LD5=1;
			if(PB1 == 1)
			{
				frequency = F4;
			}else{
				LD1=1;
				frequency = F4S;
			}
		}
		while(PB6==0)
		{
			LD6=1;
			if(PB1 == 1)
			{
				frequency = G4;
			}else{
				LD1=1;
				frequency = G4S;
			}
		}
		while(PB7==0)
		{
			LD7=1;
			if(PB1 == 1)
			{
				frequency = A4;
			}else{
				LD1=1;
				frequency = A4S;
			}
		}
		while(PB8==0)
		{
			LD8=1;
			if(PB1==0)
			{
				LD1=1;
			}
			frequency = B4;		
		}
		frequency=0;

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
    RCAP2H    = 0xF9;
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
	unsigned char DAC_value;  
	unsigned char volume = 3;	

	

	DAC_value= get_sine(phase);
	DAC0H= DAC_value/volume;
	phase+= 150;//(frequency/2);
	if(CY==1)
	{
		if((positive == 1 && rising == 1) || (positive == 0 && rising == 0))
		{
			rising = ~rising;
		}else if((positive == 0 && rising == 1) || (positive == 1 && rising == 0))
		{
			positive = ~positive;
		}
	}

	TF2 = 0;        // Reset Interrupt
  	SFRPAGE = SFRPAGE_SAVE; 							      // Restore SFR page
}


unsigned char get_sine(unsigned char time){
	unsigned char index;
	unsigned char out;
	const unsigned char code sine[] = {0,1,2,2,3,4,5,5,6,7,8,9,9,10,11,12,12,13,14,15,16,16,17,18,19,19,20,21,22,23,23,24,25,26,26,27,28,29,29,30,31,32,32,33,34,35,36,36,37,38,39,39,40,41,41,42,43,44,44,45,46,47,47,48,49,50,50,51,52,52,53,54,55,55,56,57,57,58,59,59,60,61,61,62,63,64,64,65,66,66,67,68,68,69,70,70,71,71,72,73,73,74,75,75,76,77,77,78,78,79,80,80,81,81,82,83,83,84,84,85,86,86,87,87,88,88,89,90,90,91,91,92,92,93,93,94,94,95,96,96,97,97,98,98,99,99,100,100,101,101,101,102,102,103,103,104,104,105,105,106,106,106,107,107,108,108,109,109,109,110,110,111,111,111,112,112,112,113,113,114,114,114,115,115,115,116,116,116,117,117,117,117,118,118,118,119,119,119,120,120,120,120,121,121,121,121,122,122,122,122,122,123,123,123,123,123,124,124,124,124,124,125,125,125,125,125,125,125,126,126,126,126,126,126,126,126,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127};
	if(MPB==0)
	{
		state=~state;
	}

	if(rising==1 && positive==1)
	{
		index = time;
		out = 128 + sine[index];
	}else if(rising==0 && positive==1)
	{
		index = 255 - time;
		out = 128 + sine[index];
	}else if(rising==0 && positive==0)
	{
		index = time;
		out = 128 - sine[index];
	}else if(rising==1 && positive==0)
	{
		index = 255 - time;
		out = 128 - sine[index];
	}
		
	return(out);
}
