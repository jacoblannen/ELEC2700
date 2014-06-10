/*_____________________________________________________________________________________________________________________

        Project:        
        Module:         
        Author:         
        Date:           

        Description:
        This program ....

        Notes:          

        Revisions:


_______________________________________________________________________________________________________________________*/

#include <c8051f120.h>		// SFR declarations
#include <stdio.h>			// Include stdio for sprintf() to display distances
#include "A3_XX.h"


int servopos;				// Servo position (30-120)
int x;
char dist_str[16];			// String which displays the distance from the US sensor as calculated


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
	LCD_string("Ultrasonic Radar");
	LCD_newline();
	LCD_string("Distance: ");

	while(1)
	{	
		get_dist();
		LCD_string(dist_str);
		LCD_Com(0xCA);
/*
		for(servopos = 60; servopos<240; servopos++)
		{		
			Servo_Ctrl = 1;
			delay_usec(servopos);
			Servo_Ctrl = 0;
			delay_milsec(20);
			get_dist();
			LCD_Com(0xCA);
			LCD_string(dist_str);
		}

		for(servopos = 240; servopos>60; servopos--)
		{		
			Servo_Ctrl = 1;
			delay_usec(servopos);
			Servo_Ctrl = 0;
			delay_milsec(20);
			get_dist();
			LCD_Com(0xCA);
			LCD_string(dist_str);
		}
*/
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
	Servo_Ctrl = 0;		// Initialise servo control pin to 0
}

/*--------------------------------------------------------------------------------------------------------------------
        Function:         Timer_Init

        Description:      

        Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void Timer_Init()
{
	SFRPAGE = TMR2_PAGE;
	TMR2CF = 0x1A;
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
        Function:         get_dist

        Description:      Send a pulse from the US transducer, then, use the delay to calculate the distance of the object

        Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void get_dist()
{
	int timer, dist;	
	
	TMR2L = 0;
	TMR2H = 0;

	for(x = 0; x<8; x++)
	{
		USonicTX = ~USonicTX;
		delay_usec(1);
	}
	delay_usec(12);
	
	TMR2CN = 0x04;
	
	dist = (((timer*41)+150000)*(17/50000))/2;
	sprintf(dist_str, "%dmm", dist);	
}

/*--------------------------------------------------------------------------------------------------------------------
        Function:         Timer2_ISR

        Description:      Timer 2 interrupt service routine

        Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void Timer2_ISR (void) interrupt 5
{
  unsigned char SFRPAGE_SAVE = SFRPAGE;        // Save Current SFR page
	
	if(USonicRX == 1)
	{
		TMR2CN = 0x00;
		timer = TMR2H;
		timer = timer << 4;
		timer += TMR2L;
	}
	
	TF2 = 0;									// Reset interrupt flag
  	SFRPAGE = SFRPAGE_SAVE; 					// Restore SFR page
}




