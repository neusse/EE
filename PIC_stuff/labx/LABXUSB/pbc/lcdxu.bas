' PICBASIC program to demonstrate operation of an LCD in 4-bit mode

Symbol  PORTD = 8       ' PORTD is register 8
Symbol  PORTE = 9       ' PORTD is register 9
Symbol  TRISD = $88     ' PORTD data direction is register hexadecimal 88
Symbol  TRISE = $89     ' PORTD data direction is register hexadecimal 89
Symbol	ADCON1 = $9f	' ADCON1 is register hexadecimal 9f

	Poke ADCON1, 7	' Set analog pins to digital
	Poke TRISD, 0	' Set all PORTD lines to output
	Poke TRISE, 0	' Set all PORTE lines to output
	Poke PORTE, 0	' Start with enable low

	Pause 500	' Wait for LCD to power up

	Gosub lcdinit	' Initialize the lcd

loop:	Gosub lcdclr	' Clear lcd screen
	For B4 = 0 to 4	' Send string to lcd one letter at a time
		Lookup B4, ("Hello"), B2	' Get letter from string
		Gosub lcddata	' Send letter in B2 to lcd
	Next B4
	Pause 2500	' Wait .5 second

	Gosub lcdclr	' Clear lcd screen
	For B4 = 0 to 4	' Send string to lcd one letter at a time
		Lookup B4, ("world"), B2	' Get letter from string
		Gosub lcddata	' Send letter in B2 to lcd
	Next B4
	Pause 2500	' Wait .5 second

	Goto loop	' Do it forever


' Subroutine to initialize the lcd - uses B2 and B3
lcdinit: Pause 75	' Wait at least 15ms

	Poke PORTD, $33	' Initialize the lcd
	Gosub lcdtog	' Toggle the lcd enable line

	Pause 25	' Wait at least 4.1ms

	Poke PORTD, $33	' Initialize the lcd
	Gosub lcdtog	' Toggle the lcd enable line

	Pause 1		' Wait at least 100us

	Poke PORTD, $33	' Initialize the lcd
	Gosub lcdtog	' Toggle the lcd enable line

	Pause 1		' Wait once more for good luck

	Poke PORTD, $22	' Put lcd into 4 bit mode
	Gosub lcdtog	' Toggle the lcd enable line

	B2 = $28	' 4 bit mode, 2 lines, 5x7 font
	Gosub lcdcom	' Send B2 to lcd

	B2 = $0c	' Lcd display on, no cursor, no blink
	Gosub lcdcom	' Send B2 to lcd

	B2 = $06	' Lcd entry mode set, increment, no shift
	Goto lcdcom	' Exit through send lcd command

' Subroutine to clear the lcd screen - uses B2 and B3
lcdclr:	B2 = 1		' Set B2 to clear command and fall through to lcdcom

' Subroutine to send a command to the lcd - uses B2 and B3
lcdcom:	Poke PORTE, 0	' Set RS to command
lcdcd:	B3 = B2 & $f0	' Isolate top 4 bits
	Poke PORTD, B3	' Send upper 4 bits to lcd
	Gosub lcdtog	' Toggle the lcd enable line

	B3 = B2 * 16	' Shift botton 4 bits up to top 4 bits
	Poke PORTD, B3	' Send lower 4 bits to lcd
	Gosub lcdtog	' Toggle the lcd enable line

        Pause 10	' Wait 2ms for write to complete
	Return

' Subroutine to send data to the lcd - uses B2 and B3
lcddata: Poke PORTE, 1	' Set RS to data
	Goto lcdcd
 
' Subroutine to toggle the lcd enable line
lcdtog:	Peek PORTE, B0	' Get current PORTE value
	B0 = B0 | %00000010	' Set lcd enable line high
	Poke PORTE, B0
	B0 = B0 & %11111101	' Set lcd enable line low
	Poke PORTE, B0
	Return

	End
