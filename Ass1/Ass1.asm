$INClude (c8051f120.INC) ; Includes register definition file
;-----------------------------------------------------------------------------
; EQUATES
;-----------------------------------------------------------------------------
	Temp				equ				R0							; Used for misc temp storage
	Score				equ				R1							; Holds score at 8-bit number, with each nibble representing a different player
	State				equ				R4							; Holds current state value
	LCD_Data		equ				P3							; Used to address LCD through P3
	LCD_EN			equ				P3.6						; Enable bit for the LCD
	Inpt				equ				20H							;	Holds most recent input from push buttons
	Confg				equ				21H							; Holds game configuration
	Score_Rev		equ				22H							; Holds reversed score byte (for display)
	Snd_Cfg			equ				23H							; Holds sound config byte (also inc/dec flags for vol/spd toggles)
	Spd					equ				24H							; Holds current speed/delay value
	Vol					equ				25H							; Holds current voltage value
	Max_Score		equ				26H							; Holds max score (used for sudden death mode)


	org 0000H
		ljmp Start 													; Locate a jump to the start of code at
	org 0100H
;-----------------------------------------------------------------------------
; Initialisation for Peripheral Board
;-----------------------------------------------------------------------------
	Start: 	mov WDTCN, 		#0DEh
        	mov WDTCN, 		#0ADh
        	mov SFRPAGE, 	#CONFIG_PAGE 		; Use SFRs on the Configuration Page
        	mov P0MDOUT, 	#00000000b 			; Inputs
        	mov P1MDOUT, 	#00000000b 			; Inputs
        	mov P2MDOUT, 	#11111111b 			; Outputs
					mov P3MDOUT,	#11111111b			;	Set LCD as output
        	mov XBR2, 		#40h						; Enable the Port I/O Crossbar
					lcall Init_Devices						;	Initialise DAC and voltage reference

;--------------------------------- Initialisation---------------------------------------
	mov 	State, 			#0									; Initialise game to Stop/Config State
	mov 	Score, 			#0									; Initialise score to zero
	mov 	Inpt, 			#0FFH								; Initialise input byte to default value (#0FFH)
	mov 	Confg, 			#0									; Initialise config byte to zero
	mov 	Score_Rev, 	#0									; Initialise byte used in "score display" subroutine
	mov 	Snd_Cfg, 		#00000011b					; Initialise volume & mute settings and inc/dec flags for volume and speed
	mov 	Vol, 				#20H								; Initialise volume value
	mov		Max_Score,	#0FH								; Set max score to 15
	lcall Start_screen										; Send game to 'title screen'
	mov		P2,	 				#00000011b					;	Initialise LEDs to default config state

