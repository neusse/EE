;	PIC16x84 Small C
;	Code generator by Andrew D. Balsa
;	Version 0.4 - 04/11/98

;	Front End

	include	"16c84.h"
	
; **************data segment dseg*******************
	
	org	_DSEG,reg

z_	ds	5

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
	movlf	_primary,5
;FYI: WARNING: Signed chars are not implemented
	call	_pop_
	call	_glt_
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
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_indr_
	goto	_6_
_8_
	movlf	_primary,z_
	call	_push_
	movlf	_primary,1
	movf	_stackptr,W
	addwf	_primary,F
	call	_indr_
	call	_pop_
	movf	_secondary,W
	addwf	_primary,F
	call	_push_
	; # args passed = 0
	call	f1_
	call	_pop_
	call	_putstk_
	goto	_7_
_9_
	movlf	_primary,z_
	call	_push_
	movlf	_primary,1
	movf	_stackptr,W
	addwf	_primary,F
	call	_indr_
	call	_pop_
	movf	_secondary,W
	addwf	_primary,F
	call	_push_
	; # args passed = 0
	call	f2_
	call	_pop_
	call	_putstk_
	goto	_7_
_10_
	movlf	_primary,z_
	call	_push_
	movlf	_primary,1
	movf	_stackptr,W
	addwf	_primary,F
	call	_indr_
	call	_pop_
	movf	_secondary,W
	addwf	_primary,F
	call	_push_
	; # args passed = 0
	call	f3_
	call	_pop_
	call	_putstk_
	goto	_7_
_11_
	movlf	_primary,z_
	call	_push_
	movlf	_primary,1
	movf	_stackptr,W
	addwf	_primary,F
	call	_indr_
	call	_pop_
	movf	_secondary,W
	addwf	_primary,F
	call	_push_
	; # args passed = 0
	call	f4_
	call	_pop_
	call	_putstk_
	goto	_7_
_12_
	movlf	_primary,z_
	call	_push_
	movlf	_primary,1
	movf	_stackptr,W
	addwf	_primary,F
	call	_indr_
	call	_pop_
	movf	_secondary,W
	addwf	_primary,F
	call	_push_
	; # args passed = 0
	call	f5_
	call	_pop_
	call	_putstk_
	goto	_7_
	goto	_7_
_6_
	movlw	0
	subwf	_primary,W
	btfsc	_status,Z
	goto	_8_
	movlw	1
	subwf	_primary,W
	btfsc	_status,Z
	goto	_9_
	movlw	2
	subwf	_primary,W
	btfsc	_status,Z
	goto	_10_
	movlw	3
	subwf	_primary,W
	btfsc	_status,Z
	goto	_11_
	movlw	4
	subwf	_primary,W
	btfsc	_status,Z
	goto	_12_
	goto	_7_
_7_
	goto	_3_
_5_
_1_
	movlw	1
	addwf	_stackptr,F
	return
	
;	Begin Function
	

f1_
	movlf	_primary,1
	goto	_13_
_13_
	return
	
;	Begin Function
	

f2_
	movlf	_primary,2
	goto	_14_
_14_
	return
	
;	Begin Function
	

f3_
	movlf	_primary,3
	goto	_15_
_15_
	return
	
;	Begin Function
	

f4_
	movlf	_primary,4
	goto	_16_
_16_
	return
	
;	Begin Function
	

f5_
	movlf	_primary,5
	goto	_17_
_17_
	return

;*******need compare standard library********
	
	include	"glibpic.h"

	

;0 error(s) in compilation
;	literal pool:0
;	global pool:126
;	Macro pool:36
	end

