/*
 * ee_read.c - read EEPROM location
 *
 */
 
ee_read( addr )
char addr;
{
#asm

	movf	_stackptr,W	; get argument
	movwf	_fsr
	movf	_indf,W		; OK, addr in W
	movwf	_eeaddr
        bsf	_status,RP0	; set page 1
        bsf	_eecon1,RB	; initialize read
        bcf	_status,RP0	; set page 0
        movf	_eedata,W
        movwf	_primary	; return EEPROM data in primary
#endasm
}

