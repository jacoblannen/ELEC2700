$INClude (c8051f120.INC) ; Includes register definition file
;-----------------------------------------------------------------------------
; EQUATES
;-----------------------------------------------------------------------------
	Score				equ				R1
	State				equ				R4

	org 0000H
		ljmp Start 													; Locate a jump to the start of code at
	org 0100H
;-----------------------------------------------------------------------------
; Initialisation for Peripheral Board
;-----------------------------------------------------------------------------
	Start: 	mov WDTCN, #0DEh
        	mov WDTCN, #0ADh
        	mov SFRPAGE, #CONFIG_PAGE 		; Use SFRs on the Configuration Page
        	mov P0MDOUT, #00000000b 			; Inputs
        	mov P1MDOUT, #00000000b 			; Inputs
        	mov P2MDOUT, #11111111b 			; Outputs
        	mov XBR2, #40h								; Enable the Port I/O Crossbar
;--------------------------------- Initialisation---------------------------------------
;Add your assembly code in this section to:
;Initialise internal variables eg State
;etc
	mov 	State, #0
	mov 	Score, #0
	mov 	20H, #0FFH
	mov 	21H, #0	
	mov 	22H, #0
	setb	18H
	mov		P2, #00000011b

;--------------------------------- Main Loop-------------------------------------------
;Add your assembly code in this section to implement the State Machine

	Main_loop:
							mov 20H, #0FFH
							mov A, State	; Shift current state into accumulator
							rl A	; Mystery instruction: Hint: ajmp is 2 bytes long in code memory
							mov	DPTR, #State_table
							jmp @A+DPTR
	State_table:
							ajmp State_1	;Stop state
							ajmp State_2	;Pre-game state (waiting for Player 1 to serve)
							ajmp State_3	;Ball initialised to LD1
							ajmp State_4	;Ball move right to LD2
							ajmp State_5	;Ball move right to LD3
							ajmp State_6	;Ball move right to LD4
							ajmp State_7	;Ball move right to LD5
							ajmp State_8	;Ball move right to LD6
							ajmp State_9	;Ball move right to LD7
							ajmp State_10	;Ball move right to LD8
							ajmp State_11	;Ball move left to LD7
							ajmp State_12	;Ball move left to LD6
							ajmp State_13	;Ball move left to LD5
							ajmp State_14	;Ball move left to LD4
							ajmp State_15	;Ball move left to LD3
							ajmp State_16	;Ball move left to LD2
							ajmp State_17	;Ball move left to LD1
							ajmp State_18	;P1 Scores
							ajmp State_19	;P2 Scores
							ajmp State_20	;Pause state
							ajmp State_21	;Lose state
							ajmp State_22	;P2 Serves
	State_1:
					mov Score, #0
					lcall Button_Check
					lcall Action
					ajmp 	Main_loop
	
	State_2:	;Ball initialised to LD1, waiting for player to serve
					mov P2, #00000001b
					lcall Button_Check
					lcall Action
					ajmp Main_Loop

	State_3:	;Ball initialised to LD1
					lcall Button_Check
					lcall Action
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
					clr C
					mov A, Score
					add A, #00010000b
					mov Score, A
					anl A, #11110000b
		Flash1:	mov P2, #00000001b
						lcall Flash_Delay
						mov P2, #0
						lcall Flash_Delay
						subb A, #00010000b
						jnz Flash1
					mov A, Score
					add A, #00010000b
					jb PSW.7, Lose1
					mov State, #21				;Jump to P2 serve state.
					ajmp Main_Loop
		Lose1:clr C
					mov State, #20
					ajmp Main_Loop

	State_19:	;P2 Scores
					clr C
					mov A, Score
					add A, #00000001b
					mov Score, A
					anl A, #1111b
		Flash2:	mov P2, #10000000b
						lcall Flash_Delay
						mov P2, #0
						lcall Flash_Delay
						subb A, #00000001b
						jnz Flash2
					mov A, Score
					subb A, #0FH
					jz Lose2
					mov State, #1				;Return state to "pre-game" state
					ajmp Main_Loop
		Lose2:clr 0D6H
					mov State, #20
					ajmp Main_Loop

	State_20:	;Pause State
					mov R3, P2
	Pause_Loop:				
					lcall Display_Score
					lcall Button_Check
					lcall Action
					cjne R4, #19, Resume
					sjmp Pause_Loop
	Resume:	
					ajmp Main_Loop

	State_21: ;Game Over State
					lcall Display_Score
					lcall Button_Check
					lcall Action
					cjne R4, #0, State_21
					mov P2, 021H
					ajmp Main_Loop

	State_22:	;P2 Serves the ball
					mov P2, #10000000b
					lcall Button_Check
					lcall Action
					lcall Main_Loop

