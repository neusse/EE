;	PIC16x84 Small C
;	Code generator by Andrew D. Balsa
;	Version 0.4 - 04/11/98

;	Front End

	include	"16c84.h"
	
; **************data segment dseg*******************
	
	org	_DSEG,reg

a1_	ds	1
a2_	ds	1
a3_	ds	1

; **************code segment cseg*******************
	
	org	_CSEG,code

	
;	Begin Function
	

main_
	movlf	_primary,1
	movf	_primary,W
	movwf	a1_
	movlf	_primary,2
	movf	_primary,W
	movwf	a2_
	movf	a1_,W
	movwf	_primary
	call	_push_
	movf	a2_,W
	movwf	_primary
	call	_pop_
	movf	_secondary,W
	addwf	_primary,F
	movf	_primary,W
	movwf	a3_
_1_
	return
	

;0 error(s) in compilation
;	literal pool:0
;	global pool:84
;	Macro pool:36
	end

