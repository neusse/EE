;	PIC16x84 Small C
;	Code generator by Andrew D. Balsa
;	Version 0.4 - 04/11/98

;	Front End

	include	"16c84.h"
	
; **************data segment dseg*******************
	
	org	_DSEG,reg

aa_	ds	1
bb_	ds	1
cc_	ds	1
dd_	ds	1

; **************code segment cseg*******************
	
	org	_CSEG,code

	
;	Begin Function
	

main_
	movlw	1
	subwf	_stackptr,F
	movlf	_primary,3
	movf	_primary,W
	movwf	aa_
	movlf	_primary,5
	movf	_primary,W
	movwf	bb_
	movf	aa_,W
	movwf	_primary
	call	_push_
	movf	bb_,W
	movwf	_primary
	call	_pop_
	call	_mul_
	movf	_primary,W
	movwf	cc_
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_push_
	movf	cc_,W
	movwf	_primary
	call	_push_
	movlf	_primary,1
	call	_pop_
	movf	_secondary,W
	addwf	_primary,F
	call	_pop_
	call	_putstk_
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_indr_
	call	_push_
	; # args passed = 1
	call	myfunc_
	movlw	1
	addwf	_stackptr,F
	movf	_primary,W
	movwf	dd_
_1_
	movlw	1
	addwf	_stackptr,F
	return
	
;	Begin Function
	

myfunc_
	movlw	1
	subwf	_stackptr,F
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_push_
	movlf	_primary,2
	movf	_stackptr,W
	addwf	_primary,F
	call	_indr_
	call	_push_
	movlf	_primary,4
	call	_pop_
	movf	_secondary,W
	addwf	_primary,F
	call	_pop_
	call	_putstk_
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_indr_
	goto	_2_
_2_
	movlw	1
	addwf	_stackptr,F
	return

;*******need mult/div standard library********
	
	include	"mlibpic.h"

	

;0 error(s) in compilation
;	literal pool:0
;	global pool:112
;	Macro pool:36
	end