;--------------------------------- Main Loop-------------------------------------------
	
	Main_loop:
							mov Inpt, #0FFH								;Reset input status
							mov A, State									;Shift current state into accumulator
							rl A													;Rotate the accumulator left (i.e. double its held value)
							mov	DPTR, #State_table				;Shift the datapointer to the state table's label
							jmp @A+DPTR										;Jump to a location with a certain offset (A) from the datapointer

	State_table:
							ajmp State_1					;Stop state
							ajmp State_2					;Pre-game state (waiting for Player 1 to serve)
							ajmp State_3					;Ball initialised to LD1
							ajmp State_4					;Ball move right to LD2
							ajmp State_5					;Ball move right to LD3
							ajmp State_6					;Ball move right to LD4
							ajmp State_7					;Ball move right to LD5
							ajmp State_8					;Ball move right to LD6
							ajmp State_9					;Ball move right to LD7
							ajmp State_10					;Ball move right to LD8
							ajmp State_11					;Ball move left to LD7
							ajmp State_12					;Ball move left to LD6
							ajmp State_13					;Ball move left to LD5
							ajmp State_14					;Ball move left to LD4
							ajmp State_15					;Ball move left to LD3
							ajmp State_16					;Ball move left to LD2
							ajmp State_17					;Ball move left to LD1
							ajmp State_18					;P1 Scores
							ajmp State_19					;P2 Scores
							ajmp State_20					;Pause state
							ajmp State_21					;Lose state
							ajmp State_22					;P2 Serves
	
	State_1:	;Take input from player(s) to determine configuration of game
						;Save desired config in config byte
					mov Score, #0						;Initialise score to start new game
					lcall Button_Check				;Check user input
					lcall Action							;Run appropriate action for input/state combination
					lcall Feedback_Delay			;Run delay to reduce risk of "double tap" inputs
					ajmp 	Main_loop						;Return to main loop of state machine
	
	State_2:	;Ball initialised to LD1, waiting for player 1 to serve
					mov P2, #00000001b				;Initialise "ball" for P1 serve
					lcall Button_Check				;Check input
					lcall Action							;Run action
					lcall Feedback_Delay			;Input delay
					ajmp Main_Loop						;Return

	State_3:	;Enter play with ball at LD1 (return to this state upon ball return)
					lcall Button_Check				
					lcall Action
					lcall Feedback_Delay
					ajmp Main_Loop
	
	State_4:	;Ball move right to LD2
					lcall Delay
					lcall Action
					cjne R4, #4, Pause4				;If state not equal to #4 (the value of State_5) do not move the balls position as pause or stop action have occured
					lcall Ball_Right
	Pause4:	ajmp Main_Loop

	State_5:	;Ball move right to LD3
					lcall Delay
					lcall Action
					cjne R4, #5, Pause5
					lcall Ball_Right
	Pause5:	ajmp Main_Loop

	State_6:	;Ball move right to LD4
					lcall Delay
					lcall Action
					cjne R4, #6, Pause6
					lcall Ball_Right
	Pause6:	ajmp Main_Loop	

	State_7:	;Ball move right to LD5
					lcall Delay
					lcall Action
					cjne R4, #7, Pause7
					lcall Ball_Right
	Pause7:	ajmp Main_Loop	

	State_8:	;Ball move right to LD6
					lcall Delay
					lcall Action
					cjne R4, #8, Pause8
					lcall Ball_Right
	Pause8:	ajmp Main_Loop

	State_9:	;Ball move right to LD7
					lcall Delay
					lcall Action
					cjne R4, #9, Pause9
					lcall Ball_Right
	Pause9:	ajmp Main_Loop

	State_10:	;Ball move right to LD8
					lcall Delay
					lcall Action
					cjne R4, #10, Pause10
					lcall Ball_Right
	Pause10:ajmp Main_Loop

	State_11:	;Ball moving left to LD7
					lcall Delay
					lcall Action
					cjne R4, #11, Pause11
					lcall Ball_Left
	Pause11:ajmp Main_Loop

	State_12:	;Ball moving left to LD6
					lcall Delay
					lcall Action
					cjne R4, #12, Pause12
					lcall Ball_Left
	Pause12:ajmp Main_Loop

	State_13:	;Ball moving left to LD5
					lcall Delay
					lcall Action
					cjne R4, #13, Pause13
					lcall Ball_Left
	Pause13:ajmp Main_Loop

	State_14:	;Ball moving left to LD4
					lcall Delay
					lcall Action
					cjne R4, #14, Pause14
					lcall Ball_Left
	Pause14:ajmp Main_Loop

	State_15:	;Ball moving left to LD3
					lcall Delay
					lcall Action
					cjne R4, #15, Pause15
					lcall Ball_Left
	Pause15:ajmp Main_Loop

	State_16:	;Ball moving left to LD2
					lcall Delay
					lcall Action
					cjne R4, #16, Pause16
					lcall Ball_Left
	Pause16:ajmp Main_Loop

	State_17:	;Ball moving left to LD1
					lcall Delay
					lcall Action
					cjne R4, #3, Pause17
					lcall Ball_Left
	Pause17:ajmp Main_Loop

	State_18:	;P1 Scores
					lcall Score_Beep
					lcall LCD_clr										;Clear LCD and display P1 point string
					mov DPTR, #P1_point_string
					lcall LCD_string
					clr C
					mov A, Score
					add A, #00010000b								;Increment upper nibble of score byte
					mov Score, A
					swap A
					anl A, #0FH											;Swap nibbles and mask upper nibble (leaving P1's score)
		Flash1:	mov P2, #00000001b						;Flash LD1 at a frequency of 1Hz for each point P1 has scored
						mov P2, #0
						lcall Flash_Delay
						dec A
						jnz Flash1
					mov A, Score
					swap A
					anl A, #0FH
					subb A, Max_Score
					jz Lose1												;If score = 15 jump to game over route
					lcall LCD_clr										;Reset LCD to display P2 serve string
					mov DPTR, #P2_serve_string
					lcall LCD_string
					mov State, #21									;Jump to P2 serve state.
					ajmp Main_Loop
		Lose1:lcall LCD_clr										;Reset LCD and display game over strings
					mov DPTR, #Game_over_string
					lcall LCD_string
					lcall LCD_line2
					mov DPTR, #P1_win_string
					lcall LCD_string
					mov State, #20									;Jump to game over state
					ajmp Main_Loop

	State_19:	;P2 Scores
					lcall Score_Beep
					lcall LCD_clr										;Clear LCD and display P2 point string
					mov DPTR, #P2_point_string
					lcall LCD_string
					clr C
					mov A, Score										
					add A, #00000001b								;Increment the lower nibble of score byte
					mov Score, A
					anl A, #0FH											;Bitmask upper nibble (leaving only P2's score in the Acc)
		Flash2:	mov P2, #10000000b						;Flash LD8 at a frequency of 1Hz for each point P2 has scored
						lcall Flash_Delay
						mov P2, #0
						lcall Flash_Delay
						dec A														
						jnz Flash2
					mov A, Score
					anl A, #0FH
					subb A, Max_Score										;If score = 15, jump to P2 win path
					jz Lose2
					lcall LCD_clr										;Reset LCD to display P1 serve string
					mov DPTR, #P1_serve_string
					lcall LCD_string
					mov State, #1										;Return to P1 serve state
					ajmp Main_Loop
		Lose2:lcall LCD_clr										;Clear LCD and display game over strings
					mov DPTR, #Game_over_string			
					lcall LCD_string
					lcall LCD_line2
					mov DPTR, #P2_win_string
					lcall LCD_string
					mov State, #20									;Jump to game over state
					ajmp Main_Loop

	State_20:	;Pause State
					mov R3, P2											;Move current light status to R3 for temp storage
	Pause_Loop:				
					lcall Display_Score							;Call routine to display score on LEDs
					lcall Button_Check							;Check inputs
					lcall Action										;Perform action
					lcall Feedback_Delay						;Run feedback delay
					cjne R4, #19, Resume						;If action subroutine has caused change in state, exit pause loop
					mov Inpt, #0FFH									;Reset input status
					sjmp Pause_Loop
	Resume:	
					ajmp Main_Loop									;Return to main loop

	State_21: ;Game Over State
					lcall Display_Score							;Display final score on LEDs
					lcall Button_Check							;Check inputs
					lcall Action										;Perform action
					lcall Feedback_Delay						;Run delay
					cjne R4, #0, State_21						;Loop until game to return to stop state
					mov P2, 021H										;Return config LEDs
					ajmp Main_Loop									;Return to main loop

	State_22:	;P2 Serves the ball
					mov P2, #10000000b							;Ball initialised to LD8
					lcall Button_Check							;Check input
					lcall Action										;Perform action
					lcall Feedback_Delay						;Run delay
					cjne R4, #21, Esc								;Loop until player 2 serves or quits game
					sjmp State_22
		Esc:	ajmp Main_Loop									;Return to main loop

