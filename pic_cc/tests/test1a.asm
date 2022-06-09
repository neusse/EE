;	PIC16x84 Small C
;	Code generator by Andrew D. Balsa
;	Version 0.4 - 04/11/98

;	Front End

	include	"16c84.h"
	
; **************data segment dseg*******************
	
	org	_DSEG,reg

ad_	ds	1
d1_	ds	1
d2_	ds	1
d3_	ds	1

; **************code segment cseg*******************
	
	org	_CSEG,code

	
;	Begin Function
	

main_
	movlf	_primary,255
	movf	_primary,W
	movwf	ad_
	movlf	_primary,0
	movf	_primary,W
	movwf	d1_
_2_
	movf	ad_,W
	movwf	_primary
	call	_push_
	movlf	_primary,100
;FYI: WARNING: Signed chars are not implemented
	call	_pop_
	call	_gge_
	movf	_primary,F
	btfsc	_status,Z
	goto	_3_
	movf	ad_,W
	movwf	_primary
	call	_push_
	movlf	_primary,100
	call	_pop_
	movf	_primary,W
	subwf	_secondary,W
	movwf	_primary
	movf	_primary,W
	movwf	ad_
	movf	d1_,W
	movwf	_primary
	incf	_primary,F
	movf	_primary,W
	movwf	d1_
	decf	_primary,F
	goto	_2_
_3_
	movlf	_primary,0
	movf	_primary,W
	movwf	d2_
_4_
	movf	ad_,W
	movwf	_primary
	call	_push_
	movlf	_primary,10
;FYI: WARNING: Signed chars are not implemented
	call	_pop_
	call	_gge_
	movf	_primary,F
	btfsc	_status,Z
	goto	_5_
	movf	ad_,W
	movwf	_primary
	call	_push_
	movlf	_primary,10
	call	_pop_
	movf	_primary,W
	subwf	_secondary,W
	movwf	_primary
	movf	_primary,W
	movwf	ad_
	movf	d2_,W
	movwf	_primary
	incf	_primary,F
	movf	_primary,W
	movwf	d2_
	decf	_primary,F
	goto	_4_
_5_
	movlf	_primary,0
	movf	_primary,W
	movwf	d3_
_6_
	movf	ad_,W
	movwf	_primary
	call	_push_
	movlf	_primary,0
;FYI: WARNING: Signed chars are not implemented
	call	_pop_
	call	_ggt_
	movf	_primary,F
	btfsc	_status,Z
	goto	_7_
	movf	ad_,W
	movwf	_primary
	call	_push_
	movlf	_primary,1
	call	_pop_
	movf	_primary,W
	subwf	_secondary,W
	movwf	_primary
	movf	_primary,W
	movwf	ad_
	movf	d3_,W
	movwf	_primary
	incf	_primary,F
	movf	_primary,W
	movwf	d3_
	decf	_primary,F
	goto	_6_
_7_
_1_
	return

;*******need compare standard library********
	
	include	"glibpic.h"

	

;0 error(s) in compilation
;	literal pool:0
;	global pool:98
;	Macro pool:36
	end

