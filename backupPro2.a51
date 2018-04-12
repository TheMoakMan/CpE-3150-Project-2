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
on		equ 0
off		equ 1
	
mov R5, #00
mov P2M1, #00		; set Port 2 to bi-directional
mov P1M1, #00		; set Port 1 to bi-directional
mov P0M1, #00		; set Port 0 to bi-directional
mov PSW, #00
CLR A
CLR C

;Evan's Code
lcall STARTUP


MAIN:

	;CPL A
	
	;mov a, sw2		
	lcall RESET
	mov A, R5
    CPL A	      ;Complement the bits and send to the LEDs	
	mov c, 0E0h   ;A.0
	mov led9, c   ;A.0
	mov c, 0E1h   ;A.1
	mov led8, c   ;A.1
	mov c, 0E2h   ;A.2
	mov led7, c   ;A.2
	mov c, 0E3h   ;A.3
	mov led4, c   ;A.3
	clr c
	jnb sw1, DECREMENT
	jnb sw2, INCREMENT
	jnb sw3, CLEAR
	;cjne a, #off, INCREMENT
	sjmp MAIN
	
INCREMENT: 	   mov A, R5        	
			   add A, #01h      ;Add 10h to the current value
			   mov R5, A
			   
                  
			   
			   
INCHOLD:   	   jnb sw2, INCHOLD ;Keep looping this if the button is held
			   ;jb psw.6, RESET
			   sjmp MAIN
	
DECREMENT:     clr c
               mov A, R5        	
			   subb A, #01h      ;Add 10h to the current value
			   mov R5, A	   
			   

DECHOLD:   	   jnb sw1, DECHOLD; ; Keep looping this if the button is held
			   clr psw.6
			   ;jb psw.7, RESET
	           sjmp MAIN
			   
RESET:		   jb psw.6, RESETINC
			   jb psw.7, RESETDEC
RESETRET:	   ret
			   
RESETINC:	   clr psw.6
			   mov R5, #00
               lcall ALARM
			   SJMP RESETRET
RESETDEC:	   clr psw.7
			   mov R5, #0fh
			   lcall ALARM
			   SJMP RESETRET
			   
			   
DELAY:         mov R0, #230
here:          nop
               nop
			   nop
			   nop
			   nop
			   nop
			   djnz R0, here
			   ret

ALARM:         mov R6, #2
ALARMLOOP:			   mov R7, #255
ALARMLOOP2:    setb SPKR
			   clr led3
			   lcall DELAY
			   setb led3
			   clr SPKR
			   lcall delay
			   djnz R7, ALARMLOOP2
			   djnz R6, ALARMLOOP
			   ret
CLEAR:		   mov R5, #00
			   lcall ALARM
			   sjmp MAIN
			   
STARTUP:       setb led1        ;Turn each light on sequentially one at a time
               lcall delay
			   setb led2
			   lcall delay
			   setb led3
			   lcall delay
			   setb led6
			   lcall delay
			   setb led5
			   lcall delay
			   setb led4
			   lcall delay
			   setb led7
			   lcall delay
			   setb led8
			   lcall delay
			   setb led9
			   lcall delay
			   clr led9
			   clr led8
			   clr led7
			   clr led4
			   clr led5
			   clr led6
			   clr led3
			   clr led2
			   clr led1
			   ret
end
	
	
