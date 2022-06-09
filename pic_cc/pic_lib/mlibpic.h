;
;  pic arithmetic library routines
;
;  ADB - I replaced the previous routines by John Favata with
;        the arithmetic routines in Microchip's AN-617/AN-526,
;	 slightly modified.
;	 The following are UNSIGNED arithmetic routines.

;  (8x8) multiply primary register by secondary register
;   result in primary
;   in fact, only the LSB... :-(

	org	reg
	
_Hbyte	ds	1
_Lbyte	ds	1
_mcount	ds	1

	org	code

_mul_
	clrf	_Hbyte
	clrf	_Lbyte
	movlw	8
	movwf	_mcount
	movf	_primary,W
	bcf	_status,C	;clear carry bit
_mul_1
	rrf	_secondary,F
	btfsc	_status,C
	addwf	_Hbyte,F
	rrf	_Hbyte,F
	rrf	_Lbyte,F
	decfsz	_mcount,F
	goto	_mul_1

	movf	_Lbyte,W	;move LS byte to primary
	movwf	_primary
	return
	

;  (8x8) division of secondary register by primary register
;   quotient in primary, remainder in secondary



_div_
	clrf	_Lbyte
	movlw	8
	movwf	_mcount
_div_1
	rlf	_secondary,W	
	rlf	_Lbyte,F
	movf	_primary,W
	subwf	_Lbyte,F
	btfsc	_status,C
	goto	_div_2
	addwf	_Lbyte,F
	bcf	_status,C
_div_2
	rlf	_secondary,F
	decfsz	_mcount,F
	goto	_div_1

	movf	_secondary,W	;quotient in primary
	movwf	_primary
		
	movf	_Lbyte,W	;remainder in secondary
	movwf	_secondary
	
	return