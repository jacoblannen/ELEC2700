$INClude (c8051f120.INC) ; Includes register definition file
;-----------------------------------------------------------------------------
; EQUATES
;-----------------------------------------------------------------------------
	Temp				equ				R0
	Score				equ				R1							; Set Score in R1
	State				equ				R4							; Set State in R4
	LCD_Data		equ				P3
	LCD_D7			equ				P3.3
	LCD_RS			equ				P3.4
	LCD_RW			equ				P3.5
	LCD_EN			equ				P3.6


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
	mov 	State, #0												; Initialise game to Stop/Config State
	mov 	Score, #0												; Initialise score to zero
	mov 	20H, #0FFH											; Initialise input byte to default value (#0FFH)
	mov 	21H, #0													; Initialise config byte to zero
	mov 	22H, #0													; Initialise byte used in "score display" subroutine
	mov		P2, #00000011b									;	Initialise LEDs to default config state
	mov 	23H, #00000011b
	mov 	DPTR, #Stop_string							; Initialise LCD screen to display "Configure: " string
	lcall LCD_String


;--------------------------------- Main Loop-------------------------------------------
	Main_loop:
							mov 20H, #0FFH								;Reset input status
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
					mov Score, #00H						;Initialise score to start new game
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
					cjne R4, #4, Pause4
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
					lcall LCD_clr
					mov DPTR, #P1_point_string1
					lcall LCD_string
					lcall LCD_line2
					mov DPTR, #P1_point_string2
					lcall LCD_string
					clr C
					mov A, Score
					add A, #00010000b
					mov Score, A
					subb A, #00010000b
		Flash1:	mov P2, #00000001b
						lcall Flash_Delay
						mov P2, #0
						lcall Flash_Delay
						subb A, #00010000b
						jnb PSW.7, Flash1
						clr PSW.7
					mov A, Score
					add A, #00010000b
					jb PSW.7, Lose1
					lcall LCD_clr
					mov DPTR, #P2_serve_string1
					lcall LCD_string
					lcall LCD_line2
					mov DPTR, #P2_serve_string2
					lcall LCD_string
					mov State, #21				;Jump to P2 serve state.
					ajmp Main_Loop
		Lose1:lcall LCD_clr
					mov DPTR, #Game_over_string
					lcall LCD_string
					lcall LCD_line2
					mov DPTR, #P1_win_string
					lcall LCD_string
					clr C
					mov State, #20
					ajmp Main_Loop

	State_19:	;P2 Scores
					lcall LCD_clr
					mov DPTR, #P2_point_string1
					lcall LCD_string
					lcall LCD_line2
					mov DPTR, #P2_point_string2
					lcall LCD_string
					clr C
					mov A, Score
					add A, #00000001b
					mov Score, A
		Flash2:	mov P2, #10000000b
						lcall Flash_Delay
						mov P2, #0
						lcall Flash_Delay
						anl A, #1111b
						dec A														
						jnz Flash2
					mov A, Score
					subb A, #0FH
					jz Lose2
					lcall LCD_clr
					mov DPTR, #P1_serve_string1
					lcall LCD_string
					lcall LCD_line2
					mov DPTR, #P1_serve_string2
					lcall LCD_string
					mov State, #1				;Return state to "pre-game" state
					ajmp Main_Loop
		Lose2:lcall LCD_clr
					mov DPTR, #Game_over_string
					lcall LCD_string
					lcall LCD_line2
					mov DPTR, #P2_win_string
					lcall LCD_string
					clr 0D6H
					mov State, #20
					ajmp Main_Loop

	State_20:	;Pause State
					mov R3, P2
	Pause_Loop:				
					lcall Display_Score
					lcall Button_Check
					lcall Action
					lcall Feedback_Delay
					cjne R4, #19, Resume
					mov 20H, #0FFH
					sjmp Pause_Loop
	Resume:	
					ajmp Main_Loop

	State_21: ;Game Over State
					lcall Display_Score
					lcall Button_Check
					lcall Action
					lcall Feedback_Delay
					cjne R4, #0, State_21
					mov P2, 021H
					ajmp Main_Loop

	State_22:	;P2 Serves the ball
					mov P2, #10000000b
					lcall Button_Check
					lcall Action
					lcall Feedback_Delay
					cjne R4, #21, Esc
					sjmp State_22
		Esc:	lcall Main_Loop							

