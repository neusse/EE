;	PIC16x84 Small C
;	Code generator by Andrew D. Balsa
;	Version 0.4 - 04/11/98

;	Front End

	include	"16c84.h"
	
; **************data segment dseg*******************
	
	org	_DSEG,reg

ans1_	ds	1
ans2_	ds	1
ans3_	ds	1
ans4_	ds	1

; **************code segment cseg*******************
	
	org	_CSEG,code

	
;	Begin Function
	

main_
	movlf	_primary,2
	call	_push_
	movlf	_primary,4
	call	_pop_
	call	_mul_
	movf	_primary,W
	movwf	ans1_
	movlf	_primary,3
	call	_push_
	movlf	_primary,1
	call	_pop_
	movf	_primary,W
	subwf	_secondary,W
	movwf	_primary
	movf	_primary,W
	movwf	ans2_
	movlf	_primary,4
	call	_push_
	movlf	_primary,2
	call	_pop_
	call	_div_
	movf	_primary,W
	movwf	ans3_
	movlf	_primary,3
	call	_push_
	movlf	_primary,4
	call	_pop_
	movf	_secondary,W
	addwf	_primary,F
	movf	_primary,W
	movwf	ans4_
_1_
	return

;*******need mult/div standard library********
	
	include	"mlibpic.h"

	

;0 error(s) in compilation
;	literal pool:0
;	global pool:98
;	Macro pool:52
	end

