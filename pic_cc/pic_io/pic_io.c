/*
 * pic_io.c - 10/11/98
 *
 * Configure, read and write Ports A and B
 *
 */
 
/* set IO port mode */

SetP_A( value )
char value;
{
#asm
	movf	_stackptr,W	;address of value passed on top of stack
	movwf	_fsr
	movf	_indf,W
	bsf	_status,RP0
	movwf	_trisA
	bcf	_status,RP0
#endasm
}


SetP_B( value )
char value;
{
#asm
	movf	_stackptr,W
	movwf	_fsr
	movf	_indf,W
	bsf	_status,RP0
	movwf	_trisB
	bcf	_status,RP0
#endasm
}

/* read IO port value */

RdPortA()
{
#asm
	movf	_portA,W
	movwf	_primary	;value read returned in primary
#endasm
}


RdPortB ()
{
#asm
	movf	_portB,W
	movwf	_primary
#endasm
}

/* write IO port value */

WrPortA( value )
char value;
{
#asm
	movf	_stackptr,W
	movwf	_fsr
	movf	_indf,W
	movwf	_portA
#endasm
}


WrPortB( value )
char value;
{
#asm
	movf	_stackptr,W
	movwf	_fsr
	movf	_indf,W
	movwf	_portB
#endasm
}