;--------------------------------- Functions---------------------------------------
	
	Start_screen:																		;Routine to put the game in start-up mode, displaying title on LCD until any button is pressed
							mov		DPTR, #Start_string1
							lcall	LCD_String
	flash_loop:	lcall	LCD_line2											;Loop causing "Push to start" string and the LEDs to flash
							mov 	DPTR, #Start_string2
							lcall LCD_String
							mov 	P2, #0AAH
							lcall LCD_flash_delay
							lcall LCD_line2
							mov		DPTR, #Clear_line
							lcall LCD_String
							mov		P2, #055H
							lcall LCD_flash_delay
							mov		temp, Inpt
							cjne 	temp, #0FFH, start_game
							sjmp	flash_loop
	start_game:	lcall LCD_clr
							mov 	DPTR, #Stop_string							; Initialise LCD screen to display "Configure: " string
							lcall LCD_String
							lcall Menu_beep
							lcall Feedback_delay
							ret

;----------Initialisation Routines----------	
	Init_Devices:																			;Routine to call initialisation routines for extra peripherals
    call DAC_Init
    call Voltage_Reference_Init
    call LCD_Init
		ret
	
	DAC_Init:																					;Initialise DAC (for use with piezo)
    mov  SFRPAGE,   #DAC0_PAGE
    mov  DAC0CN,    #084h
    ret

	Voltage_Reference_Init:														;Initialise volt reference (used by DAC)
    mov  SFRPAGE,   #ADC0_PAGE
    mov  REF0CN,    #003h
    ret

	LCD_Init:																					;Initialise LCD
		lcall LCD_Reset				
		mov A, #28H																			;Format: 4-bit input, 2 line, 5x7 font
		lcall LCD_cmd
		mov A, #0CH																			;Display on, cursor off
		lcall LCD_cmd
		mov A, #01H																			;Clear display
		lcall LCD_cmd
		mov A, #06H																			;Input mode: auto inc, no shift
		lcall LCD_cmd
		mov A, #80H																			;Reset cursor
		lcall LCD_cmd
		ret


;----------Delay-related Routines----------
	Button_Check:						;Standard debouncing button check loop. Used in states with non-variable delays (ie pause, stop, serve)
			BLoop2:		mov R7, #0AH	
			BLoop1: 	mov R6, #00h
			BLoop0: 	mov R5, #00h
      					lcall Button_Status
								cjne R0, #0FFH, Check_Esc
								djnz R5, $
       					djnz R6, BLoop0
        				djnz R7, BLoop1
			Check_Esc:
			ret

	Delay: 											;Variable Delay using subroutine "Get_Delay_Value" to set the correct delay for the selected speed setting
				Loop2:	mov R7, Spd	
				Loop1: 	mov R6, #0F7h
				Loop0: 	mov R5, #0FEh
      					lcall Button_Status			;Check button status throughout loop, ensuring that if a button is pressed during the delay it is still registered
								djnz R5, $
       					djnz R6, Loop0
        				djnz R7, Loop1
			ret

	Get_Delay_Value:						;Subroutine that uses the config byte (21H) to determine the speed setting, and hence the required delay and stores it in byte 24H
				jb 0EH, Speed_6
				jb 0DH, Speed_5
				jb 0CH, Speed_4
				jb 0BH, Speed_3
				jb 0AH, Speed_2
				mov A, #0
				mov DPTR, #Delay_Value	;Delay value retrieved from lookup table
				movc A, @A+DPTR
				mov Spd, A
				ret
				Speed_2: 	mov A, #1
									mov DPTR, #Delay_Value
									movc A, @A+DPTR
									mov Spd, A
									ret
				Speed_3: 	mov A, #2
									mov DPTR, #Delay_Value
									movc A, @A+DPTR
									mov Spd, A
									ret
				Speed_4: 	mov A, #3
									mov DPTR, #Delay_Value
									movc A, @A+DPTR
									mov Spd, A
									ret
				Speed_5: 	mov A, #4
									mov DPTR, #Delay_Value
									movc A, @A+DPTR
									mov Spd, A
									ret
				Speed_6: 	mov A, #5
									mov DPTR, #Delay_Value
									movc A, @A+DPTR
									mov Spd, A
									ret

	Flash_Delay:								;Delay of 500ms to facilitate a flash of 1Hz when scores are displayed
				FLoop2:		mov R7, #08h	
				FLoop1: 	mov R6, #0FCh
				FLoop0: 	mov R5, #0FFh
        					djnz R5, $
        					djnz R6, FLoop0
        					djnz R7, FLoop1
		ret
	
	Feedback_Delay:							;Delay to decrease risk of "double tap"
				FBLoop2:	mov R7, #04h	
				FBLoop1: 	mov R6, #00h
				FBLoop0: 	mov R5, #00h
        					djnz R5, $
        					djnz R6, FBLoop0
        					djnz R7, FBLoop1
		ret
	LCD_Init_Delay:							;Delay of 50ms to allow for all required delays during LCD initialisation
			LCDILoop2:	mov R7, #04h	
			LCDILoop1: 	mov R6, #033h
			LCDILoop0: 	mov R5, #0FDh
        					djnz R5, $
        					djnz R6, LCDILoop0
        					djnz R7, LCDILoop1
		ret

	LCD_Delay:									;Delay of 1ms to allow time for LCD to recieve and write data
			LCDLoop2:		mov R7, #01h	
			LCDLoop1: 	mov R6, #05h
			LCDLoop0: 	mov R5, #0CDh
        					djnz R5, $
        					djnz R6, LCDLoop0
        					djnz R7, LCDLoop1
		ret

	LCD_flash_delay:						;Delay used in start screen, flashing "push to start" while also checking button input
			LCDFLoop2:		mov R7, #08H
			LCDFLoop1: 		mov R6, #0FCH
			LCDFLoop0: 		mov R5, #0FFH
      							lcall Button_Status
										cjne R0, #0FFH, Start_Esc
										djnz R5, $
       							djnz R6, LCDFLoop0
        						djnz R7, LCDFLoop1
			Start_Esc:
			ret



