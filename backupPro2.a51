#include <reg932.inc>

cseg 0

led1 	equ 0a4h 		; Memory locations for LEDs and switches
led2 	equ 85h
led3 	equ 0a7h
led4 	equ 86h
led5 	equ 96h
led6 	equ 84h
led7 	equ 0a5h
led8 	equ 87h
led9 	equ 0a6h
sw1 	equ 0a0h
sw2 	equ 81h
sw3		equ 0a3h
sw4		equ 82h
sw5		equ 94h
sw6		equ	80h
sw7		equ	0a1h
sw8		equ	83h
sw9		equ	0a2h
	
SPKR    equ 97h
CNTR    equ 20h
	
;Main
	mov CNTR, #00	
	cjne sw2, #0, DECREMENT
	cjne sw1, #0, INCREMENT
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	INCREMENT: INC CNTR        ;Add 1 to the current value
               mov A, CNTR     ;Move the entire number into the accumulator
               CPL A	       ;Comlement the bits and send to the LEDs	   
			   mov led9, E0h   ;A.0
			   mov led8, E1h   ;A.1
			   mov led7, E2h   ;A.2
			   mov led4, E3h   ;A.3
	INCHOLD:   jz sw3, INCHOLD
	           ret
	
	DECREMENT: DEC CNTR        ;Subtract 1 from the current value
	           mov A, CNTR     ;Move the entire number into the accumulator
               CPL A	       ;Comlement the bits and send to the LEDs	   
			   mov led9, E0h   ;A.0
			   mov led8, E1h   ;A.1
			   mov led7, E2h   ;A.2
			   mov led4, E3h   ;A.3
	DECHOLD:   jz sw2, DECHOLD
	           ret
	           
	
	
	
