/*_____________________________________________________________________________________________________________________

	Assignment: Assignment 2 (Electronic Keyboard)
	Module:
	Author: Jacob Lannen
	Date: 14/04/2014

	Description:
	This program will use the provided peripherals (LEDs, push buttons, etc)
	to create a simple electronic keyboard, playing 12 notes

	Notes:

	Revisions:

_____________________________________________________________________________________________________________________*/
#include <compiler_defs.h>
#include <C8051F120_defs.h> // SFR declarations
#include "Assign2.h"


/*--------------------------------------------------------------------------------------------------------------------
	Function: Main

	Description: Main routine

	Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void main(void)
{
	General_Init();
	Timer_Init();
	Voltage_Reference_Init();
	DAC_Init();
	Interrupts_Init();
	LCD_Init();
	LCD_string(" \"Music\" Maker");

	while(1)
	{	
		if(state == 1)
		{
			SFRPAGE = TMR2_PAGE;
			TR2 = 0;
			P2=0;
			LD1=~PB1;
			LCD_newline();			
			LCD_string("                ");

			switch(octave)
			{
				case 3:
					while(PB2==0)
					{
						TR2=1;
						LD2=1;
						LD1=~PB1;			
						if(PB1 == 1)
						{
							LCD_newline();
							LCD_string("      C3        ");
							RCAP2 = C3;
						}else{
							LCD_newline();
							LCD_string("      C#3       ");
							RCAP2 = C3S;
						}
					}
			
					while(PB3==0)
					{
						TR2=1;
						LD3=1;
						LD1=~PB1;
						if(PB1 == 1)
						{
							LCD_newline();
							LCD_string("      D3        ");
							RCAP2 = D3;
						}else{
							LCD_newline();
							LCD_string("      D#3       ");
							RCAP2 = D3S;
						}
					}
			
					while(PB4==0)
					{
						TR2=1;
						LD4=1;
						LD1=~PB1;
						LCD_newline();
						LCD_string("      E3        ");
						RCAP2 = E3;
					}
			
					while(PB5==0)
					{
						TR2=1;
						LD5=1;
						LD1=~PB1;
						if(PB1 == 1)
						{
							LCD_newline();
							LCD_string("      F3        ");
							RCAP2 = F3;
						}else{
							LCD_newline();
							LCD_string("      F#3       ");
							RCAP2 = F3S;
						}
					}
			
					while(PB6==0)
					{
						TR2=1;
						LD6=1;
						LD1=~PB1;
						if(PB1 == 1)
						{
							LCD_newline();
							LCD_string("      G3        ");
							RCAP2 = G3;
						}else{
							LCD_newline();
							LCD_string("      G#3       ");
							RCAP2 = G3S;
						}
					}
			
					while(PB7==0)
					{
						TR2=1;
						LD7=1;
						LD1=~PB1;
						if(PB1 == 1)
						{
							LCD_newline();
							LCD_string("      A3        ");
							RCAP2 = A3;
						}else{
							LCD_newline();
							LCD_string("      A#3       ");
							RCAP2 = A3S;
						}
					}
			
					while(PB8==0)
					{
						TR2=1;
						LD8=1;
						LD1=~PB1;
						LCD_newline();
						LCD_string("      B3        ");
						RCAP2 = B3;	
					}
					break;
								
				case 4:
					while(PB2==0)
					{
						TR2=1;
						LD2=1;
						LD1=~PB1;
						if(PB1 == 1)
						{
							LCD_newline();
							LCD_string("      C4        ");	
							RCAP2 = C4;
						}else{
							LCD_newline();
							LCD_string("      C#4       ");
							RCAP2 = C4S;
						}
					}
			
					while(PB3==0)
					{
						TR2=1;
						LD3=1;
						LD1=~PB1;
						if(PB1 == 1)
						{
							LCD_newline();
							LCD_string("      D4        ");
							RCAP2 = D4;
						}else{
							LCD_newline();
							LCD_string("      D#4       ");
							RCAP2 = D4S;
						}
					}
			
					while(PB4==0)
					{
						TR2=1;
						LD4=1;
						LD1=~PB1;
						LCD_newline();
						LCD_string("      E4        ");
						RCAP2 = E4;
					}
			
					while(PB5==0)
					{
						TR2=1;
						LD5=1;
						LD1=~PB1;
						if(PB1 == 1)
						{
							LCD_newline();
							LCD_string("      F4        ");
							RCAP2 = F4;
						}else{
							LCD_newline();
							LCD_string("      F#4       ");
							RCAP2 = F4S;
						}
					}
			
					while(PB6==0)
					{
						TR2=1;
						LD6=1;
						LD1=~PB1;
						if(PB1 == 1)
						{
							LCD_newline();
							LCD_string("      G4        ");
							RCAP2 = G4;
						}else{
							LCD_newline();
							LCD_string("      G#4       ");
							RCAP2 = G4S;
						}
					}
			
					while(PB7==0)
					{
						TR2=1;
						LD7=1;
						LD1=~PB1;
						if(PB1 == 1)
						{
							LCD_newline();
							LCD_string("      A4        ");
							RCAP2 = A4;
						}else{
							LCD_newline();
							LCD_string("      A#4       ");
							RCAP2 = A4S;
						}
					}
			
					while(PB8==0)
					{
						TR2=1;
						LD8=1;
						LD1=~PB1;
						LCD_newline();
						LCD_string("      B4        ");
						RCAP2 = B4;	
					}
					break;
								
				case 5:
					while(PB2==0)
					{
						TR2=1;
						LD2=1;
						LD1=~PB1;
						if(PB1 == 1)
						{
							LCD_newline();
							LCD_string("      C5        ");
							RCAP2 = C5;
						}else{
							LCD_newline();
							LCD_string("      C#5       ");
							RCAP2 = C5S;
						}
					}
			
					while(PB3==0)
					{
						TR2=1;
						LD3=1;
						LD1=~PB1;
						if(PB1 == 1)
						{
							LCD_newline();
							LCD_string("      D5        ");
							RCAP2 = D5;
						}else{
							LCD_newline();
							LCD_string("      D#5       ");
							RCAP2 = D5S;
						}
					}
			
					while(PB4==0)
					{
						TR2=1;
						LD4=1;
						LD1=~PB1;
						LCD_newline();
						LCD_string("      E5        ");
						RCAP2 = E5;
					}
			
					while(PB5==0)
					{
						TR2=1;
						LD5=1;
						LD1=~PB1;
						if(PB1 == 1)
						{
							LCD_newline();
							LCD_string("      F5        ");
							RCAP2 = F5;
						}else{
							LCD_newline();
							LCD_string("      F#5       ");
							RCAP2 = F5S;
						}
					}
			
					while(PB6==0)
					{
						TR2=1;
						LD6=1;
						LD1=~PB1;
						if(PB1 == 1)
						{
							LCD_newline();
							LCD_string("      G5        ");
							RCAP2 = G5;
						}else{
							LCD_newline();
							LCD_string("      G#5       ");
							RCAP2 = G5S;
						}
					}
			
					while(PB7==0)
					{
						TR2=1;
						LD7=1;
						LD1=~PB1;
						if(PB1 == 1)
						{
							LCD_newline();
							LCD_string("      A5        ");
							RCAP2 = A5;
						}else{
							LCD_newline();
							LCD_string("      A#5       ");
							RCAP2 = A5S;
						}
					}
			
					while(PB8==0)
					{
						TR2=1;
						LD8=1;
						LD1=~PB1;
						LCD_newline();
						LCD_string("      B5        ");
						RCAP2 = B5;	
					}
					break;
			}

			while(MPB==0)
			{
				state = 0;
				LCD_clr();
				LCD_string("Config:        ");
			}

		}else if(state == 0)
		{
			while(PB1==0&&volume<15)
			{
				volume++;
				volume_disp();
				delay(20);
			}
			while(PB2==0&&volume>0)
			{
				volume--;
				volume_disp();
				delay(20);
			}
			while(PB3==0)
			{
				octave = 3;
				LCD_newline();
				LCD_string("Octave: Low     ");
			}
			while(PB4==0)
			{
				octave = 4;
				LCD_newline();
				LCD_string("Octave: Middle  ");
			}
			while(PB5==0)
			{
				octave = 5;
				LCD_newline();
				LCD_string("Octave: High    ");
			}

			while(MPB==0)
			{
				state = 1;
				LCD_clr();
				LCD_string(" \"Music\" Maker");
			}
		}
	}
}

/*--------------------------------------------------------------------------------------------------------------------
	Function: General_Init

	Description: Initialise ports, watchdog....

	Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void General_Init()
{
	WDTCN = 0xde;
	WDTCN = 0xad;
   	SFRPAGE = CONFIG_PAGE;
	P0MDOUT = 0x00;
	P1MDOUT = 0x00;
	P2MDOUT = 0xff;	// Need to make pushpull outputs to drive LEDs properly
	P3MDOUT = 0x7f;	

	XBR2 = 0x40;
}

/*--------------------------------------------------------------------------------------------------------------------
	Function: Timer_Init

	Description: Initialise timer ports and registers

	Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void Timer_Init()
{
    OSCICN = 0x83;	//Initialise internal oscillator to 24.5MHz
	SFRPAGE = TMR2_PAGE;
    TMR2CN = 0x00;
    TMR2CF = 0x0A;
    RCAP2 = 0x0001;
}

/*--------------------------------------------------------------------------------------------------------------------
	Function: Voltage_Reference_Init

	Description: Initialise voltage references (Needed for DAC)

	Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void Voltage_Reference_Init()
{
	SFRPAGE = ADC0_PAGE;
	REF0CN = 0x03; // Turn on internal bandgap reference and output buffer to get 2.4V reference (pg 107)
}

/*--------------------------------------------------------------------------------------------------------------------
	Function: DAC_Init

	Description: Initialise DAC0.

	Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void DAC_Init()
{
    SFRPAGE = DAC0_PAGE;
    DAC0CN = 0x84;
}

/*--------------------------------------------------------------------------------------------------------------------
	Function: LCD_Reset

	Description: Reset LCD

	Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void LCD_Reset()
{
	LCD = 0xFF;
	delay(100);
	LCD = 0x83+LCD_EN;
	LCD = 0x83;
	delay(100);
	LCD = 0x83+LCD_EN;
	LCD = 0x83;
	delay(100);
	LCD = 0x83+LCD_EN;
	LCD = 0x83;
	delay(100);
	LCD = 0x82+LCD_EN;
	LCD = 0x82;
	delay(100);
}

/*--------------------------------------------------------------------------------------------------------------------
	Function: LCD_Init

	Description: Initialise LCD

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
	Function: LCD_Com

	Description: sends commands to the LCD

	Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void LCD_Com(char cmd)
{
	LCD=((cmd >> 4) & 0x0F)|LCD_EN|0x80;
	LCD=((cmd >> 4) & 0x0F)|0x80;

	LCD=(cmd & 0x0F)|LCD_EN|0x80;
	LCD=(cmd & 0x0F)|0x80;
	
	delay(10);
}

/*--------------------------------------------------------------------------------------------------------------------
	Function: LCD_Data

	Description: sends data to the LCD

	Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void LCD_Data(unsigned char dat)
{
	LCD=(((dat >> 4) & 0x0F)|LCD_EN|LCD_RS|0x80);
	LCD=(((dat >> 4) & 0x0F)|LCD_RS|0x80);

	LCD=((dat & 0x0F)|LCD_EN|LCD_RS|0x80);
	LCD=((dat & 0x0F)|LCD_RS|0x80);
	
	delay(10);
}

void LCD_string(unsigned char *str)
{
	while(*str)
	{
		LCD_Data(*str++);
	}
	delay(10);
}

void LCD_clr()
{
	LCD_Com(0x01);
	LCD_Com(0x02);
}

void LCD_newline()
{
	LCD_Com(0xC0);
}
/*--------------------------------------------------------------------------------------------------------------------
	Function: Delay & Delay_cycle

	Description: functions to create a delay of an input number of milliseconds

	Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void delay_cycle(int u)
{
	while(u!=0)
	{
		u--;
	}
}

void Delay(int i)
{
	while(i!=0)
	{
		delay_cycle(2733);
		i--;
	}
}

void volume_disp()
{
	switch (volume)
	{
		case 0:
			LCD_newline();
			LCD_string("Volume: 0       ");
			P2=0x00;
			break;
		case 1:
			LCD_newline();
			LCD_string("Volume: 1       ");
			P2=0x80;
			break;
		case 2:
			LCD_newline();
			LCD_string("Volume: 2       ");
			P2=0x40;
			break;
		case 3:
			LCD_newline();
			LCD_string("Volume: 3       ");
			P2=0xC0;
			break;
		case 4:
			LCD_newline();
			LCD_string("Volume: 4       ");
			P2=0x20;
			break;
		case 5:
			LCD_newline();
			LCD_string("Volume: 5       ");
			P2=0xA0;
			break;
		case 6:
			LCD_newline();
			LCD_string("Volume: 6       ");
			P2=0x60;
			break;
		case 7:
			LCD_newline();
			LCD_string("Volume: 7       ");
			P2=0xE0;
			break;
		case 8:
			LCD_newline();
			LCD_string("Volume: 8       ");
			P2=0x10;
			break;
		case 9:
			LCD_newline();
			LCD_string("Volume: 9       ");
			P2=0x90;
			break;
		case 10:
			LCD_newline();
			LCD_string("Volume: 10      ");
			P2=0x50;
			break;
		case 11:
			LCD_newline();
			LCD_string("Volume: 11      ");
			P2=0xD0;
			break;
		case 12:
			LCD_newline();
			LCD_string("Volume: 12      ");
			P2=0x30;
			break;
		case 13:
			LCD_newline();
			LCD_string("Volume: 13      ");
			P2=0xB0;
			break;
		case 14:
			LCD_newline();
			LCD_string("Volume: 14      ");
			P2=0x70;
			break;
		case 15:
			LCD_newline();
			LCD_string("Volume: 15      ");
			P2=0xF0;
			break;
	}
}

/*--------------------------------------------------------------------------------------------------------------------
	Function: Interrupts_Init

	Description: Initialise interrupts

	Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void Interrupts_Init()
{
	IE = 0xA0; // Global enable interrupt + timer 2 interrupt
}

/*--------------------------------------------------------------------------------------------------------------------
	Function: Timer2_ISR

	Description:

	Revisions:

--------------------------------------------------------------------------------------------------------------------*/
void Timer2_ISR (void) interrupt 5
{
   	unsigned char SFRPAGE_SAVE = SFRPAGE; // Save Current SFR page
	unsigned char DAC_value;
	const unsigned char code sine[] = {128,131,134,137,140,143,146,149,152,155,158,162,165,167,170,173,176,179,182,185,188,190,193,196,198,201,203,206,208,211,213,215,218,220,222,224,226,228,230,232,234,235,237,238,240,241,243,244,245,246,248,249,250,250,251,252,253,253,254,254,254,255,255,255,255,255,255,255,254,254,254,253,253,252,251,250,250,249,248,246,245,244,243,241,240,238,237,235,234,232,230,228,226,224,222,220,218,215,213,211,208,206,203,201,198,196,193,190,188,185,182,179,176,173,170,167,165,162,158,155,152,149,146,143,140,137,134,131,128,124,121,118,115,112,109,106,103,100,97,93,90,88,85,82,79,76,73,70,67,65,62,59,57,54,52,49,47,44,42,40,37,35,33,31,29,27,25,23,21,20,18,17,15,14,12,11,10,9,7,6,5,5,4,3,2,2,1,1,1,0,0,0,0,0,0,0,1,1,1,2,2,3,4,5,5,6,7,9,10,11,12,14,15,17,18,20,21,23,25,27,29,31,33,35,37,40,42,44,47,49,52,54,57,59,62,65,67,70,73,76,79,82,85,88,90,93,97,100,103,106,109,112,115,118,121,124};
	
	DAC_value= sine[phase];
	DAC0H= DAC_value/(16-volume);
	phase++;
	TF2 = 0; // Reset Interrupt
   	SFRPAGE = SFRPAGE_SAVE; // Restore SFR page
}
