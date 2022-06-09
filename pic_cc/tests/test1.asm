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
	movlw	1
	subwf	_stackptr,F
_2_
	movlf	_primary,1
	movf	_primary,F
	btfsc	_status,Z
	goto	_3_
	; # args passed = 0
	call	GetAD_
	movf	_primary,W
	movwf	ad_
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_push_
	movlf	_primary,0
	call	_pop_
	call	_putstk_
_4_
	movf	ad_,W
	movwf	_primary
	call	_push_
	movlf	_primary,100
;FYI: WARNING: Signed chars are not implemented
	call	_pop_
	call	_gge_
	movf	_primary,F
	btfsc	_status,Z
	goto	_5_
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
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_push_
	call	_indr_
	incf	_primary,F
	call	_pop_
	call	_putstk_
	decf	_primary,F
	goto	_4_
_5_
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_indr_
	movf	_primary,W
	movwf	d1_
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_push_
	movlf	_primary,0
	call	_pop_
	call	_putstk_
_6_
	movf	ad_,W
	movwf	_primary
	call	_push_
	movlf	_primary,10
;FYI: WARNING: Signed chars are not implemented
	call	_pop_
	call	_gge_
	movf	_primary,F
	btfsc	_status,Z
	goto	_7_
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
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_push_
	call	_indr_
	incf	_primary,F
	call	_pop_
	call	_putstk_
	decf	_primary,F
	goto	_6_
_7_
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_indr_
	movf	_primary,W
	movwf	d2_
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_push_
	movlf	_primary,0
	call	_pop_
	call	_putstk_
_8_
	movf	ad_,W
	movwf	_primary
	call	_push_
	movlf	_primary,0
;FYI: WARNING: Signed chars are not implemented
	call	_pop_
	call	_ggt_
	movf	_primary,F
	btfsc	_status,Z
	goto	_9_
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
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_push_
	call	_indr_
	incf	_primary,F
	call	_pop_
	call	_putstk_
	decf	_primary,F
	goto	_8_
_9_
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_indr_
	movf	_primary,W
	movwf	d3_
	goto	_2_
_3_
_1_
	movlw	1
	addwf	_stackptr,F
	return
	
;	Begin Function
	

GetAD_
	movlw	1
	subwf	_stackptr,F
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_push_
	movlf	_primary,255
	call	_pop_
	call	_putstk_
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_indr_
	goto	_10_
_10_
	movlw	1
	addwf	_stackptr,F
	return

;*******need compare standard library********
	
	include	"glibpic.h"

	

;0 error(s) in compilation
;	literal pool:0
;	global pool:112
;	Macro pool:51
	end