;--------------------------------- Functions---------------------------------------
	
	
;----------Initialisation Routines----------	
	Init_Devices:
    call DAC_Init
    call Voltage_Reference_Init
    call LCD_Init
		ret
	
	DAC_Init:
    mov  SFRPAGE,   #DAC0_PAGE
    mov  DAC0CN,    #084h
    ret

	Voltage_Reference_Init:
    mov  SFRPAGE,   #ADC0_PAGE
    mov  REF0CN,    #003h
    ret

	LCD_Init:
		lcall LCD_Reset
		mov A, #28H						;Format: 4-bit input, 2 line, 5x7 font
		lcall LCD_cmd
		mov A, #0CH						;Display on, cursor off
		lcall LCD_cmd
		mov A, #01H						;Clear display
		lcall LCD_cmd
		mov A, #06H						;Input mode: auto inc, no shift
		lcall LCD_cmd
		mov A, #80H						;Reset cursor
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
				lcall Get_Delay_Value
				Loop2:	mov R7, A	
				Loop1: 	mov R6, #0F7h
				Loop0: 	mov R5, #0FEh
      					lcall Button_Status			;Check button status throughout loop, ensuring that if a button is pressed during the delay it is still registered
								djnz R5, $
       					djnz R6, Loop0
        				djnz R7, Loop1
			ret

	Get_Delay_Value:						;Subroutine that uses the config byte (21H) to determine the speed setting, and hence the required delay
				jb 0EH, Speed_6
				jb 0DH, Speed_5
				jb 0CH, Speed_4
				jb 0BH, Speed_3
				jb 0AH, Speed_2
				mov A, #0
				mov DPTR, #Delay_Value	;Delay value retrieved from lookup table
				movc A, @A+DPTR
				ret
				Speed_2: 	mov A, #1
									mov DPTR, #Delay_Value
									movc A, @A+DPTR
									ret
				Speed_3: 	mov A, #2
									mov DPTR, #Delay_Value
									movc A, @A+DPTR
									ret
				Speed_4: 	mov A, #3
									mov DPTR, #Delay_Value
									movc A, @A+DPTR
									ret
				Speed_5: 	mov A, #4
									mov DPTR, #Delay_Value
									movc A, @A+DPTR
									ret
				Speed_6: 	mov A, #5
									mov DPTR, #Delay_Value
									movc A, @A+DPTR
									ret

	Flash_Delay:		;Delay of 500ms to facilitate a flash of 1Hz when scores are displayed
				FLoop2:		mov R7, #08h	
				FLoop1: 	mov R6, #0FCh
				FLoop0: 	mov R5, #0FFh
        					djnz R5, $
        					djnz R6, FLoop0
        					djnz R7, FLoop1
		ret
	
	Feedback_Delay:		;Delay to decrease risk of "double tap"
				FBLoop2:	mov R7, #04h	
				FBLoop1: 	mov R6, #00h
				FBLoop0: 	mov R5, #00h
        					djnz R5, $
        					djnz R6, FBLoop0
        					djnz R7, FBLoop1
		ret
	LCD_Init_Delay:		;Delay of 50ms to allow for all required delays during LCD initialisation
			LCDILoop2:	mov R7, #04h	
			LCDILoop1: 	mov R6, #033h
			LCDILoop0: 	mov R5, #0FDh
        					djnz R5, $
        					djnz R6, LCDILoop0
        					djnz R7, LCDILoop1
		ret

	LCD_Delay:		;Delay of 1ms to allow time for LCD to recieve and write data
			LCDLoop2:		mov R7, #01h	
			LCDLoop1: 	mov R6, #05h
			LCDLoop0: 	mov R5, #0CDh
        					djnz R5, $
        					djnz R6, LCDLoop0
        					djnz R7, LCDLoop1
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


		S1_Actions:					;Allowable actions for State 1: Toggle players, toggle speed, enter play state.
								jnb 01H, toggle_players
								jnb 02H, toggle_speed
								jnb 03H, Play
								jnb 05H, toggle_volume
								jnb 06H, Mute_Toggle
								ret
								Play:						lcall LCD_clr
																mov DPTR, #P1_serve_string1
																lcall LCD_string
																lcall LCD_line2
																mov DPTR, #P1_serve_string2
																lcall LCD_string
																mov 21H, P2								;When PB4 is pressed, save the current byte in P2 into the config byte (21H)
																INC State									;Increment the state value to enter play state
																lcall Menu_Beep
																ret
								Mute_Toggle:		cpl 1AH
																lcall Menu_Beep
																ret
								toggle_players:	lcall Player_toggle
																ret
								toggle_speed:		lcall Speed_toggle
																ret
								toggle_volume:	lcall Volume_toggle
																ret


		S2_Actions:							;P1 serve state allowable actions: Serve, Return to settings.
								jnb 00H, P1_Serve
								jnb 03H, Back
								ret
								P1_Serve:	mov State, #3
													clr 08H			;Clear bit to to determine serve vs return ball
													ret
								Back:			lcall LCD_clr
													mov DPTR, #Stop_string						
													lcall LCD_String
													dec State
													mov P2, 21H
													ret
													
		S3_Actions:
								jnb 04H, S3_Pause			;If PB4 has been pressed, jump to pause state
								jnb 03H, S3_Stop
								INC State
								ret
								S3_Pause:	lcall Pause
													ret		;Change state to #19 (the pause state) and return to the main loop
								S3_Stop:		lcall Stop
														ret

		S4_Actions:												;Pause if required, else increment state and return to main loop
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

		S5_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S5_Pause
								jnb 03H, S5_Stop
								INC State
								ret
								S5_Pause:	lcall Pause
													ret
								S5_Stop:		lcall Stop
														ret

		S6_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S6_Pause
								jnb 03H, S6_Stop
								INC State
								ret
								S6_Pause:	lcall Pause
													ret
								S6_Stop:		lcall Stop
														ret

		S7_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S7_Pause
								jnb 03H, S7_Stop
								INC State
								ret
								S7_Pause:	lcall Pause
													ret
								S7_Stop:		lcall Stop
														ret

		S8_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S8_Pause
								jnb 03H, S8_Stop
								INC State
								ret
								S8_Pause:	lcall Pause
													ret
								S8_Stop:	lcall Stop
													ret

		S9_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S9_Pause
								jnb 03H, S9_Stop
								INC State
								ret
								S9_Pause:	lcall Pause
													ret
								S9_Stop:	lcall Stop
													ret

		S10_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S10_Pause
								jnb 03H, S10_Stop
								jnb 07H, P2_Hold
								INC State
								ret
								S10_Pause:	lcall Pause
														ret
								S10_Stop:		lcall Stop
														ret
								P2_Hold:		mov State, #17

		S11_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S11_Pause
								jnb 03H, S11_Stop
								jb 0FH, Player_2_Active
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

		S12_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S12_Pause
								jnb 03H, S12_Stop
								INC State
								ret
								S12_Pause:	lcall Pause
														ret
								S12_Stop:		lcall Stop
														ret

		S13_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S13_Pause
								jnb 03H, S13_Stop
								INC State
								ret
								S13_Pause:	lcall Pause
														ret
								S13_Stop:		lcall Stop
														ret

		S14_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S14_Pause
								jnb 03H, S14_Stop
								INC State
								ret
								S14_Pause:	lcall Pause
														ret
								S14_Stop:		lcall Stop
														ret

		S15_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S15_Pause
								jnb 03H, S15_Stop
								INC State
								ret
								S15_Pause:	lcall Pause
														ret
								S15_Stop:		lcall Stop
														ret

		S16_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S16_Pause
								jnb 03H, S16_Stop
								INC State
								ret
								S16_Pause:	lcall Pause
														ret
								S16_Stop:		lcall Stop
														ret

		S17_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S17_Pause
								jnb 00H, P1_Hold
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

		S20_Actions:
								jnb 04H, Unpause
								jnb 03H, Quit
								ret
								Unpause: 	mov State, 2
													mov P2, R3
													mov DPTR, #Play_string
													lcall LCD_string
													ret
								Quit: 		lcall Stop
													ret

		S21_Actions:
								jnb 03H, End_Game
								ret
								End_Game:	lcall Stop
													ret

		S22_Actions:
								jnb 07H, P2_Serve
								jnb 03H, Back2
								ret
								P2_Serve:	mov State, #10
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
				mov P2, 22H
			ret				

	Button_Status:	;Subroutine to take any input from the push buttons and save it into bit-addressable memory for reference (byte 20H)
								mov R0, P1
								cjne R0, #0FFH, Input		;If button status is not FF (ie, if a button is being pressed) jump to input line, else return
								ret
				Input: 	mov 20H, R0							;Send button status to byte 20H in bit-addressable memory IF any button is pressed
								ret

	
				
		Pause:	
						mov 2, State
						mov State, #19
						mov DPTR, #Pause_string
						lcall LCD_string
						ret

		Stop:
						setb 08H
						setb 09H
						mov State, #0
						mov P2, 21H
						lcall LCD_clr
						mov DPTR, #Stop_string
						lcall LCD_string
						ret
