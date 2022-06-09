;	PIC16x84 Small C
;	Code generator by Andrew D. Balsa
;	Version 0.4 - 04/11/98

;	Front End

	include	"16c84.h"
	
; **************data segment dseg*******************
	
	org	_DSEG,reg

a_	ds	1
b_	ds	1
i_	ds	1
c_	ds	7
d_	ds	5

; **************code segment cseg*******************
	
	org	_CSEG,code

	
;	Begin Function
	

main_
	movlf	_primary,0
	movf	_primary,W
	movwf	a_
	movlf	_primary,6
	movf	_primary,W
	movwf	b_
	movlf	_primary,0
	movf	_primary,W
	movwf	i_
_2_
	movf	i_,W
	movwf	_primary
	call	_push_
	movlf	_primary,7
;FYI: WARNING: Signed chars are not implemented
	call	_pop_
	call	_glt_
	movf	_primary,F
	btfss	_status,Z
	goto	_4_
	goto	_5_
_3_
	movf	i_,W
	movwf	_primary
	incf	_primary,F
	movf	_primary,W
	movwf	i_
	decf	_primary,F
	goto	_2_
_4_
	movlf	_primary,c_
	call	_push_
	movf	i_,W
	movwf	_primary
	call	_pop_
	movf	_secondary,W
	addwf	_primary,F
	call	_push_
	movf	b_,W
	movwf	_primary
	call	_push_
	movf	i_,W
	movwf	_primary
	call	_push_
	; # args passed = 2
	call	GetChar_
	movlw	2
	addwf	_stackptr,F
	call	_pop_
	call	_putstk_
	goto	_3_
_5_
	movlf	_primary,0
	movf	_primary,W
	movwf	i_
_6_
	movf	i_,W
	movwf	_primary
	call	_push_
	movlf	_primary,5
;FYI: WARNING: Signed chars are not implemented
	call	_pop_
	call	_glt_
	movf	_primary,F
	btfss	_status,Z
	goto	_8_
	goto	_9_
_7_
	movf	i_,W
	movwf	_primary
	incf	_primary,F
	movf	_primary,W
	movwf	i_
	decf	_primary,F
	goto	_6_
_8_
	movlf	_primary,d_
	call	_push_
	movf	i_,W
	movwf	_primary
	call	_pop_
	movf	_secondary,W
	addwf	_primary,F
	call	_push_
	movf	a_,W
	movwf	_primary
	call	_push_
	movf	i_,W
	movwf	_primary
	call	_push_
	; # args passed = 2
	call	GetChar_
	movlw	2
	addwf	_stackptr,F
	call	_pop_
	call	_putstk_
	goto	_7_
_9_
_1_
	return
	
;	Begin Function
	

GetChar_
	movf	_stackptr,W	; first argument
	movwf	_fsr
	movf	_indf,W
	incf	_fsr,F		; next argument
	addwf	_indf,W		; W = (str+index) = our index in the spring table
	call	_string_table_	; NOTE: routine created by the compiler
	movwf	_primary	; now W = the desired char
_10_
	return

; Begin global string table

_string_table_
	addwf	_pcl,F
_0_	retlw	104	; 'h'
	retlw	101	; 'e'
	retlw	108	; 'l'
	retlw	108	; 'l'
	retlw	111	; 'o'
	retlw	0
	retlw	103	; 'g'
	retlw	111	; 'o'
	retlw	111	; 'o'
	retlw	100	; 'd'
	retlw	98	; 'b'
	retlw	121	; 'y'
	retlw	101	; 'e'
	retlw	0

;*******need compare standard library********
	
	include	"glibpic.h"

	

;0 error(s) in compilation
;	literal pool:14
;	global pool:126
;	Macro pool:36
	end