;----------Action Routines----------	
	Action:			;Action subroutine containing the allowed user actions for each state, and their results. 
							mov A, State	; Shift current state into accumulator
							rl A
							mov	DPTR, #State_Actions	;Move the State_Actions table into the data pointer
							jmp @A+DPTR								;Jump to the allowable action set for current state.
	
		State_Actions:								;State table to determine which state is currently being run, and hence what actions to take.
								ajmp S1_Actions
								ajmp S2_Actions
								ajmp S3_Actions
								ajmp S4_Actions
								ajmp S5_Actions
								ajmp S6_Actions
								ajmp S7_Actions
								ajmp S8_Actions
								ajmp S9_Actions
								ajmp S10_Actions
								ajmp S11_Actions
								ajmp S12_Actions
								ajmp S13_Actions
								ajmp S14_Actions
								ajmp S15_Actions
								ajmp S16_Actions
								ajmp S17_Actions
								ajmp S18_Actions
								ajmp S19_Actions
								ajmp S20_Actions
								ajmp S21_Actions
								ajmp S22_Actions


		S1_Actions:					;Allowable actions for State 1: Toggle players, speed, mode, and volume, or enter play state.
								lcall Get_Volume_Value
								jnb 01H, toggle_players											
								jnb 02H, toggle_speed
								jnb 03H, Play
								jnb 04H, Sudden_death
								jnb 05H, toggle_volume
								jnb 06H, Mute_Toggle
								ret
								Play:						lcall LCD_clr
																mov DPTR, #P1_serve_string
																lcall LCD_string
																mov Confg, P2								;When PB4 is pressed, save the current byte in P2 into the config byte (21H)
																INC State										;Increment the state value to enter play state
																lcall Menu_Beep
																lcall Get_Delay_Value
																ret
								Mute_Toggle:		lcall Feedback_delay				;When PB7 pressed toggle mute and display status on LCD
																lcall LCD_line2
																jb 1AH, Mute_off
																setb 1AH
																mov DPTR, #Mute_on_string
																lcall LCD_string
																ret
								mute_off:				clr 1AH
																mov DPTR, #Mute_off_string
																lcall LCD_string
																lcall Get_Volume_Value
																lcall Menu_Beep
																ret
								toggle_players:	lcall Player_toggle					;When PB2 pressed toggle players and display status on LCD and LEDs
																ret
								toggle_speed:		lcall Speed_toggle					;When PB3 pressed toggle speed settings and display status on LCD and LEDs
																ret
								toggle_volume:	lcall Volume_toggle					;When PB6 pressed toggle volume and display on LCD
																ret
								Sudden_death:		lcall LCD_line2							;When PB5 pressed toggle sudden death mode and display status on LCD
																mov A, Max_score
																cjne A, #0FH, SD_off
																mov Max_Score, #01H					;If activated sudden death sets the win score to 1
																mov DPTR, #Sudden_death_on_string
																lcall LCD_string
																lcall Menu_Beep
																ret
											SD_off:		mov Max_Score, #0FH
																mov	DPTR, #Sudden_death_off_string
																lcall LCD_string
																lcall Menu_Beep
																ret														

		S2_Actions:							;P1 serve state allowable actions: Serve, Return to settings.
								jnb 00H, P1_Serve
								jnb 03H, Back
								ret
								P1_Serve:	lcall LCD_clr
													mov DPTR, #Play_string
													lcall LCD_string
													lcall LCD_points
													mov State, #3
													clr 08H			;Clear bit to to determine serve vs return ball
													ret
								Back:			lcall Stop
													ret
													
		S3_Actions:							;
								jnb 04H, S3_Pause			;If PB4 has been pressed, jump to pause state
								jnb 03H, S3_Stop
								INC State
								ret
								S3_Pause:	lcall Pause
													ret		;Change state to #19 (the pause state) and return to the main loop
								S3_Stop:		lcall Stop
														ret

		S4_Actions:												;Pause or stop if required, else increment state and return to main loop
								jnb 04H, S4_Pause
								jnb 03H, S4_Stop
								jnb 08H, Serve_1			;If bit 08H is clear then this is the serve (ie, no input required to send ball to other end)
								jb 00H, P1_Miss				;If no input from button 1, jump to Player 1 Miss routine
			Serve_1:	setb 08H							;Reset the serve indicator so that the next time this state is reached the player must use PB1 to return "ball"
								lcall P1_Sound
								INC State
								ret
								S4_Pause:	lcall Pause
													ret
								S4_Stop:	lcall Stop
													ret
								P1_Miss:	mov State, #18		;Change state to #18 (the player 2 win/player 1 miss state) and return to main loop
													ret

		S5_Actions:												;Pause or stop if required, else increment state and return to main loop
								jnb 04H, S5_Pause
								jnb 03H, S5_Stop
								INC State
								ret
								S5_Pause:	lcall Pause
													ret
								S5_Stop:		lcall Stop
														ret

		S6_Actions:												;Pause or stop if required, else increment state and return to main loop
								jnb 04H, S6_Pause
								jnb 03H, S6_Stop
								INC State
								ret
								S6_Pause:	lcall Pause
													ret
								S6_Stop:		lcall Stop
														ret

		S7_Actions:												;Pause or stop if required, else increment state and return to main loop
								jnb 04H, S7_Pause
								jnb 03H, S7_Stop
								INC State
								ret
								S7_Pause:	lcall Pause
													ret
								S7_Stop:		lcall Stop
														ret

		S8_Actions:												;Pause or stop if required, else increment state and return to main loop
								jnb 04H, S8_Pause
								jnb 03H, S8_Stop
								INC State
								ret
								S8_Pause:	lcall Pause
													ret
								S8_Stop:	lcall Stop
													ret

		S9_Actions:												;Pause or stop if required, else increment state and return to main loop
								jnb 04H, S9_Pause
								jnb 03H, S9_Stop
								INC State
								ret
								S9_Pause:	lcall Pause
													ret
								S9_Stop:	lcall Stop
													ret

		S10_Actions:												;Pause or stop if required, else increment state and return to main loop
								jnb 04H, S10_Pause
								jnb 03H, S10_Stop
								jb 0FH, P2_Active				;If P2 active check if they are cheating
								INC State
								ret
								S10_Pause:	lcall Pause
														ret
								S10_Stop:		lcall Stop
														ret
								P2_Active:	jnb 07H, P2_Hold
														INC State
														ret
										P2_Hold:mov State, #17
														ret

		S11_Actions:												;Pause or stop if required, else increment state and return to main loop
								jnb 04H, S11_Pause
								jnb 03H, S11_Stop
								jb 0FH, Player_2_Active	;If config byte states that P2 is active check for P2 input
								lcall P2_Sound
								INC State
								ret
								S11_Pause:	lcall Pause
														ret
								S11_Stop:		lcall Stop
														ret
								Player_2_Active:	jnb 09H, Serve_2
																	jb 07H, P2_Miss
											Serve_2:		setb 09H
																	lcall P2_Sound
																	INC State
																	ret
											P2_Miss:		mov State, #17
																	ret		

		S12_Actions:												;Pause or stop if required, else increment state and return to main loop
								jnb 04H, S12_Pause
								jnb 03H, S12_Stop
								INC State
								ret
								S12_Pause:	lcall Pause
														ret
								S12_Stop:		lcall Stop
														ret

		S13_Actions:												;Pause or stop if required, else increment state and return to main loop
								jnb 04H, S13_Pause
								jnb 03H, S13_Stop
								INC State
								ret
								S13_Pause:	lcall Pause
														ret
								S13_Stop:		lcall Stop
														ret

		S14_Actions:												;Pause or stop if required, else increment state and return to main loop
								jnb 04H, S14_Pause
								jnb 03H, S14_Stop
								INC State
								ret
								S14_Pause:	lcall Pause
														ret
								S14_Stop:		lcall Stop
														ret

		S15_Actions:												;Pause or stop if required, else increment state and return to main loop
								jnb 04H, S15_Pause
								jnb 03H, S15_Stop
								INC State
								ret
								S15_Pause:	lcall Pause
														ret
								S15_Stop:		lcall Stop
														ret

		S16_Actions:												;Pause or stop if required, else increment state and return to main loop
								jnb 04H, S16_Pause
								jnb 03H, S16_Stop
								INC State
								ret
								S16_Pause:	lcall Pause
														ret
								S16_Stop:		lcall Stop
														ret

		S17_Actions:												;Pause or stop if required, else increment state and return to main loop
								jnb 04H, S17_Pause
								jnb 00H, P1_Hold				;Check to ensure player 1 is not cheating by holding their button
								mov State, #3
								ret
								S17_Pause:	lcall Pause
														ret
								P1_Hold:		mov State, #18
														ret

		S18_Actions:
								;No actions taken in point states
		S19_Actions:
								;No actions taken in point states

		S20_Actions:												;Unpause or stop if required, else stay in this state
								jnb 04H, Unpause
								jnb 03H, Quit
								ret
								Unpause: 	mov State, 2
													mov P2, R3
													mov A, #80H
													lcall LCD_cmd							;Return LCD to display play state string
													mov DPTR, #Play_string
													lcall LCD_string
													ret
								Quit: 		lcall Stop
													ret

		S21_Actions:												;End game when required
								jnb 03H, End_Game
								ret
								End_Game:	lcall Stop
													ret

		S22_Actions:																		;Begin play from state 11, or quit if required
								jnb 07H, P2_Serve
								jnb 03H, Back2
								ret
								P2_Serve:	lcall LCD_clr							;Return LCD to display play state string
													mov DPTR, #Play_string
													lcall LCD_string
													lcall LCD_points
													mov State, #10
													clr 09H
													ret
								Back2:		lcall Stop
													ret

	Ball_Right:				;Routine to move the light one position to the right
				mov A, P2
				rl A
				mov P2, A
			ret

	Ball_Left:				;Routine to move light one position to the left
				mov A, P2
				rr A
				mov P2, A
			ret

	Display_Score:		;Routine to reverse the byte that contains the score, allowing it to be displayed correctly on the LEDs
				mov A, Score
				rlc A
				mov 10H, C
				rlc A
				mov 11H, C
				rlc A
				mov 12H, C
				rlc A
				mov 13H, C
				rlc A
				mov 14H, C
				rlc A
				mov 15H, C
				rlc A
				mov 16H, C
				rlc A
				mov 17H, C
				clr C
				mov P2, Score_Rev
			ret				

	Button_Status:	;Subroutine to take any input from the push buttons and save it into bit-addressable memory for reference (byte 20H)
								mov R0, P1
								cjne R0, #0FFH, Input		;If button status is not FF (ie, if a button is being pressed) jump to input line, else return
								ret
				Input: 	mov Inpt, R0							;Send button status to byte 20H in bit-addressable memory IF any button is pressed
								ret

	
				
		Pause:				;Subroutine to save current state/status into R2 and enter pause state
						mov 2, State
						mov State, #19
						mov A, #80H
						lcall LCD_cmd
						lcall Menu_beep
						mov DPTR, #Pause_string
						lcall LCD_string
						ret

		Stop:					;Subroutine to reset any flags, and return the current config to the LEDs then return to the "stop" state
						setb 08H
						setb 09H
						mov State, #0
						mov P2, Confg
						lcall Menu_beep
						lcall LCD_clr
						mov DPTR, #Stop_string
						lcall LCD_string
						ret
