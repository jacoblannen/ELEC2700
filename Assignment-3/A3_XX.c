/*_____________________________________________________________________________________________________________________

        Project: Ultrasonic Radar       
        Author: Jacob Lannen (#3162100)        
        Date: 21/05/2014          

        Description:
        This program uses an ultrasonic transducer and servo to simulate a simple radar, displaying results on both
		the LCD on the peripherals board, and the PuTTY terminal via UART communication
_______________________________________________________________________________________________________________________*/

#include <c8051f120.h>		// SFR declarations
#include <stdio.h>			// Include stdio for sprintf() to display distances
#include "A3_XX.h"


int servopos;				// Servo position (50-230)
int x, dist = -1, i;
unsigned char disp_str[30];	// String which is used for both LCD and terminal displays
unsigned char input;
int state = 0, obj_angle[10], obj_dist[10] = {700,700,700,700,700,700,700,700,700,700}, obj_count = 0;	
int angle;


/*--------------------------------------------------------------------------------------------------------------------
        Function:         Main
        Description:      Main routine
--------------------------------------------------------------------------------------------------------------------*/
void main(void)
{
  	SFRPAGE = CONFIG_PAGE;
  	OSCICN = 0x83;							// Need a faster clock....24.5MHz selected
	General_Init();

	LCD_string("Ultrasonic Radar");			// Display title
	UART_transmit_str("ULTRASONIC RADAR\r\n------------------\r\n\nPRESS 'H' TO VIEW HELP OR 'S' TO START\n\r");

	while(input	!= 's')						// Loop until start button pressed
	{
		if(RI0 == 1)
		{
			input = UART_recieve();
		}
		else
		{
			input = 0;
		}

		if(input == 'h')					// If 'h' pressed display command table
		{
			UART_transmit_str("HELP:\r\nKEY:\tFUNCTION:\n\r'S'\tENTER AUTOMATIC SCAN MODE\n\r'M'\tENTER MANUAL SCAN MODE\r\n'T'\tENTER MOTION TRACKER MODE\r\n'O'\tVIEW OBJECT TRACKER\r\n'A'\tTURN SERVO LEFT(MAN MODE)/DEC OBJECT SELECT(OBJ TRACKER)\r\n'D'\tTURN SERVO RIGHT(MAN MODE)/INC OBJECT SELECT(OBJ TRACKER)\r\n'H'\tOPEN HELP(DUH)\r\n\n");
		}
	}

	// Display Auto mode display
	LCD_clr();
	LCD_string("Scanning...");
	LCD_newline();
	UART_transmit_str("\nAUTOMATIC SCAN MODE\r\n");

	EA = 1;										// Enable interrupts
	while(1)
	{			
		while(state == 0)						// Case for state 0 (Auto mode)
		{

			get_dist();							// Get distance
			LCD_string(disp_str);				// Display distance on both LCD and PC
			LCD_Com(0xC0);
			UART_transmit_str(disp_str);
			UART_transmit_str("\b\b\b\b \r");
			delay_milsec(100);					// Screen refresh delay
	
			if(ET0 == 0)						// If dist <100mm sound alarm
			{
				for(x = 0; x < 260; x++)
				{
					DAC0H = 0xFF;
					delay_usec(182);
					DAC0H = 0;
					delay_usec(182);
				}
				delay_milsec(786);
			}
			
			if(RI0 == 1)						// Read UART if data has been received
			{
				input = UART_recieve();
			}
						
			while(SMODE==0 || input == 'm')		// If SMODE or 'm' pressed change state to manual mode
			{
				LCD_clr();
				LCD_string("Manual Control");
				LCD_newline();
				UART_transmit_str("\n\n\nMANUAL SCAN MODE\r\n");
				
				input = 0;						// Clear input
				state = 1;
			}
			while(PB3 == 0 || input == 'o')		// If PB3 or 'o' pressed change state to object tracker
			{
				LCD_clr();
				LCD_string("Object Tracker");
				LCD_newline();
				UART_transmit_str("\n\n\nOBJECT TRACKER\r\n");
				
				sprintf(disp_str, "%i objects found", obj_count);	// Create string containing obj_count and display
				LCD_string(disp_str);
				LCD_Com(0xC0);
				UART_transmit_str(disp_str);
				UART_transmit_str("\r\n");
				
				for(x=0; x<obj_count; x++)		// Display location of all objects
				{
					sprintf(disp_str, "Object #%i: %i at %ddegrees\r\n", x+1, obj_dist[x], obj_angle[x]);
					UART_transmit_str(disp_str);
				}
				input = 0;						// Clear input
				i = 0;
				state = 2;
			}
			while(PB4==0 || input == 't')		// If PB4 or 't' pressed change state to motion tracker
			{
				LCD_clr();
				LCD_string("Motion Tracker");
				LCD_newline();
				UART_transmit_str("\n\n\nMOTION TRACKER MODE\r\n");
				input = 0;						// Clear input
				i=0;
				state = 3;
			}
		}
		while(state == 1)						// Case for state 1 (manual mode)
		{
			get_dist();							// Get distance and display
			LCD_string(disp_str);
			LCD_Com(0xC0);
			UART_transmit_str(disp_str);
			UART_transmit_str("\b\b\b\b \r");
			delay_milsec(100);

			if(RI0 == 1)						// Get UART input if any
			{
				input = UART_recieve();
			}
			else
			{
				input = 0;
			}

			while(SMODE==0 || input == 's')		// If SMODE or 's' pressed, return to auto mode
			{
				LCD_clr();
				LCD_string("Scanning...");
				LCD_newline();
				UART_transmit_str("\n\n\nAUTOMATIC SCAN MODE\r\n");
				input = 0;
				state = 0;
			}
		}
		while(state == 2)						// Case for state 2 (object tracker)
		{
			if(RI0 == 1)						// Check for UART input
			{
				input = UART_recieve();
			}
			
			if((PB2 == 0 || input == 'd') && i < (obj_count-1))		// If PB1 or 'd' pressed turn servo to next object
			{
				i++;
				delay_milsec(100);
				input = 0;
			}
			else if((PB1 == 0 || input == 'a') && i > 0)			// if PB2 or 'a' pressed turn servo to previous object
			{
				i--;
				delay_milsec(100);
				input = 0;
			}

			while(PB3==0 || input == 's')		// If PB3 or 's' pressed, return to auto mode
			{
				LCD_clr();
				LCD_string("Scanning...");
				LCD_newline();
				UART_transmit_str("\n\n\nAUTOMATIC SCAN MODE\r\n");
				input = 0;
				i=0;
				state = 0;
			}
		}
		while(state == 3)						// Case for motion tracker state
		{
			get_dist();							// Get distance and display
			LCD_string(disp_str);
			LCD_Com(0xC0);
			UART_transmit_str(disp_str);
			UART_transmit_str("\b\b\b\b \r");
			delay_milsec(100);
				
			if(RI0 == 1)						// Check for UART input
			{
				input = UART_recieve();
			}
						
			while(SMODE==0 || input == 'm')		// Go to manual mode
			{
				LCD_clr();
				LCD_string("Manual Control");
				LCD_newline();
				UART_transmit_str("\n\n\nMANUAL SCAN MODE\r\n");
				input = 0;
				state = 1;
			}
			while(PB4==0 || input == 's')		// Return to auto mode
			{
				LCD_clr();
				LCD_string("Scanning...");
				LCD_newline();
				UART_transmit_str("\n\n\nAUTOMATIC SCAN MODE\r\n");
				input = 0;
				i=0;
				state = 0;
			}
		}
	}
}

