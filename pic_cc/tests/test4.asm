;	PIC16x84 Small C
;	Code generator by Andrew D. Balsa
;	Version 0.4 - 04/11/98

;	Front End

	include	"16c84.h"
	
; **************data segment dseg*******************
	
	org	_DSEG,reg

z_	ds	1
t_	ds	5

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
	btfsc	_status,Z
	goto	_3_
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_indr_
	call	_push_
	movlf	_primary,0
	call	_pop_
	call	_geq_
	movf	_primary,F
	btfsc	_status,Z
	goto	_4_
	; # args passed = 0
	call	f1_
	movf	_primary,W
	movwf	z_
_4_
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_indr_
	call	_push_
	movlf	_primary,1
	call	_pop_
	call	_geq_
	movf	_primary,F
	btfsc	_status,Z
	goto	_5_
	; # args passed = 0
	call	f2_
	movf	_primary,W
	movwf	z_
_5_
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_indr_
	call	_push_
	movlf	_primary,2
	call	_pop_
	call	_geq_
	movf	_primary,F
	btfsc	_status,Z
	goto	_6_
	; # args passed = 0
	call	f3_
	movf	_primary,W
	movwf	z_
_6_
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_indr_
	call	_push_
	movlf	_primary,3
	call	_pop_
	call	_geq_
	movf	_primary,F
	btfsc	_status,Z
	goto	_7_
	; # args passed = 0
	call	f4_
	movf	_primary,W
	movwf	z_
_7_
	movlf	_primary,0
	movf	_stackptr,W
	addwf	_primary,F
	call	_indr_
	call	_push_
	movlf	_primary,4
	call	_pop_
	call	_geq_
	movf	_primary,F
	btfsc	_status,Z
	goto	_8_
	; # args passed = 0
	call	f5_
	movf	_primary,W
	movwf	z_
_8_
	movlf	_primary,t_
	call	_push_
	movlf	_primary,1
	movf	_stackptr,W
	addwf	_primary,F
	call	_indr_
	call	_pop_
	movf	_secondary,W
	addwf	_primary,F
	call	_push_
	movf	z_,W
	movwf	_primary
	call	_pop_
	call	_putstk_
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
_3_
_1_
	movlw	1
	addwf	_stackptr,F
	return
	
;	Begin Function
	

f1_
	movlf	_primary,1
	goto	_9_
_9_
	return
	
;	Begin Function
	

f2_
	movlf	_primary,2
	goto	_10_
_10_
	return
	
;	Begin Function
	

f3_
	movlf	_primary,3
	goto	_11_
_11_
	return
	
;	Begin Function
	

f4_
	movlf	_primary,4
	goto	_12_
_12_
	return
	
;	Begin Function
	

f5_
	movlf	_primary,5
	goto	_13_
_13_
	return

;*******need compare standard library********
	
	include	"glibpic.h"

	

;0 error(s) in compilation
;	literal pool:0
;	global pool:140
;	Macro pool:36
	end

