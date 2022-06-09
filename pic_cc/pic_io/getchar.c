/* getchar.c - get a character from static string str, offset index
 * i.e. str[index]
 *
 * ADB - 12/11/98. We use the table read method with an array of retlw
 * 		   instructions. Check Don Lancaster's muse109.pdf file or
 *		   the relevant Application Note from Microchip.
 *
 *		   If you are wondering what the _string_table_ label is:
 *		   it gets inserted by the main.c string handling routine.
 *
 * !!!!WARNING!!!! I have no idea whether this routine works across 256-byte
 *		   code space boundaries (don't think so). Please test.
 */

GetChar( str, index )

/* get arguments from top of stack */

char str;
char index;
{
#asm
	movf	_stackptr,W	; first argument
	movwf	_fsr
	movf	_indf,W
	incf	_fsr,F		; next argument
	addwf	_indf,W		; W = (str+index) = our index in the spring table
	call	_string_table_	; NOTE: routine created by the compiler
	movwf	_primary	; now W = the desired char
#endasm
}