/*--------------------------------------------------------------------------------------------------------------------
        Function:         General_Init
        Description:      Initialise ports, watchdog....
--------------------------------------------------------------------------------------------------------------------*/
void General_Init()
{
	WDTCN = 0xde;
	WDTCN = 0xad;
  	SFRPAGE = CONFIG_PAGE;
	P0MDOUT = 0x10;		// NOTE: Pushpull required for Servo control OTHERWISE TOO WEAK TO DRIVE PROPERLY SINCE ONLY 3.3V!!!!
	P1MDOUT = 0x00;		// Ensure not pushpull outputs....this could damage microcontroller...
	P2MDOUT = 0xff;		// Need to make pushpull outputs to drive LEDs properly
	P3MDOUT = 0x7f;
	XBR0 = 0x04;		// Set XBar to use UART
	XBR2 = 0x40;
	Servo_Ctrl = 0;		// Initialise servo control pin to 0

	Timer_Init();
	UART_Init();
	LCD_Init();	
	Interrupts_Init();
	Voltage_Reference_Init();
	DAC_Init();
}

/*--------------------------------------------------------------------------------------------------------------------
        Function:         Timer_Init
        Description:      Initialise timers
--------------------------------------------------------------------------------------------------------------------*/
void Timer_Init()
{
	SFRPAGE = TIMER01_PAGE;
	TMOD = 0x21;
	CKCON = 0x10;
	TH1 = 0xB0;
	TCON = 0x50;
	SFRPAGE = TMR2_PAGE;
	TMR2CF = 0x1A;
}

/*--------------------------------------------------------------------------------------------------------------------
        Function:         Interrupts_Init
        Description:      Initialise interrupts
--------------------------------------------------------------------------------------------------------------------*/
void Interrupts_Init()
{
	IE = 0x02;
}

/*--------------------------------------------------------------------------------------------------------------------
	Function: Voltage_Reference_Init
	Description: Initialise voltage references (Needed for DAC)
--------------------------------------------------------------------------------------------------------------------*/
void Voltage_Reference_Init()
{
	SFRPAGE = ADC0_PAGE;
	REF0CN = 0x03; // Turn on internal bandgap reference and output buffer to get 2.4V reference (pg 107)
}

/*--------------------------------------------------------------------------------------------------------------------
	Function: DAC_Init
	Description: Initialise DAC0.
--------------------------------------------------------------------------------------------------------------------*/
void DAC_Init()
{
    SFRPAGE = DAC0_PAGE;
    DAC0CN = 0x84;
}