;---------------Config Subroutines---------------
	Player_Toggle:
								lcall LCD_line2
								mov DPTR, #Player_string
								lcall LCD_string
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

	Speed_Toggle:		
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

	Volume_Toggle:
						
						jnb 19H, Vol_Dec				;Increment and then decrement lights in accordance to speed setting when PB3 is pressed
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
										ret
						Vol_3:	cpl 1CH
										lcall Menu_Beep
										ret
						Vol_4:	cpl 1DH
										lcall Menu_Beep
										ret
						Vol_5:	cpl 1EH
										lcall Menu_Beep
										ret
						Vol_6:	cpl 1FH
										clr 19H
										lcall Menu_Beep


;----------Sound Related Subroutines----------;

	Get_Volume_Value:						;Subroutine that uses the audio config byte (23H) to determine the volume setting.
				jb 1FH, Volume_6
				jb 1EH, Volume_5
				jb 1DH, Volume_4
				jb 1CH, Volume_3
				jb 1BH, Volume_2
				jb 1AH, Mute
				mov A, #0
				mov DPTR, #Volume_Value	;Delay value retrieved from lookup table
				movc A, @A+DPTR
				ret
				Volume_2:	mov A, #1
									mov DPTR, #Volume_Value
									movc A, @A+DPTR
									ret
				Volume_3:	mov A, #2
									mov DPTR, #Volume_Value
									movc A, @A+DPTR
									ret
				Volume_4: mov A, #3
									mov DPTR, #Volume_Value
									movc A, @A+DPTR
									ret
				Volume_5: mov A, #4
									mov DPTR, #Volume_Value
									movc A, @A+DPTR
									ret
				Volume_6: mov A, #5
									mov DPTR, #Volume_Value
									movc A, @A+DPTR
									ret
				Mute:			mov A, #0
									ret

	P1_Sound:
					lcall Get_Volume_Value
					mov R3, #070H
	Sound1:	mov DAC0H, A
					call P1_Freq
					mov DAC0H, #0
					call P1_Freq
					djnz R3, Sound1
					ret

	P1_Freq:		;Delay to decrease risk of "double tap"
				F1Loop2:	mov R7, #01h	
				F1Loop1: 	mov R6, #04h
				F1Loop0: 	mov R5, #00h
        					djnz R5, $
        					djnz R6, F1Loop0
        					djnz R7, F1Loop1
		ret
	
	P2_Sound:
					lcall Get_Volume_Value
					mov R3, #070H
	Sound2:	mov DAC0H, A
					call P2_Freq
					mov DAC0H, #0
					call P2_Freq
					djnz R3, Sound2
					ret

	P2_Freq:		;Delay to decrease risk of "double tap"
				F2Loop2:	mov R7, #01h	
				F2Loop1: 	mov R6, #05h
				F2Loop0: 	mov R5, #00h
        					djnz R5, $
        					djnz R6, F2Loop0
        					djnz R7, F2Loop1
		ret

	Menu_Beep:
					lcall Get_Volume_Value
					mov R3, #20H
	Beep:		mov DAC0H, A
					call Beep_Freq
					mov DAC0H, #0
					call Beep_Freq
					djnz R3, Beep
					ret

	Beep_Freq:		;Delay to decrease risk of "double tap"
				F3Loop2:	mov R7, #01h	
				F3Loop1: 	mov R6, #03h
				F3Loop0: 	mov R5, #00h
        					djnz R5, $
        					djnz R6, F3Loop0
        					djnz R7, F3Loop1
		ret

