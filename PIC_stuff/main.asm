;**********************************************************************
;                                                                     *
;    Filename:	    	main.asm                                      *
;    Date:		October 7, 2001                               *
;    File Version: 0.1                                                *
;                                                                     *
;    Author: 		Michael		                              *
;    Company:                                                         *
;                                                                     * 
;                                                                     *
;**********************************************************************
;                                                                     *
;    Files required:                                                  *
;                                                                     *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes:                                                           *
;                                                                     *
;                                                                     *
;                                                                     *
;                                                                     *
;**********************************************************************
#define DEBUG
	list      p=16F84		; list directive to define processor
	#include <p16F84.inc>  	; processor specific variable definitions

	__CONFIG   _CP_OFF & _WDT_OFF & _XT_OSC 

	radix	decimal
	errorlevel -302			;don't print bank errors or warnings


Bank0RAM equ	H'20'	;Start of Bank 0 RAM

;******** physical port assignments ********
hand	equ	0	;GP0, output, active high
door	equ	1	;GP1, output, active high
led	equ	2	;GP2, output, active high
switch	equ	3	;GP3, input, active low
;******** end of physical port assignments ********

;******** bit flags in location BITFLAGS ********
switchflip	equ	0; true means switch has been flipped
;bit1		equ	1
;bit2		equ	2
;bit3		equ	3
;bit4		equ	4
;bit5		equ	5
;bit6		equ	6
;bit7		equ	7
;******** end of bit flags in location BITFLAGS ********

;******** Constants used *********
ON	equ	1
OFF	equ	0

BPW		equ	150	;base pulse width (generated twice in routine)
HPW_down	equ	255	;Hand Pulse Width servo positions
HPW_up		equ	1	;
DPW_down	equ	1	;Door Pulse Width
DPW_up		equ	255	;
DOORUPWAIT	equ	100	;how long to wait for door to go up
DOORDNWAIT	equ	150	;how long to wait for door to go down
HANDDNWAIT	equ	100	;how long to wait for hand to go down
INNERLOOPCTR	equ	255	;value for the inner loop (at 255x10, it generates)
OUTERLOOPCTR	equ	10	;value for the outer loop (7.7mS per WAIT)
;******** end of Constants used ********

;********** RAM Bank 0 assignments ********
	cblock	Bank0RAM
	WAITTIME		;how long to wait in wait loop, takes on value of up/dn waits
	OUTERLOOP		;loopctr1 used in Wait
	INNERLOOP		;loopctr2 used in Wait	
	PULSELOOP		;loop counter in pulse out
	BITFLAGS		;see above for bit assignment
	BASEPULSEWIDTH		;store base pulse width
	HANDPULSEWIDTH		;store pulse width adder
	DOORPULSEWIDTH		;store pulse width adder
	W_TEMP			;for interrupt routines
	STATUS_TEMP
	endc
;********** end of RAM Bank 0 assignments ********


;**********************************************************************
        ORG     0x000           ; coding begins here
	goto	ColdStart	; jump over the interrupt vector

	ORG	0x004		; interrupt vector
	goto	pulseout

	dt	"Michael Seedman 10/14/2001"

ColdStart:
	bsf	STATUS, RP0	; bank 1
	movlw	B'11111000'	; set RB0,1,2 as output, 3 as input
	movwf	TRISA		;
	bcf	OPTION_REG,T0CS	;set T0 for timer
	bsf	OPTION_REG,PS2	;set prescaler for 1:128
	bsf	OPTION_REG,PS1
	bcf	OPTION_REG,PS0
	bcf	OPTION_REG,PSA	;assign prescaler to TMR0
	bcf	INTCON, T0IF	;clear the Timer0 interrupt flag
	bsf	INTCON, T0IE	;set bit to accept Timer0 interrupts
	bsf	INTCON, GIE	;enable all interrupts
	bcf	STATUS, RP0	

	movlw	0
	movwf	PORTA		;set all outputs low
Start:
	movlw	HPW_down	;set up servos correctly to start position
	movwf	HANDPULSEWIDTH	
	movlw	DPW_down
	movwf	DOORPULSEWIDTH