;--------------------------------- Functions---------------------------------------
;Add your assembly code functions for various tasks in this section


	Ball_Right:				;Routine to move the light one position to the right
				mov A, P2
				rl A
				mov P2, A
			ret

	Ball_Left:
				mov A, P2
				rr A
				mov P2, A
			ret

	Display_Score:
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

	Button_Check:								;Standard debouncing button check loop. Used in states with non-variable delays (ie pause, stop, serve)
			BLoop2:		mov R7, #09H	
			BLoop1: 	mov R6, #00h
			BLoop0: 	mov R5, #00h
      					lcall Button_Status
								djnz R5, $
       					djnz R6, BLoop0
        				djnz R7, BLoop1
			ret

	Delay: 											;Variable Delay using subroutine "Get_Delay_Value" to set the correct delay for the selected speed setting
				lcall Get_Delay_Value
				Loop2:	mov R7, A	
				Loop1: 	mov R6, #00h
				Loop0: 	mov R5, #00h
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

	Flash_Delay:		;Delay of approx 500ms to facilitate a flash of 1Hz when scores are displayed
				FLoop2:		mov R7, #09h	
				FLoop1: 	mov R6, #00h
				FLoop0: 	mov R5, #00h
        					djnz R5, $
        					djnz R6, FLoop0
        					djnz R7, FLoop1
		ret
	
	Button_Status:	;Subroutine to take any input from the push buttons and save it into bit-addressable memory for reference (byte 20H)
								mov R0, P1
								cjne R0, #0FFH, Input		;If button status is not FF (ie, if a button is being pressed) jump to input line, else return
								ret
				Input: 	mov 20H, R0							;Send button status to byte 21H in bit-addressable memory IF any button is pressed
								ret

	
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
								jnb 01H, Player_Toggle
								jnb 02H, Speed_Toggle
								jnb 03H, Play
								ret
								Player_Toggle:	cpl P2.7									;If PB2 is pressed, toggle LD8
																ljmp Reset_Button_Status
								Speed_Toggle:		jnb 18H, Score_Dec				;Increment and then decrement lights in accordance to speed setting when PB3 is pressed
																jnb P2.2, Spd_2
																jnb P2.3, Spd_3
																jnb P2.4, Spd_4
																jnb P2.5, Spd_5
																jnb P2.6, Spd_6
										Score_Dec:	jb P2.6, Spd_6
																jb P2.5, Spd_5
																jb P2.4, Spd_4
																jb P2.3, Spd_3
																jb P2.2, Spd_2
																ljmp Reset_Button_Status
																Spd_2:	cpl P2.2
																				setb 18H
																				ljmp Reset_Button_Status
																Spd_3:	cpl P2.3
																				ljmp Reset_Button_Status
																Spd_4:	cpl P2.4
																				ljmp Reset_Button_Status
																Spd_5:	cpl P2.5
																				ljmp Reset_Button_Status
																Spd_6:	cpl P2.6
																				clr 18H
																				ljmp Reset_Button_Status
								Play:						mov 21H, P2								;When PB4 is pressed, save the current byte in P2 into the config byte (21H)
																INC State									;Increment the state value to enter play state
																ljmp Reset_Button_Status


		S2_Actions:							;P1 serve state allowable actions: Serve, Return to settings.
								jnb 00H, P1_Serve
								jnb 03H, Back
								ret
								P1_Serve:	mov State, #3
													clr 08H			;Clear bit to to determine serve vs return ball
													ljmp Reset_Button_Status
								Back:			dec State
													mov P2, 21H
													ljmp Reset_Button_Status
													
		S3_Actions:
								jnb 04H, S3_Pause			;If PB4 has been pressed, jump to pause state
								INC State
								ljmp Reset_Button_Status
								S3_Pause:	mov 2, State			;Store current state in 2 (cant use stack as the "ret" function will change the SP value)
													mov State, #19		;Change state to #19 (the pause state) and return to the main loop
													ljmp Reset_Button_Status

		S4_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S4_Pause
								jnb 08H, Serve_1			;If bit 08H is clear then this is the serve (ie, no input required to send ball to other end)
								jb 00H, P1_Miss				;If no input from button 1, jump to Player 1 Miss routine
			Serve_1:	setb 08H							;Reset the serve indicator so that the next time this state is reached the player must use PB1 to return "ball"
								INC State
								ljmp Reset_Button_Status
								S4_Pause:	mov 2, State
													mov State, #19
													ljmp Reset_Button_Status
								P1_Miss:	mov State, #18		;Change state to #18 (the player 2 win/player 1 miss state) and return to main loop
													ljmp Reset_Button_Status

		S5_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S5_Pause
								INC State
								ljmp Reset_Button_Status
								S5_Pause:	mov 2, State
													mov State, #19
													ljmp Reset_Button_Status

		S6_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S6_Pause
								INC State
								ljmp Reset_Button_Status
								S6_Pause:	mov 2, State
													mov State, #19
													ljmp Reset_Button_Status

		S7_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S7_Pause
								INC State
								ljmp Reset_Button_Status
								S7_Pause:	mov 2, State
													mov State, #19
													ljmp Reset_Button_Status

		S8_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S8_Pause
								INC State
								ljmp Reset_Button_Status
								S8_Pause:	mov 2, State
													mov State, #19
													ljmp Reset_Button_Status

		S9_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S9_Pause
								INC State
								ljmp Reset_Button_Status
								S9_Pause:	mov 2, State
													mov State, #19
													ljmp Reset_Button_Status

		S10_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S10_Pause
								jnb 07H, P2_Hold
								INC State
								ljmp Reset_Button_Status
								S10_Pause:	mov 2, State
														mov State, #19
														ljmp Reset_Button_Status
								P2_Hold:		mov State, #17
														ljmp Reset_Button_Status

		S11_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S11_Pause
								jb 0FH, Player_2_Active
								INC State
								ljmp Reset_Button_Status
								S11_Pause:				mov 2, State
																	mov State, #19
																	ljmp Reset_Button_Status
								Player_2_Active:	jnb 09H, Serve_2
																	jb 07H, P2_Miss
											Serve_2:		setb 09H
																	INC State
																	ljmp Reset_Button_Status
											P2_Miss:		mov State, #17
																	ljmp Reset_Button_Status		

		S12_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S12_Pause
								INC State
								ljmp Reset_Button_Status
								S12_Pause:	mov 2, State
														mov State, #19
														ljmp Reset_Button_Status

		S13_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S13_Pause
								INC State
								ljmp Reset_Button_Status
								S13_Pause:	mov 2, State
														mov State, #19
														ljmp Reset_Button_Status

		S14_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S14_Pause
								INC State
								ljmp Reset_Button_Status
								S14_Pause:	mov 2, State
														mov State, #19
														ljmp Reset_Button_Status

		S15_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S15_Pause
								INC State
								ljmp Reset_Button_Status
								S15_Pause:	mov 2, State
														mov State, #19
														ljmp Reset_Button_Status

		S16_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S16_Pause
								INC State
								ljmp Reset_Button_Status
								S16_Pause:	mov 2, State
														mov State, #19
														ljmp Reset_Button_Status

		S17_Actions:												;Pause if required, else increment state and return to main loop
								jnb 04H, S17_Pause
								jnb 00H, P1_Hold
								mov State, #3
								ljmp Reset_Button_Status
								S17_Pause:	mov 2, State
														mov State, #19
														ljmp Reset_Button_Status
								P1_Hold:		mov State, #18
														ljmp Reset_Button_Status

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
													ljmp Reset_Button_Status
								Quit: 		mov State, #0
													setb 08H
													setb 09H
													mov P2, 21H
													ljmp Reset_Button_Status

		S21_Actions:
								jnb 03H, End_Game
								ret
								End_Game:	mov State, #0
													setb 08H
													setb 09H
													mov P2, 21H
													ljmp Reset_Button_Status

		S22_Actions:
								jnb 07H, P2_Serve
								jnb 03H, Back2
								ret
								P2_Serve:	mov State, #10
													clr 09H
													ljmp Reset_Button_Status
								Back2:		mov State, #0
													setb 08H
													setb 09H
													mov P2, 21H
													ljmp Reset_Button_Status
		

		Reset_Button_Status:
								mov 20H, #0FFH
								ret
		

;--------------------------------Lookup Table--------------------------------------
; To use this table, in main code use "mov dptr,#Some_Value"
; then move table index value into accumulator, then use "movc a,@a+dptr",
        ; and finally output accumulator to the related output port
Delay_Value: db 10H,0DH,0AH,07H,04H,01H
END
