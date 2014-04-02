$INClude (c8051f120.INC) ; Includes register definition file
;-----------------------------------------------------------------------------
; EQUATES
;-----------------------------------------------------------------------------
	Score				equ				R1
	Time				equ				R3
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
;--------------------------------- Main Loop-------------------------------------------
;Add your assembly code in this section to implement the State Machine
	mov State, #0
	mov Score, #0
	mov SP, #01FH

	Main_loop:
							;..
							;..
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
	State_1:	
						mov 	P2, #00000011b	
						mov 	A, P2
						mov		R0, #5H
	
		Check_players:
						jb 		P1.1, Check_speed
						lcall Debounce
						cpl 	P2.7					
	
		Check_speed:
						jb 		P1.2, Check_ready
						lcall Debounce
						mov		A, P2
						djnz	R0, Incr

		Incr:		rlc		A
						jc		Pla1a
						add		A, #10000000b
		Pla1a:	INC		A
						INC		R0
	
		Check_ready:
						jb 	P1.3, Check_players
						lcall Debounce
;						sjmp 	Check_players
						INC 	State
						ajmp 	Main_loop
	
	State_2:	;Ball initialised to LD1, waiting for player to serve
					mov A, #00000001b	
					mov P2, A
					jnb P1.3, State_1
					jb P1.0, State_2
					INC State
					ajmp Main_Loop

	State_3:	;Ball initialised to LD1
					mov A, #00000001b
					mov P2, A	
					lcall Delay
					jnb P1.4, S3_paus
					INC State
					ajmp Main_Loop
	S3_paus:lcall Debounce
					push 4
					mov State, #19
					ajmp Main_Loop

	State_4:	;Ball move right to LD2
					lcall Ball_Right
					lcall Delay
					jnb P1.4, S4_paus
					INC State
					ajmp Main_Loop
	S4_paus:lcall Debounce
					push 4
					mov State, #19
					ajmp Main_Loop

	State_5:	;Ball move right to LD3
					lcall Ball_Right
					lcall Delay
					jnb P1.4, S5_paus
					INC State
					ajmp Main_Loop
	S5_paus:lcall Debounce
					push 4
					mov State, #19
					ajmp Main_Loop

	State_6:	;Ball move right to LD4
					lcall Ball_Right
					lcall Delay
					jnb P1.4, S6_paus
					INC State
					ajmp Main_Loop	
	S6_paus:push 4
					mov State, #19
					ajmp Main_Loop

	State_7:	;Ball move right to LD5
					lcall Ball_Right
					lcall Delay
					jnb P1.4, S7_paus
					INC State
					ajmp Main_Loop	
	S7_paus:lcall Debounce
					push 4
					mov State, #19
					ajmp Main_Loop

	State_8:	;Ball move right to LD6
					lcall Ball_Right
					lcall Delay
					jnb P1.4, S8_paus
					INC State
					ajmp Main_Loop
	S8_paus:lcall Debounce
					push 4
					mov State, #19
					ajmp Main_Loop

	State_9:	;Ball move right to LD7
					lcall Ball_Right
					lcall Delay
					jnb P1.4, S9_paus
					INC State
					ajmp Main_Loop
	S9_paus:lcall Debounce
					push 4
					mov State, #19
					ajmp Main_Loop

	State_10:	;Ball move right to LD8
					lcall Ball_Right
					lcall Delay
					jnb P1.4, S10_paus
					INC State
					ajmp Main_Loop
	S10_paus:lcall Debounce
					push 4
					mov State, #19
					ajmp Main_Loop

	State_11:	;Ball moving left to LD7
					lcall Ball_Left
					lcall Delay
					jnb P1.4, S11_paus
					INC State
					ajmp Main_Loop
	S11_paus:push 4
					mov State, #19
					ajmp Main_Loop

	State_12:	;Ball moving left to LD6
					lcall Ball_Left
					lcall Delay
					jnb P1.4, S12_paus
					INC State
					ajmp Main_Loop
	S12_paus:push 4
					mov State, #19
					ajmp Main_Loop

	State_13:	;Ball moving left to LD5
					lcall Ball_Left
					lcall Delay
					jnb P1.4, S13_paus
					INC State
					ajmp Main_Loop
	S13_paus:lcall Debounce
					push 4
					mov State, #19
					ajmp Main_Loop

	State_14:	;Ball moving left to LD4
							lcall Ball_Left
							lcall Delay
							jnb P1.4, S14_paus
							INC State
							ajmp Main_Loop
		S14_paus:	lcall Debounce
							push 4
							mov State, #19
							ajmp Main_Loop

	State_15:	;Ball moving left to LD3
					lcall Ball_Left
					lcall Delay
					jnb P1.4, S15_paus
					INC State
					ajmp Main_Loop
	S15_paus:lcall Debounce
					push 4
					mov State, #19
					ajmp Main_Loop

	State_16:	;Ball moving left to LD2
					lcall Ball_Left
					lcall Delay
					jnb P1.4, S16_paus
					INC State
					ajmp Main_Loop
	S16_paus:lcall Debounce
					push 4
					mov State, #19
					ajmp Main_Loop

	State_17:	;Ball moving left to LD1
					lcall Ball_Left
					lcall Delay
					jnb P1.4, S17_paus
					mov State, #3
					ajmp Main_Loop
	S17_paus:lcall Debounce
					push 4
					mov State, #19
					ajmp Main_Loop

	State_18:	;P1 Scores
					;..
					mov A, Score
					add A, #00010000b
					mov Score, A
	Flash1:	mov P2, #00000001b
					lcall Flash_Delay
					mov P2, #0
					subb A, #00010000b
					jz Flash1
					jb 0D7H, Lose1
					mov State, #2				;Return state to "pre-game" state
					ajmp Main_Loop
		Lose1:mov State, #21
					ajmp Main_Loop

	State_19:	;P2 Scores
					;..
					mov A, Score
					add A, #00000001b
					mov Score, A
	Flash2:	mov P2, #10000000b
					lcall Flash_Delay
					mov P2, #0
					subb A, #00000001b
					jz Flash2
					jb 0D6H, Lose2
					mov State, #2				;Return state to "pre-game" state
					ajmp Main_Loop
		Lose2:mov State, #21
					ajmp Main_Loop

	State_20:	;Pause State
					lcall Debounce
					push P2
					lcall Display_Score
					jb P1.4, $
					lcall Debounce
					pop P2
					pop 4
					ajmp Main_Loop

	State_21: ;Lose State
					;..
					;..
					mov State, #1				;Return to "Stop" state
					ajmp Main_Loop