Mode0:				;hang out sending down pulses
	call 	CheckSwitch	;update the bit 'switchflip'
	btfsc	BITFLAGS,switchflip	;has the switch been flipped?
	goto	Mode0		;no

Mode1:				;switch flipped, open door
	movlw	DPW_up
	movwf	DOORPULSEWIDTH

	movlw	DOORUPWAIT	;set up timer to wait for door to go up
	movwf	WAITTIME	
	call	Wait

Mode2:				;door open, deploy hand
	movlw	HPW_up
	movwf	HANDPULSEWIDTH

	call 	CheckSwitch	;see if the hand flipped the switch
	btfss	BITFLAGS,switchflip
	goto	Mode2		;not yet, go around again

Mode3:				;yes, hand flipped switch, retract hand
	movlw	HPW_down
	movwf	HANDPULSEWIDTH
	movlw	HANDDNWAIT
	movwf	WAITTIME
	call	Wait

Mode4:				;close door and start over
	goto	Start	
	
pulseout:
	movwf	W_TEMP		;store it for later
	swapf	STATUS, W
	movwf	STATUS_TEMP

;send hand pulse
	bsf	PORTA, hand		;set the output bit high
	movlw	BPW			;base pulse width
	movwf	BASEPULSEWIDTH
SHP0:	decfsz	BASEPULSEWIDTH,F
	goto	SHP0
	movlw	BPW			;base pulse width
	movwf	BASEPULSEWIDTH
SHP1:	decfsz	BASEPULSEWIDTH,F
	goto	SHP1
	movf	HANDPULSEWIDTH,W
	movwf	PULSELOOP
SHP2:	decfsz	PULSELOOP,F
	goto	SHP2
	movf	HANDPULSEWIDTH,W
	movwf	PULSELOOP
SHP3:	decfsz	PULSELOOP,F
	goto	SHP3
	bcf	PORTA, hand		;clear the output bit

;send door pulse
	bsf	PORTA, door		;set the output bit high
	movlw	BPW			;base pulse width
	movwf	BASEPULSEWIDTH
SDP0:	decfsz	BASEPULSEWIDTH,F
	goto	SDP0
	movlw	BPW			;base pulse width
	movwf	BASEPULSEWIDTH
SDP1:	decfsz	BASEPULSEWIDTH,F
	goto	SDP1
	movf	DOORPULSEWIDTH,W
	movwf	PULSELOOP
SDP2:	decfsz	PULSELOOP,F
	goto	SDP2
	bcf	PORTA, door		;clear the output bit

	swapf	STATUS_TEMP, W		;done with interrupt, return to main program
	movwf	STATUS
	swapf	W_TEMP,F
	swapf	W_TEMP,W
	bcf	INTCON, T0IF	;clear the flag for the next time
	retfie

;***************** CheckSwitch ******************************
; when the switch is open (normal 'off'), the pic will read a '1' from the port
; when the switch is closed (normal 'on'), the pic will read a '0' from the port
;  therefore, this routine exits with the bit 'switchflip' in the byte BITFLAGS:
;	set if the switch is 'on'
;	cleared if the switch is 'off'
;
CheckSwitch:
	bcf	BITFLAGS, switchflip	;clear the bit
	btfsc	PORTA, switch		;if there's a 1 in switch, switch is open
	bsf	BITFLAGS, switchflip	;yes, set the bit
	retlw	0

;***************** Wait *************************************
; enter with WAITTIME set
;  So each count of WAITTIME is 7.7mS
;
Wait:

	movlw	OUTERLOOPCTR		;set up the internal counter
	movwf	OUTERLOOP
	movlw	INNERLOOPCTR
	movwf	INNERLOOP

W1:
#ifdef DEBUG
	bsf	PORTA, led
#endif
	decfsz	INNERLOOP,F		;inner loop
	goto	W1
	decfsz	OUTERLOOP,F		;outer loop
	goto	W1
	movlw	OUTERLOOPCTR		;set up the internal counter
	movwf	OUTERLOOP
	decfsz	WAITTIME, F		;value entered routine with.  variable.
	goto	W1

#ifdef DEBUG
	bcf	PORTA,led
#endif

	retlw	0

		END                       ; directive 'end of program'

