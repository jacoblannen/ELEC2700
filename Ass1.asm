$include (c8051f120.inc)               	; Includes register definition file
;-----------------------------------------------------------------------------
; EQUATES
;-----------------------------------------------------------------------------
State			equ		R4
Delay			equ		R3

	org   0000H
		ljmp  Start              		; Locate a jump to the start of code at 
	org   0100H
;-----------------------------------------------------------------------------
; 			Initialisation for Peripheral Board
;-----------------------------------------------------------------------------
Start: 	mov   WDTCN, #0DEh
        mov   WDTCN, #0ADh
        mov   SFRPAGE, #CONFIG_PAGE 	; Use SFRs on the Configuration Page
        mov   P0MDOUT, #00000000b       ; Inputs
        mov   P1MDOUT, #00000000b       ; Inputs
        mov   P2MDOUT, #11111111b       ; Outputs
        mov   XBR2, #40h	            ; Enable the Port I/O Crossbar 
;--------------------------------- Initialisation---------------------------------------
	       ;Add your assembly code in this section to:
	       ;Initialise internal variables eg State
	       ;etc
;--------------------------------- Main Loop-------------------------------------------
	       ;Add your assembly code in this section to implement the State Machine 
Main_loop:
		..
		..
		mov A, State		; Shift current state into accumulator
		rl A				; Mystery instruction: Hint: ajmp is 2 bytes long in code memory
		mov	 DPTR, #State_table
		jmp @A+DPTR
State_table:
		ajmp State_1			;Stop state
		ajmp State_2			;Ball initialised to LD1
		ajmp State_3			;Ball move right to LD2
		ajmp State_4			;Ball move right to LD3
		ajmp State_5			;Ball move right to LD4
		ajmp State_6			;Ball move right to LD5
		ajmp State_7			;Ball move right to LD6
		ajmp State_8			;Ball move right to LD7
		ajmp State_9			;Ball move right to LD8
		ajmp State_10			;Ball move left to LD7
		ajmp State_11			;Ball move left to LD6
		ajmp State_12			;Ball move left to LD5
		ajmp State_13			;Ball move left to LD4
		ajmp State_14			;Ball move left to LD3
		ajmp State_15			;Ball move left to LD2
		ajmp State_16			;Ball move left to LD1
		ajmp State_17			;P1 Scores
		ajmp State_18			;P2 Scores
		ajmp State_19			;Pause state
		ajmp State_20			;Lose state
State_1:	
		..
		..
		inc State
		ajmp Main_loop							

State_2:			;Ball initialised to LD1
	mov A, #00000001
	mov P2, A			
	lcall Delay
	inc State
	ajmp Main_Loop
	
State_3:			;Ball move right to LD2
	rl A
	mov P2, A
	lcall Delay
	inc State
	ajmp Main_Loop
	
State_4:			;Ball move right to LD3
	rl A
	mov P2, A
	lcall Delay
	inc State
	ajmp Main_Loop

State_5:			;Ball move right to LD4
	rl A
	mov P2, A
	lcall Delay
	inc State
	ajmp Main_Loop			

State_6:			;Ball move right to LD5
	rl A
	mov P2, A
	lcall Delay
	inc State
	ajmp Main_Loop			

State_7:			;Ball move right to LD6
	rl A
	mov P2, A
	lcall Delay
	inc State
	ajmp Main_Loop

State_8:			;Ball move right to LD7
	rl A
	mov P2, A
	lcall Delay
	inc State
	ajmp Main_Loop

State_9:			;Ball move right to LD8
	rl A
	mov P2, A
	lcall Delay
	inc State
	ajmp Main_Loop


State_10:			;Ball moving left to LD7
	rr A
	mov P2, A
	lcall Delay
	inc State
	ajmp Main_Loop

State_11:			;Ball moving left to LD6
	rr A
	mov P2, A
	lcall Delay
	inc State
	ajmp Main_Loop
	
State_12:			;Ball moving left to LD5
	rr A
	mov P2, A
	lcall Delay
	inc State
	ajmp Main_Loop
	
State_13:			;Ball moving left to LD4
	rr A
	mov P2, A
	lcall Delay
	inc State
	ajmp Main_Loop

State_14:			;Ball moving left to LD3
	rr A
	mov P2, A
	lcall Delay
	inc State
	ajmp Main_Loop

State_15:			;Ball moving left to LD2
	rr A
	mov P2, A
	lcall Delay
	inc State
	ajmp Main_Loop

State_16:			;Ball moving left to LD1
	rr A
	mov P2, A
	lcall Delay
	sub State, #14
	ajmp Main_Loop

;--------------------------------- Functions---------------------------------------
	       ;Add your assembly code functions for various tasks in this section 


Delay: ;this is how to generate time delay; modify it to generate X msec delay
Loop2:	mov   R7, Delay			
Loop1:  mov   R6, #00h
Loop0:  mov   R5, #00h
        djnz  R5, $
        djnz  R6, Loop0
        djnz  R7, Loop1
	    ret
;--------------------------------Lookup Table--------------------------------------
		; To use this table, in main code use "mov dptr,#Some_Value"
		; then move table index value into accumulator, then use "movc  a,@a+dptr",
        ; and finally output accumulator to the related output port
Some_Value:      db    0,10,0a4h,0b0h,99h,92h,82h,0f8h,80h,098h  
END
