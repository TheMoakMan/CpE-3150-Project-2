#include <reg932.inc>

	cseg 	at 	0

	led1 	equ 0a4h 	; Memory locations for LEDs and switches
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
	
	SPKR    equ 97h
	on		equ 0
	off		equ 1
	
	mov r5, #00
	mov p2m1, #00		; set Port 2 to bi-directional
	mov p1m1, #00		; set Port 1 to bi-directional
	mov P0m1, #00		; set Port 0 to bi-directional
	mov psw, #00		; Clear AC and CY flags, other flags get deep-sixed
	clr a
	clr c


	lcall STARTUP		


MAIN:
	lcall RESET			; Check if the counter needs to be reset
	mov a, r5			; Complement the counter bits and send to the LEDs	
    CPL a	      		
	mov c, 0E0h   		; A.0
	mov led9, c   		; A.0
	mov c, 0E1h   		; A.1
	mov led8, c   		; A.1
	mov c, 0E2h   		; A.2
	mov led7, c   		; A.2
	mov c, 0E3h   		; A.3
	mov led4, c   		; A.3
	clr c
	jnb sw4, AUTOINC	; Auto-increment the counter if switch 4 is pressed						
	jnb sw1, DECREMENT	; Manually decrement the counter if switch 1 is pressed
						; Waits until the button is released to return
						
	jnb sw2, INCREMENT	; Manually increment the counter if switch 2 is pressed
						; Waits until the switch is released to return
						
	jnb sw3, CLEAR		; Clear the counter if switch 3 is pressed
	jnb sw5, BEEPCNT	; Beep the current count if switch 5 is pressed 

	sjmp MAIN			; Keeps the program running
	
INCREMENT: 	   			; Increments the counter
	mov a, r5       	
	add a, #01h      	; Increment with flags
	mov r5, a
			   
                  
			   
			   
INCHOLD:   	   
	jnb sw2, INCHOLD 	; Keep looping this if the button is held
	sjmp MAIN
	
DECREMENT:     			; Decrements the counter
	clr c
    mov a, r5        	
	subb a, #01h      	; Subtract 01h to the current value
	mov r5, a	   
			   

DECHOLD:   				   
	jnb sw1, DECHOLD; 	; Keep looping this if the button is held
	clr psw.6
	sjmp MAIN
			   
RESET:		   			; Resets the counter if it equals 0Fh
	jb psw.6, RESETINC
	jb psw.7, RESETDEC
RESETRET:	   
	ret
			   
RESETINC:	   			; Resets the counter to 0 if 0Fh is being approached 
						; from the positive direction
	clr psw.6
	mov r5, #00
    lcall ALARM
	SJMP RESETRET

RESETDEC:
						; Resets the counter to 0Fh if 0FF is being approached
						; from the negative direction
	clr psw.7
	mov r5, #0Fh
	lcall ALARM
	SJMP RESETRET
			   
AUTOINC:				; Automatically increment the counter after a delay to
						; allow the user to read the LED display between 
						; increment operations
	mov a, r5        	
	add a, #01h      	; Increment with flags
	mov r5, a
	lcall LONGDELAY
	lcall LONGDELAY
	lcall LONGDELAY
	sjmp MAIN
	
	
BEEPCNT:				; Use the speaker to beep the number of times 
						; based on the value allocated to the counter
	mov a, r5
	mov r4, a
	jz MAIN
BEEPLOOP:
	lcall ALARM
	lcall LONGDELAY
	DJNZ r4, BEEPLOOP
	sjmp MAIN

DELAY:  				; Creates a short delay       
	mov r0, #230
HERE:
	nop
    nop
	nop
	nop
	nop
	nop
	djnz r0, here
	ret
LONGDELAY:	 			; Creates a longer delay using nested loops  
	mov r0, #255
LONGTHERE:	   
	mov r1, #125
LONGHERE:      
	nop
    nop
	nop
	nop
	nop
	nop
	djnz r1, LONGHERE
	djnz r0, LONGTHERE
	ret

ALARM:   				; Send a 1 KHz square way to the speaker      
	mov r7, #255
ALARMLOOP:    
	setb SPKR
	clr led3
	lcall DELAY
	setb led3
	clr SPKR
	lcall delay
	djnz r7, ALARMLOOP
	ret
CLEAR:					; Clear the counter and make the speaker beep		   
	mov r5, #00
	lcall ALARM
	ljmp MAIN
			   
STARTUP:       
	clr led1        	; Turn each light on in spiral pattern
    lcall longdelay
	clr led2
	lcall longdelay
	clr led3
	lcall longdelay
	clr led6
	lcall longdelay
	clr led9
	lcall longdelay
	clr led8
	lcall longdelay
	clr led7
	lcall longdelay
	clr led5
	lcall longdelay
	clr led4
	lcall longdelay
	setb led5
	lcall longdelay
	setb led6
	lcall longdelay
	setb led9
	lcall longdelay
	setb led8
	lcall longdelay
	setb led7
	lcall longdelay
	setb led4
	lcall longdelay
	setb led1
	lcall longdelay
	setb led2
	lcall longdelay
	setb led3
	lcall longdelay
	ret
end
	
	
