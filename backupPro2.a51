#include <reg932.inc>

cseg 	at 	0

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
on		equ 0
off		equ 1
	
mov CNTR, #00
mov P2M1, #00		; set Port 2 to bi-directional
mov P1M1, #00		; set Port 1 to bi-directional
mov P0M1, #00		; set Port 0 to bi-directional
	
MAIN:

	;mov A, CNTR
	;CPL A
	
	;mov a, sw2
	mov A, CNTR   ;Move the entire number into the accumulator
    CPL A	      ;Complement the bits and send to the LEDs	
	mov c, 0E0h   ;A.0
	mov led9, c   ;A.0
	mov c, 0E1h   ;A.1
	mov led8, c   ;A.1
	mov c, 0E2h   ;A.2
	mov led7, c   ;A.2
	mov c, 0E3h   ;A.3
	mov led4, c   ;A.3
	jnb sw1, DECREMENT
	jnb sw2, INCREMENT
	;cjne a, #off, INCREMENT
	sjmp MAIN
	
INCREMENT: 	   INC CNTR        	;Add 1 to the current value
                  
			   
			   
INCHOLD:   	   jnb sw2, INCHOLD ;Keep looping this if the button is held
	           sjmp MAIN
	
DECREMENT:     DEC CNTR        	;Subtract 1 from the current value
	           mov A, CNTR     	;Move the entire number into the accumulator
               CPL A	       	;Complement the bits and send to the LEDs	   
			   mov c, 0E0h   ;A.0
			   mov led9, c   ;A.0
			   mov c, 0E1h   ;A.1
			   mov led8, c   ;A.1
			   mov c, 0E2h   ;A.2
			   mov led7, c   ;A.2
			   mov c, 0E3h   ;A.3
			   mov led4, c   ;A.3

DECHOLD:   	   jnb sw1, DECHOLD; ; Keep looping this if the button is held
	           sjmp MAIN
	           
end
	
	
