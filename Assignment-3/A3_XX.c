/*_____________________________________________________________________________________________________________________

        Project:        ELEC2700 Assignment 3 - Ultrasonic Radar
        Author:         Jacob Lannen (#3162100)
        Date:           28/05/2014

        Description:
        This program ....

        Notes:          

        Revisions:


_______________________________________________________________________________________________________________________*/

#include <c8051f120.h>     // SFR declarations
#include "A3_XX.h"


int servopos;							// Servo position (30-120)


/*--------------------------------------------------------------------------------------------------------------------
        Function:         Main

        Description:      Main routine

        Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void main(void)
{
  	SFRPAGE   = CONFIG_PAGE;
  	OSCICN    = 0x83;					// Need a faster clock....24.5MHz selected
	General_Init();
	Timer_Init();
	LCD_Init();	
	Interrupts_Init();
	LCD_string("Radar Test");

	while(1)
	{	
		for(servopos = 30; servopos<120; servopos++)
		{		
			Servo_Ctrl = 1;
			delay_usec(servopos);
			Servo_Ctrl = 0;
			delay_milsec(20);
			delay_milsec(10);
		}

		for(servopos = 120; servopos>30; servopos--)
		{		
			Servo_Ctrl = 1;
			delay_usec(servopos);
			Servo_Ctrl = 0;
			delay_milsec(20);
			delay_milsec(10);
		}
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
	P0MDOUT = 0x10;		// NOTE: Pushpull required for Servo control OTHERWISE TOO WEAK TO DRIVE PROPERLY SINCE ONLY 3.3V!!!!
	P1MDOUT = 0x00;		// Ensure not pushpull outputs....this could damage microcontroller...
	P2MDOUT = 0xff;		// Need to make pushpull outputs to drive LEDs properly
	P3MDOUT = 0xff;
	XBR2 = 0x40;
	Servo_Ctrl = 0;	// Initialise servo control pin to 0
}

/*--------------------------------------------------------------------------------------------------------------------
        Function:         Timer_Init

        Description:      

        Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void Timer_Init()
{
	SFRPAGE = TMR2_PAGE;
	//TMR2CN = 0x04;
	//TMR2CF = 0x02;
}

/*--------------------------------------------------------------------------------------------------------------------
        Function:         Interrupts_Init

        Description:      Initialise interrupts

        Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void Interrupts_Init()
{
	IE = 0xA0;
}

/*--------------------------------------------------------------------------------------------------------------------
        Function:         Timer2_ISR

        Description:      Timer 2 interrupt service routine

        Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void Timer2_ISR (void) interrupt 5
{
  unsigned char SFRPAGE_SAVE = SFRPAGE;        // Save Current SFR page
	
	// Do stuff here...

	
	TF2 = 0;        														// Reset interrupt flag
  	SFRPAGE = SFRPAGE_SAVE; 							      // Restore SFR page
}




