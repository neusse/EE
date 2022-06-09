;	PIC16x84 Small C
;	Code generator by Andrew D. Balsa
;	Version 0.4 - 04/11/98

;	Front End

	include	"16c84.h"
	
; **************data segment dseg*******************
	
	org	_DSEG,reg

table_	ds	10

; **************code segment cseg*******************
	
	org	_CSEG,code

	
;	Begin Function
	

main_
	movlw	1
	subwf	_stackptr,F
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_push_
	movlf	_primary,0
	call	_pop_
	call	_putstk_
_2_
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_indr_
	call	_push_
	movlf	_primary,10
	call	_push_
	movlf	_primary,1
	call	_pop_
	movf	_primary,W
	subwf	_secondary,W
	movwf	_primary
;FYI: WARNING: Signed chars are not implemented
	call	_pop_
	call	_ggt_
	movlw	1
	xorwf	_primary,F
	movf	_primary,F
	btfss	_status,Z
	goto	_4_
	goto	_5_
_3_
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_push_
	call	_indr_
	incf	_primary,F
	call	_pop_
	call	_putstk_
	decf	_primary,F
	goto	_2_
_4_
	movlf	_primary,table_
	call	_push_
	movlf	_primary,1
	movf	_stackptr,W
	addwf	_primary,F
	call	_indr_
	call	_pop_
	movf	_secondary,W
	addwf	_primary,F
	call	_push_
	movlf	_primary,1
	movf	_stackptr,W
	addwf	_primary,F
	call	_indr_
	call	_push_
	movlf	_primary,2
	call	_pop_
	call	_mul_
	call	_pop_
	call	_putstk_
	goto	_3_
_5_
_1_
	movlw	1
	addwf	_stackptr,F
	return

;*******need mult/div standard library********
	
	include	"mlibpic.h"


;*******need compare standard library********
	
	include	"glibpic.h"

	

;0 error(s) in compilation
;	literal pool:0
;	global pool:56
;	Macro pool:44
	end

