' PICBASIC program to demonstrate operation of an LCD in 4-bit mode

Symbol	STATUS = 3		' Set STATUS register address
Symbol	PORTC = 7		' PORTC is register 7
Symbol	TRISC = $87		' PORTC data direction is register hexadecimal 87
Symbol	ANSEL = $11e		' Set ANSEL address
Symbol	ANSELH = $11f		' Set ANSELH address


	Poke STATUS, $80	' Set IRP in STATUS register to 1 to access high register banks
	Poke ANSEL, %00000000	' Set all pins digital
	Poke ANSELH, %00000000	' Set all pins digital
	Poke STATUS, 0		' Reset IRP in STATUS register to 0
	Poke TRISC, 0		' Set PORTC to all out

	Pause 100		' Wait for LCD to power up

	Gosub lcdinit		' Initialize the lcd

loop:	Gosub lcdclr		' Clear lcd screen
	For B4 = 0 To 4		' Send string to lcd one letter at a time
		Lookup B4, ("Hello"), B2	' Get letter from string
		Gosub lcddata	' Send letter in B2 to lcd
	Next B4
	Pause 500		' Wait .5 second

	Gosub lcdclr		' Clear lcd screen
	For B4 = 0 To 4		' Send string to lcd one letter at a time
		Lookup B4, ("World"), B2	' Get letter from string
		Gosub lcddata	' Send letter in B2 to lcd
	Next B4
	Pause 500		' Wait .5 second

	Goto loop		' Do it forever


' Subroutine to initialize the lcd - uses B0, B1, B2 and B3
lcdinit: Pause 15		' Wait at least 15ms

	Poke PORTC, $03		' Initialize the lcd
	Gosub lcdtog		' Toggle the lcd enable line

	Pause 5			' Wait at least 4.1ms

	Poke PORTC, $03		' Initialize the lcd
	Gosub lcdtog		' Toggle the lcd enable line

	Pause 1			' Wait at least 100us

	Poke PORTC, $03		' Initialize the lcd
	Gosub lcdtog		' Toggle the lcd enable line

	Pause 1			' Wait once more for good luck

	Poke PORTC, $02		' Put lcd into 4 bit mode
	Gosub lcdtog		' Toggle the lcd enable line

	B2 = $28		' 4 bit mode, 2 lines, 5x7 font
	Gosub lcdcom		' Send B2 to lcd

	B2 = $0c		' Lcd display on, no cursor, no blink
	Gosub lcdcom		' Send B2 to lcd

	B2 = $06		' Lcd entry mode set, increment, no shift
	Goto lcdcom		' Exit through send lcd command

' Subroutine to clear the lcd screen - uses B2 and B3
lcdclr:	B2 = 1			' Set B2 to clear command and fall through to lcdcom

' Subroutine to send a command to the lcd - uses B2 and B3
lcdcom:	Poke PORTC, 0		' Set RS to command
lcdcd:	Peek PORTC, B1		' Get RS
	B1 = B1 & %00010000	' Isolate RS
	B3 = B2 / 16 | B1	' Move top 4 bits to bottom
	Poke PORTC, B3		' Send upper 4 bits to lcd
	Gosub lcdtog		' Toggle the lcd enable line

	B3 = B2 & $0f | B1	' Isolate botton 4 bits
	Poke PORTC, B3		' Send lower 4 bits to lcd
	Gosub lcdtog		' Toggle the lcd enable line

	Pause 2			' Wait 2ms for write to complete
	Return

' Subroutine to send data to the lcd - uses B2 and B3
lcddata: Poke PORTC, $10	' Set RS to data
	GoTo lcdcd
 
' Subroutine to toggle the lcd enable line
lcdtog:	Peek PORTC, B0		' Get lcd port data
	Bit5 = 1		' Set lcd enable line high
	Poke PORTC, B0		' Write it out to the port
	Bit5 = 0		' Set lcd enable line low
	Poke PORTC, B0		' Write it out to the port
	Return

	End