;----------LCD Subroutines----------

	LCD_Reset:
				lcall LCD_Init_Delay
				mov LCD_Data, #0FFh
				lcall LCD_Init_Delay
				mov LCD_Data, #43h
				mov LCD_Data, #03h
				lcall LCD_Init_Delay
				mov LCD_Data, #43h
				mov LCD_Data, #03h
				lcall LCD_Init_Delay
				mov LCD_Data, #43h
				mov LCD_Data, #03h
				lcall LCD_Init_Delay
				mov LCD_Data, #42h
				mov LCD_Data, #02h
				lcall LCD_Init_Delay
			ret

	LCD_cmd:
				mov temp, A
				swap A
				anl A, #0FH
				add A, #40H
				mov LCD_Data, A
				mov A, temp
				anl A, #0FH
				mov LCD_Data, A
				
				mov A, temp
				anl A, #0FH
				add A, #40H
				mov LCD_Data, A
				mov A, temp
				anl A, #0FH
				mov LCD_Data, A
				lcall LCD_Delay
				ret

	LCD_dat:
				mov temp, A
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

	LCD_string:
			clr A
			movc A, @A+DPTR
			jz end_string
			lcall LCD_dat
			INC DPTR
			sjmp LCD_string
		end_string:
			ret

	LCD_clr:
			mov A, #01H
			lcall LCD_cmd
			mov A, #80H
			lcall LCD_cmd
			ret

	LCD_line2:
			mov A, #0C0H
			lcall LCD_cmd
			ret

;--------------------------------Lookup Table--------------------------------------
Delay_Value: db 10H,0DH,0AH,07H,04H,01H
Volume_Value: db 20H,40H,60H,80H,0B0H,0FFH

;--------------Strings--------------
Stop_string: db "Configure:",00H
Play_string: db "      Play      ",00H
P1_point_string1: db "Player One wins",00H
P1_point_string2: db "point!",00H
P2_point_string1: db "Player Two wins",00H
P2_point_string2: db "point!",00H
P1_serve_string1: db "Player One",00H
P1_serve_string2: db "to serve...",00H
P2_serve_string1: db "Player Two",00H
P2_serve_string2: db "to serve...",00H
Player_string: db "Players: ",00H
Speed_string: db "Speed:          ",00H
Pause_string:	db "    ~Pause~     ",00H
Game_over_string: db "GAME OVER",00H
P1_win_string: db "PLAYER ONE WINS!",00H
P2_win_string: db "PLAYER TWO WINS!",00H

END
