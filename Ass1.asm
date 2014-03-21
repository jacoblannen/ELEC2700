$include (c8051f120.inc)               	; Includes register definition file
;-----------------------------------------------------------------------------
; EQUATES
;-----------------------------------------------------------------------------
State			equ		R4


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
		ajmp State_1
		ajmp State_2
		ajmp State_3
		..
		..
		..
		ajmp State_N			
		..
		..				
State_1:	
		..
		..
		inc State
		ajmp Main_loop							

State_2:
		..
		..
		..
		ajmp Main_loop	
		..
		..
		..		
State_N:
		..
		..
		..
		ajmp Main_loop


;--------------------------------- Functions---------------------------------------
	       ;Add your assembly code functions for various tasks in this section 


Delay: ;this is how to generate time delay; modify it to generate X msec delay
Loop2:	mov   R7, #03h			
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