;--------------------------------- Functions---------------------------------------
;Add your assembly code functions for various tasks in this section

	;Pause:
	;			push 4
	;			mov State, #20
	;	ret

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
				mov 00H, C
				rlc A
				mov 01H, C
				rlc A
				mov 02H, C
				rlc A
				mov 03H, C
				rlc A
				mov 04H, C
				rlc A
				mov 05H, C
				rlc A
				mov 06H, C
				rlc A
				mov 07H, C
				clr C
				mov P2, 20H
			ret				

	Debounce:
				DBLoop2:	mov R7, #02h	
				DBLoop1: 	mov R6, #00h
				DBLoop0: 	mov R5, #00h
        				djnz R5, $
        				djnz R6, DBLoop0
        				djnz R7, DBLoop1
		ret

	Delay: ;this is how to generate time delay; modify it to generate X msec delay
				Loop2:	mov R7, #05h	
				Loop1: 	mov R6, #00h
				Loop0: 	mov R5, #00h
        				lcall Button_Status
								cjne R2, #0FFH, Escape
								djnz R5, $
        				djnz R6, Loop0
        				djnz R7, Loop1
				Escape:
		ret

	Flash_Delay:
				FLoop2:		mov R7, #03h	
				FLoop1: 	mov R6, #00h
				FLoop0: 	mov R5, #00h
        					djnz R5, $
        					djnz R6, FLoop0
        					djnz R7, FLoop1
		ret
	
	Button_Status:
				mov R2, P1
			ret

											

;--------------------------------Lookup Table--------------------------------------
; To use this table, in main code use "mov dptr,#Some_Value"
; then move table index value into accumulator, then use "movc a,@a+dptr",
        ; and finally output accumulator to the related output port
Some_Value: db 0,10,0a4h,0b0h,99h,92h,82h,0f8h,80h,098h
END
