;	PIC16x84 Small C
;	Code generator by Andrew D. Balsa
;	Version 0.4 - 04/11/98

;	Front End

	include	"16c84.h"
	
; **************data segment dseg*******************
	
	org	_DSEG,reg

a_	ds	1
b_	ds	1

; **************code segment cseg*******************
	
	org	_CSEG,code

	
;	Begin Function
	

SetP_A_
	movf	_stackptr,W
	movwf	_primary
	call	_indr_
	movf	_primary,W
	bsf	_status,RP0
	movwf	_trisA
	bcf	_status,RP0
_1_
	return
	
;	Begin Function
	

SetP_B_
	movf	_stackptr,W
	movwf	_primary
	call	_indr_
	movf	_primary,W
	bsf	_status,RP0
	movwf	_trisB
	bcf	_status,RP0
_2_
	return
	
;	Begin Function
	

RdPortA_
	movf	_portA,W
	movwf	_primary
_3_
	return
	
;	Begin Function
	

RdPortB_
	movf	_portB,W
	movwf	_primary
_4_
	return
	
;	Begin Function
	

WrPortA_
	movf	_stackptr,W
	movwf	_primary
	call	_indr_
	movf	_primary,W
	movwf	_portA
_5_
	return
	
;	Begin Function
	

WrPortB_
	movf	_stackptr,W
	movwf	_primary
	call	_indr_
	movf	_primary,W
	movwf	_portB
_6_
	return
	
;	Begin Function
	

main_
	movlf	_primary,3
	call	_push_
	; # args passed = 1
	call	SetP_A_
	movlw	1
	addwf	_stackptr,F
	movlf	_primary,15
	call	_push_
	; # args passed = 1
	call	SetP_B_
	movlw	1
	addwf	_stackptr,F
	; # args passed = 0
	call	RdPortA_
	movf	_primary,W
	movwf	a_
	; # args passed = 0
	call	RdPortB_
	movf	_primary,W
	movwf	b_
	movlf	_primary,1
	call	_push_
	; # args passed = 1
	call	WrPortA_
	movlw	1
	addwf	_stackptr,F
	movlf	_primary,85
	call	_push_
	; # args passed = 1
	call	WrPortB_
	movlw	1
	addwf	_stackptr,F
_7_
	return
	

;0 error(s) in compilation
;	literal pool:0
;	global pool:154
;	Macro pool:36
	end