;---------------Config Subroutines---------------
	Player_Toggle:													;Subroutine to toggle number of players and display status on LCD/LEDs
								lcall LCD_line2
								mov DPTR, #Player_string
								lcall LCD_string
								mov A, #0C9H
								lcall LCD_cmd
								cpl P2.7									;If PB2 is pressed, toggle LD8
								jnb P2.7, display_1
								mov A, #'2'
								lcall LCD_dat
								lcall Menu_Beep
								ret
		display_1:	mov A, #'1'
								lcall LCD_dat
								lcall Menu_Beep
								ret

	Speed_Toggle:													;Subroutine to toggle speed settings and display status on LCD
							lcall LCD_line2
							mov DPTR, #Speed_string
							lcall LCD_string
							mov A, #0C7H
							lcall LCD_cmd
							jnb 18H, Score_Dec				;Increment and then decrement lights in accordance to speed setting when PB3 is pressed
							jnb P2.2, Spd_2
							jnb P2.3, Spd_3
							jnb P2.4, Spd_4
							jnb P2.5, Spd_5
							jnb P2.6, Spd_6
		Score_Dec:jb P2.6, Spd_6
							jb P2.5, Spd_5
							jb P2.4, Spd_4
							jb P2.3, Spd_3
							jb P2.2, Spd_2
							ret
							Spd_2:	cpl P2.2
											setb 18H
											lcall Menu_Beep
											jnb P2.2, Disp_S1
											mov A, #'2'
											lcall LCD_dat
											ret
							Disp_S1:mov A, #'1'
											lcall LCD_dat
											ret
							Spd_3:	cpl P2.3
											lcall Menu_Beep
											jnb P2.3, Disp_S2
											mov A, #'3'
											lcall LCD_dat
											ret
							Disp_S2:mov A, #'2'
											lcall LCD_dat
											ret
							Spd_4:	cpl P2.4
											lcall Menu_Beep
											jnb P2.4, Disp_S3
											mov A, #'4'
											lcall LCD_dat
											ret
							Disp_S3:mov A, #'3'
											lcall LCD_dat
											ret
							Spd_5:	cpl P2.5
											lcall Menu_Beep
											jnb P2.5, Disp_S4
											mov A, #'5'
											lcall LCD_dat
											ret
							Disp_S4:mov A, #'4'
											lcall LCD_dat
											ret
							Spd_6:	cpl P2.6
											clr 18H
											lcall Menu_Beep
											jnb P2.6, Disp_S5
											mov A, #'6'
											lcall LCD_dat
											ret
							Disp_S5:mov A, #'5'
											lcall LCD_dat
											ret

	Volume_Toggle:													;Subroutine to toggle the volume setting, and save the chosen setting to the Snd_Cfg byte, and display current status on LCD
						lcall LCD_line2
						mov DPTR, #Volume_string
						lcall LCD_string
						mov A, #0C8H
						lcall LCD_cmd
						jnb 19H, Vol_Dec
						jnb 1BH, Vol_2
						jnb 1CH, Vol_3
						jnb 1DH, Vol_4
						jnb 1EH, Vol_5
						jnb 1FH, Vol_6
		Vol_Dec:jb 1FH, Vol_6
						jb 1EH, Vol_5
						jb 1DH, Vol_4
						jb 1CH, Vol_3
						jb 1BH, Vol_2
						ret
						Vol_2:	cpl 1BH
										setb 19H
										lcall Menu_Beep
										jnb 1BH, Disp_V1
										mov A, #'2'
										lcall LCD_dat
										ret
						Disp_V1:mov A, #'1'
										lcall LCD_dat
										ret
						Vol_3:	cpl 1CH
										lcall Menu_Beep
										jnb 1CH, Disp_V2
										mov A, #'3'
										lcall LCD_dat
										ret
						Disp_V2:mov A, #'2'
										lcall LCD_dat
										ret
						Vol_4:	cpl 1DH
										lcall Menu_Beep
										jnb 1DH, Disp_V3
										mov A, #'4'
										lcall LCD_dat
										ret
						Disp_V3:mov A, #'3'
										lcall LCD_dat
										ret
						Vol_5:	cpl 1EH
										lcall Menu_Beep
										jnb 1EH, Disp_V4
										mov A, #'5'
										lcall LCD_dat
										ret
						Disp_V4:mov A, #'4'
										lcall LCD_dat
										ret
						Vol_6:	cpl 1FH
										clr 19H
										lcall Menu_Beep
										jnb 1FH, Disp_V5
										mov A, #'6'
										lcall LCD_dat
										ret
						Disp_V5:mov A, #'5'
										lcall LCD_dat
										ret

