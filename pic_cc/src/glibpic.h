;
; comparison routines
; results are returned in primary (1 if TRUE, 0 if FALSE)
; WARNING: signed chars are not handled yet
; Andrew D. Balsa - 07/11/98
;

;equal (secondary == primary ?)
_geq_
_gueq_
	movf	_secondary,W
	subwf	_primary,W
	btfsc	_status,Z
	goto	_rettrue_
	clrf	_primary
	return

;not equal (secondary != primary ?)
_gne_
_gune_
	movf	_secondary,W
	subwf	_primary,W
	btfss	_status,Z
	goto	_rettrue_
	clrf	_primary
	return

;less than (secondary < primary ?)
_glt_
_gult_
	movf	_primary,W
	subwf	_secondary,W
	btfss	_status,C
	goto	_rettrue_
	clrf	_primary
	return

;less than or equal (secondary <= primary ?)
_gle_
_gule_
	movf	_secondary,W
	subwf	_primary,W
	btfsc	_status,C
	goto	_rettrue_
	clrf	_primary
	return

;greater than (secondary > primary ?)
_ggt_
_gugt_
	movf	_secondary,W
	subwf	_primary,W
	btfss	_status,C
	goto	_rettrue_
	clrf	_primary
	return

;greater than or equal (secondary >= primary ?)
_gge_
_guge_
	movf	_primary,W
	subwf	_secondary,W
	btfsc	_status,C
	goto	_rettrue_
	clrf	_primary
	return

;reduce primary to its boolean value
_bool_  
	movf	_primary,F
	btfsc	_status,Z
	return
_rettrue_
	movlw	1
	movwf	_primary
	return
