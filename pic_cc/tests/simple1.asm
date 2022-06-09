;	PIC16x84 Small C
;	Code generator by Andrew D. Balsa
;	Version 0.4 - 04/11/98

;	Front End

	include	"16c84.h"
	
; **************data segment dseg*******************
	
	org	_DSEG,reg


; **************code segment cseg*******************
	
	org	_CSEG,code

	
;	Begin Function
	

main_
	movlw	1
	subwf	_stackptr,F
	movlw	1
	subwf	_stackptr,F
	movlw	1
	subwf	_stackptr,F
	movlf	_primary,2
	movf	_stackptr,W
	addwf	_primary,F
	call	_push_
	movlf	_primary,1
	call	_pop_
	call	_putstk_
	movlf	_primary,1
	movf	_stackptr,W
	addwf	_primary,F
	call	_push_
	movlf	_primary,2
	call	_pop_
	call	_putstk_
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_push_
	movlf	_primary,3
	movf	_stackptr,W
	addwf	_primary,F
	call	_indr_
	call	_push_
	movlf	_primary,3
	movf	_stackptr,W
	addwf	_primary,F
	call	_indr_
	call	_pop_
	movf	_secondary,W
	addwf	_primary,F
	call	_pop_
	call	_putstk_
_1_
	movlw	3
	addwf	_stackptr,F
	return
	

;0 error(s) in compilation
;	literal pool:0
;	global pool:42
;	Macro pool:36
	end