;----------Sound Related Subroutines----------;

	Get_Volume_Value:						;Subroutine that uses the audio config byte (23H) to determine the volume setting.
				jb 1AH, Mute
				jb 1FH, Volume_6
				jb 1EH, Volume_5
				jb 1DH, Volume_4
				jb 1CH, Volume_3
				jb 1BH, Volume_2
				mov A, #0
				mov DPTR, #Volume_Value	;Delay value retrieved from lookup table
				movc A, @A+DPTR
				mov Vol, A
				ret
				Volume_2:	mov A, #1
									mov DPTR, #Volume_Value
									movc A, @A+DPTR
									mov Vol, A
									ret
				Volume_3:	mov A, #2
									mov DPTR, #Volume_Value
									movc A, @A+DPTR
									mov Vol, A
									ret
				Volume_4: mov A, #3
									mov DPTR, #Volume_Value
									movc A, @A+DPTR
									mov Vol, A
									ret
				Volume_5: mov A, #4
									mov DPTR, #Volume_Value
									movc A, @A+DPTR
									mov Vol, A
									ret
				Volume_6: mov A, #5
									mov DPTR, #Volume_Value
									movc A, @A+DPTR
									mov Vol, A
									ret
				Mute:			mov Vol, #0
									ret

	P1_Sound:											;Subroutine to play sound when P1 "hits ball"
					mov R3, #070H
	Sound1:	mov DAC0H, Vol
					call P1_Freq
					mov DAC0H, #0
					call P1_Freq
					djnz R3, Sound1
					ret

	P1_Freq:											;Delay subroutine to determine frequency of P1_Sound
				F1Loop2:	mov R7, #02h	
				F1Loop1: 	mov R6, #03h
				F1Loop0: 	mov R5, #80h
        					djnz R5, $
        					djnz R6, F1Loop0
        					djnz R7, F1Loop1
		ret
	
	P2_Sound:											;Subroutine to play sound when P2 "hits ball"
					mov R3, #070H
	Sound2:	mov DAC0H, Vol
					call P2_Freq
					mov DAC0H, #0
					call P2_Freq
					djnz R3, Sound2
					ret

	P2_Freq:											;Delay subroutine to determine frequency of P2_sound
				F2Loop2:	mov R7, #02h	
				F2Loop1: 	mov R6, #03h
				F2Loop0: 	mov R5, #098h
        					djnz R5, $
        					djnz R6, F2Loop0
        					djnz R7, F2Loop1
		ret

	Menu_Beep:										;Subroutine to play standard menu beep (called when any option is toggled in the menu)
					mov R3, #20H
	Beep:		mov DAC0H, Vol
					call Beep_Freq
					mov DAC0H, #0
					call Beep_Freq
					djnz R3, Beep
					ret

	Beep_Freq:										;Delay subroutine to determine frequency of Menu_Beep
				F3Loop2:	mov R7, #01h	
				F3Loop1: 	mov R6, #03h
				F3Loop0: 	mov R5, #00h
        					djnz R5, $
        					djnz R6, F3Loop0
        					djnz R7, F3Loop1
		ret

	Score_Beep:										;Subroutine to play sound when a point is scored
					mov R3, #20H
	SBeep:	mov DAC0H, Vol
					call SBeep_Freq
					mov DAC0H, #0
					call SBeep_Freq
					djnz R3, SBeep
					ret

	SBeep_Freq:										;delay subroutine to determine frequency of Score_Beep
				F4Loop2:	mov R7, #010h	
				F4Loop1: 	mov R6, #02h
				F4Loop0: 	mov R5, #00h
        					djnz R5, $
        					djnz R6, F4Loop0
        					djnz R7, F4Loop1
		ret