/*--------------------------------------------------------------------------------------------------------------------
        Function:         get_dist
        Description:      Send a pulse from the US transducer, then, use the delay to calculate the distance of the object
--------------------------------------------------------------------------------------------------------------------*/
void get_dist()
{
	TMR2L = 0;					// Reset timer values
	TMR2H = 0;

	for(x = 0; x<4; x++)		// Send 4 pulses
	{
		USonicTX = 1;
		delay_usec(1);
		USonicTX = 0;
		delay_usec(1);
	}
	delay_usec(12);				// Mask for ~150usec
	
	TR2 = 1;					// Turn on timer

	while(USonicRX == 0 && TF2 == 0);	// Wait for return signal or timeout

	TR2 = 0;					// Turn off timer
	

	if(TF2 == 1)				// If timeout reset overflow flag and set dist as -1
	{
		TF2 = 0;

		if(dist != -1)			// If object just lost add it to the object counter
			obj_count++;

		dist = -1;
		sprintf(disp_str, "OUT OF RANGE     ");	// Set display string to "out of range"
		ET0 = 1;
	}
	else						// If no timeout calculate distance
	{
		DPL = TMR2L;			// Move TMR2 to DPTR
		DPH = TMR2H;
		
		dist = (DPTR+150)/60;		// Calculate distance
		angle = servopos - 140;		// Calculate angle
		sprintf(disp_str, "Dist:%imm@%i%c   ", dist, angle, 0xDF);	// Create string containing dist and angle variables
		
		if(dist < obj_dist[obj_count])	// Find closest part of object and save its location
		{
			obj_dist[obj_count] = dist;
			obj_angle[obj_count] = angle;
		}
		
		if(dist < 100)				// If object closer than 100mm turn off servo interrupt
		{
			ET0 = 0;
		} 
		else
		{
			ET0 = 1;
		}
	}
}

/*--------------------------------------------------------------------------------------------------------------------
        Function:         Timer0_ISR
        Description:      Timer 0 interrupt service routine to run the servo motor
--------------------------------------------------------------------------------------------------------------------*/
void Timer0_ISR (void) interrupt 1
{
	unsigned char SFRPAGE_SAVE = SFRPAGE;        // Save Current SFR page
	static int rising = 1;			// Variable to determine if servo sweeping left or right 

	if(state==0)					// Case for auto mode
	{
		if(servopos <= 230 && rising == 1)	// Left to right sweep
		{		
			Servo_Ctrl = 1;
			delay_usec(servopos);
			Servo_Ctrl = 0;
			delay_milsec(10);
			servopos++;
			if(servopos == 230)
			{
				rising = 0;
				obj_count = 0;		// At end of sweep reset object count
				i = 0;
			}
		} else if(servopos >= 50 && rising == 0)	// Right to left sweep
		{		
			Servo_Ctrl = 1;
			delay_usec(servopos);
			Servo_Ctrl = 0;
			delay_milsec(10);
			servopos--;
			if(servopos == 50)
			{
				rising = 1;
				obj_count = 0;		// At end of sweep reset object count
				i = 0;
			}
		}	
	}
	else if(state == 1)				// Case for manual mode
	{
		if(RI0 == 1)				// Check for UART input
		{
			input = UART_recieve();
		}
		else
		{
			input = 0;
		}
		
		if((input == 'a' || PB1 == 0) && servopos > 50)		// If 'a' or PB1 pressed turn servo left
		{
			Servo_Ctrl = 1;
			delay_usec(servopos);
			Servo_Ctrl = 0;
			delay_milsec(10);
			servopos--;
		} else if((input == 'd' || PB2 == 0) && servopos < 230)	// If 'd' or PB2 pressed turn servo right
		{
			Servo_Ctrl = 1;
			delay_usec(servopos);
			Servo_Ctrl = 0;
			delay_milsec(10);
			servopos++;
		}
	}
	else if(state == 2)				// Case for object tracker
	{
		if(obj_count > 0)
		{
			Servo_Ctrl = 1;
			delay_usec((obj_angle[i]+140));	// Turn servo to angle of selected object
			Servo_Ctrl = 0;
			delay_milsec(10);
		}
	}
	else if(state==3)				// Case for motion tracker
	{
		if(rising == 1)
		{		
			Servo_Ctrl = 1;
			delay_usec(servopos);
			Servo_Ctrl = 0;
			delay_milsec(10);
			servopos++;
			if(dist == -1)			// If object lost change direction
			{
				rising = 0;
				servopos+=5;
			}
		} else if(rising == 0)
		{		
			Servo_Ctrl = 1;
			delay_usec(servopos);
			Servo_Ctrl = 0;
			delay_milsec(10);
			servopos--;
			if(dist == -1)			// If object lost change direction
			{
				rising = 1;
				servopos-=5;
			}
		}	
	}

	TF0 = 0;									// Reset interrupt flag
  	SFRPAGE = SFRPAGE_SAVE; 					// Restore SFR page
}
