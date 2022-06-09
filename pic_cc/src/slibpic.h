;
; arithmetic shift routines
;

; WARNING! These should be coded as arithmetic shifts (preserving
           the sign bit) but are coded below as simple logical shifts.

; shift right secondary the number of times in primary
; return result in primary

_asr_
	bcf	_status,C
	rrf	_secondary,F
	decfsz	_primary,F
	goto	_asr_
	movf	_secondary,W
	movwf	_primary
	return

; shift left secondary the number of times in primary
; return result in primary

_asl_
	bcf	_status,C
	rlf	_secondary,F
	decfsz	_primary,F
	goto	_asr_
	movf	_secondary,W
	movwf	_primary
	return

