/*
 * ee_read.c - read EEPROM location
 *
 * the address of variable data is passed on top of stack,
 * and the address of variable addr on the next stack cell
 * (since our stack grows downwards this is _stackptr + 1).
 *
 * note: this routine executes in a variable number of cycles
 */
 
ee_write( addr, data )
char addr;
char data;
{
#asm
	incf	_stackptr,W	; fetch addr first
	movwf	_fsr
	movf	_indf,W
	movwf	_eeaddr

	decf	_fsr,F
	movf	_indf,W		; fetch data
	movwf	_eedata

        bsf	_status,RP0	; set page 1
        bcf	_intcon,GIE	; disable interrupts

        bsf	_eecon1,WREN	; enable write

        movlw	0x55		; magic sequence
        movwf	_eecon2
        movlw	0xaa
        movwf	_eecon2
        bsf	_eecon1,WR	; write command
_eeloop_
	btfss	_eecon1,EEIF	; loop until done
	goto	_eeloop

        bcf	_eecon1,EEIF	; clr eeif flag
        bsf	_intcon,GIE	; enable interrupts

        bcf	_status,RP0	; set page 0
#endasm
}
