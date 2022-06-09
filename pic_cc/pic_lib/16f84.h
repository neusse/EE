;
; runtime setup code for pic16f84
; should be modified to suit individual projects
;

	device	pic16f84

;
; macros
;
movlf	macro	; move literal into fr
	movlw	\2
	movwf	\1
	endm
; 
; reserve some space (code and data) for assembler routines
;
_CSEG	equ	0x40         ; code origin
_DSEG	equ	0x10         ; start of working data registers

; registers needed by code generator
_stackbottom	equ	0x4b	; we have more RAM compared to pic16c84

	org	_stackbottom,reg

_stackptr	ds	1	; 0x4b
_temp		ds	2	; 0x4c
_secondary	ds	1	; 0x4e
_primary	ds	1	; 0x4f
	
; some standard pic function registers
; Bank 0
_indf	equ	0	;_indf and _fsr are used together to implement a stack
_tmr0	equ	1
_pcl	equ	2
_status	equ	3
_fsr	equ	4

;i/o ports
_portA	equ	5
_portB	equ	6

;eeprom r/w
_eedata	equ	8
_eeaddr	equ	9

;misc.
_pclath	equ    0xA
_intcon	equ    0xB

; Bank 1
_optreg	equ	1

_trisA	equ	5
_trisB	equ	6

_eecon1	equ	8
_eecon2	equ	9

; status bits
IRP	equ	7
RP1	equ	6
RP0	equ	5
NOT_TO	equ	4
NOT_PD	equ	3
Z	equ	2
DC	equ	1
C	equ	0

; intcon bits
GIE	equ	7
EEIE	equ	6
T0IE	equ	5
INTE	equ	4
RBIE	equ	3
T0IF	equ	2
INTF	equ	1
RBIF	equ	0

; option register bits
NOT_RBPU equ	7
INTEDG	equ	6
T0CS	equ	5
T0SE	equ	4
PSA	equ	3
PS2	equ	2
PS1	equ	1
PS0	equ	0

; eecon1 bits
EEIF	equ	4
WRERR	equ	3
WREN	equ	2
WR	equ	1
RD	equ	0

; ram definition
;	 __MAXRAM H'CF'
;	 __BADRAM H'07', H'50'-H'7F', H'87'

; configuration bits
_CP_ON		equ	   0x3FEF
_CP_OFF 	equ	   0x3FFF
_PWRTE_ON	equ	   0x3FFF
_PWRTE_OFF	equ	   0x3FF7
_WDT_ON 	equ	   0x3FFF
_WDT_OFF	equ	   0x3FFB
_LP_OSC 	equ	   0x3FFC
_XT_OSC 	equ	   0x3FFD
_HS_OSC 	equ	   0x3FFE
_RC_OSC 	equ	   0x3FFF

;
;  stack mechanism
;
;   low memory
;   ^
;   |  start of registers (DSEG) ----> STATIC VARIABLES
;   |  ....
;   |  stack-------------------------> AUTOMATIC VARIABLES
;   |  code registers: _primary, etc...
;   |
;   high memory
;
;  the stack grows downwards, whereas the static variables space
;  begins at 0x10 and grows upwards.

W	equ	0
F	equ	1

; EEPROM starts here

	org	0,code

	goto	startup

	org	4

	goto	interrupt

	org	10

startup
	movlw	_stackbottom	; set up stack pointer
	movwf	_stackptr
	call	main_
	goto	$	; infinite loop if return from main

interrupt
	goto	$	; set to your interrupt routine 

; standard stack manipulation code
; everything goes through W.
; it would be more efficient to use FSR directly as our stack pointer...
_push_	; push primary on top of stack
	decf	_stackptr,F
	movf	_stackptr,W
	movwf	_fsr
	movf	_primary,W
	movwf	_indf
	return

_pop_	; pop top of stack to secondary
	movf	_stackptr,W
	movwf	_fsr
	movf	_indf,W
	movwf	_secondary
	incf	_stackptr,F
	return

_putstk_	; ?????
	movf	_secondary,W
	movwf	_fsr
	movf	_primary,W
	movwf	_indf
	return

_indr_	; get object pointed to by _primary into _primary
	movf	_primary,W
	movwf	_fsr	
	movf	_indf,W
	movwf	_primary
	return

_swap_	; exchange _primary and _secondary
	movf	_primary,W
	movwf	_temp
	movf	_secondary,W
	movwf	_primary
	movf	_temp,W
	movwf	_secondary
	return

_swaps_ ; swap _primary and top of stack
	movf	_stackptr,W
	movwf	_fsr
	movf	_indf,W
	movwf	_temp
	movf	_primary,W
	movwf	_indf
	movf	_temp,W
	movwf	_primary
	return

;
; ***********************Start of user code******************
;