;----------LCD Subroutines----------

	LCD_Reset:												;Subroutine runs initialisation sequence for the LCD (delays allow time for the LCD to process commands
				lcall LCD_Init_Delay
				mov LCD_Data, #0FFh
				lcall LCD_Init_Delay
				mov LCD_Data, #43h					;Format set 1
				mov LCD_Data, #03h
				lcall LCD_Init_Delay
				mov LCD_Data, #43h					;Format set 2
				mov LCD_Data, #03h
				lcall LCD_Init_Delay
				mov LCD_Data, #43h					;Format set 3
				mov LCD_Data, #03h
				lcall LCD_Init_Delay
				mov LCD_Data, #42h					;Actual format set to recieve 4 bit input rather than default 8
				mov LCD_Data, #02h
				lcall LCD_Init_Delay
			ret

	LCD_cmd:													;Take 8-bit command stored in accumulator and run it 4-bit at a time
				mov temp, A									;Store command
				swap A											;Swap and bitmask to retrieve upper nibble (first half of command)
				anl A, #0FH
				add A, #40H									;Set enable
				mov LCD_Data, A							;Move command into P3
				mov A, temp									;Grab upper nibble of command again, this time leaving the enable clear
				anl A, #0FH									
				mov LCD_Data, A							;Send to P3, clearing enable and triggering the LCD to read the command
				
				mov A, temp									;Repeat above with the lower nibble, getting the second half of the command
				anl A, #0FH
				add A, #40H
				mov LCD_Data, A
				mov A, temp
				anl A, #0FH
				mov LCD_Data, A
				lcall LCD_Delay
				ret

	LCD_dat:													;Take 8-bit data value stored in accumulator and write it to LCD 4-bit at a time
				mov temp, A									;Same as LCD_cmd function, but also setting RS flag upon writing data, telling the LCD that this is not a command
				swap A
				anl A, #0FH
				add A, #050H
				mov LCD_Data, A
				nop
				clr LCD_EN

				mov A, temp
				anl A, #0FH
				add A, #050H
				mov LCD_Data, A
				nop
				clr LCD_EN

				lcall LCD_Delay

				ret

	LCD_string:												;Subroutine to take the string at the location stored in DPTR and write it to the LCD
			clr A													;Clear accumulator to avoid any offset in movc command
			movc A, @A+DPTR								;Move the ASCII value of char at DPTR location to A
			jz end_string									;End routine if end of string marker found (00H)
			lcall LCD_dat									;Print current ASCII char to LCD
			INC DPTR											;Increment DPTR to next character
			sjmp LCD_string								;Loop till end of string
		end_string:
			ret

	LCD_points:												;Subroutine to display the current scores of both players at either end of the second line of the LCD
			lcall LCD_line2								;Set cursor to start of line 2
			mov A, Score									;Retrieve value of P1 score and store in A
			swap A
			anl A, #0FH
			rl A													;Rotate A left (each score string is 2 bytes long)
			mov temp, A										;Store A in R0 and push to stack (as R0 is used by LCD_dat)
			push 0
			mov DPTR, #Points							;Set DPTR to point at "points" string and set the appropriate offset
			movc A, @A+DPTR								;Get ASCII value of first score character and print to screen
			lcall LCD_dat
			pop 0													;Retrieve value of offset from the stack and increment it to grab second character of score string
			mov A, temp
			INC A
			movc A, @A+DPTR
			lcall LCD_dat									;Print second character of score string
			mov A, #0CEH									;Move cursor to second last position of line 2 and repeat above with P2 score
			lcall LCD_cmd
			mov A, Score
			anl A, #0FH
			rl A
			mov temp, A
			push 0
			movc A, @A+DPTR
			lcall LCD_dat
			pop 0
			mov A, temp
			INC A
			movc A, @A+DPTR
			lcall LCD_dat
			ret


	LCD_clr:													;Clear LCD and reset cursor (set to address 80H)
			mov A, #01H
			lcall LCD_cmd
			mov A, #80H
			lcall LCD_cmd
			ret

	LCD_line2:												;Set cursor to start of line 2 (address 0C0H)
			mov A, #0C0H
			lcall LCD_cmd
			ret

;--------------------------------Lookup Table--------------------------------------
Delay_Value: db 10H,0DH,0AH,07H,04H,01H						;Values to be used in Delay routine depending on speed setting
Volume_Value: db 20H,40H,60H,80H,0B0H,0FFH				;Values to be used in DAC to provide variable voltage in the piezo and thus variable amplitude

;-----------------------------------Strings----------------------------------------
Start_string1: db "1D PONG GOTY Ed.",00H					;Strings used in "start" state
Start_string2: db " Push to start",00H
Clear_line: db "                ",00H							;String to clear one line of the LCD
Stop_string: db "Configure:",00H									;String for config/stop state
Play_string: db "------Play------",00H						;String for line 1 of LCD in play state
P1_point_string: db "P1 wins point!",00H					;Strings for score states
P2_point_string: db "P2 wins point!",00H
P1_serve_string: db "P1 to serve",00H							;Strings for serve states
P2_serve_string: db "P2 to serve",00H
Player_string: db "Players:        ",00H					;Strings for line 2 of config state
Speed_string: db "Speed:          ",00H
Volume_string: db "Volume:         ",00H
Sudden_death_on_string: db "Sudden Death:On ",00H
Sudden_death_off_string: db "Sudden Death:Off",00H
Mute_on_string: db "Mute: On        ",00H
Mute_off_string: db "Mute: Off       ",00H
Pause_string:	db "-----Pause------",00H						;String for pause state
Game_over_string: db "GAME OVER",00H							;Strings for game over state
P1_win_string: db "PLAYER ONE WINS!",00H
P2_win_string: db "PLAYER TWO WINS!",00H
Points: db ' 0',' 1',' 2',' 3',' 4',' 5',' 6',' 7',' 8',' 9','10','11','12','13','14','15' ;Strings of the various possible scores

END
