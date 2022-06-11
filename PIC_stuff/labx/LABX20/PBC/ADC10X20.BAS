' PICBASIC program to display 10-bit pot value on LCD

Symbol	STATUS = 3		' Set STATUS register address
Symbol	PORTC = 7		' PORTC is register 7
Symbol	ADRESH = $1e		' Set ADRESH address
Symbol	ADCON0 = $1f		' Set ADCON0 address
Symbol	TRISC = $87		' PORTC data direction is register hexadecimal 87
Symbol	ADRESL = $9e		' Set ADRESL address
Symbol	ANSEL = $11e		' Set ANSEL address
Symbol	ANSELH = $11f		' Set ANSELH address


	Poke STATUS, $80	' Set IRP in STATUS register to 1 to access high register banks
	Poke ANSEL, %00000100	' Set all pins digital
	Poke ANSELH, %00000000	' Set all pins digital
	Poke STATUS, 0		' Reset IRP in STATUS register to 0
	Poke ADCON0, %10001001	' Configure and turn on A/D Module
	Poke TRISC, 0		' Set PORTC to all out

	Pause 100		' Wait for LCD to power up

	Gosub lcdinit		' Initialize the lcd

loop:	Gosub lcdclr		' Clear lcd screen
	For B4 = 0 To 6		' Send string to lcd one letter at a time
		Lookup B4, ("Pot1 = "), B2	' Get letter from string
		Gosub lcddata	' Send letter in B2 to lcd
	Next B4
	
	GoSub readadc		' Read ADC value
	B5 = 1			' Set zero blanking on
	
'	B2 = W3 / 10000		' Get highest digit to display
'	W3 = W3 // 10000	' Remove any high digits from remainder
'	GoSub lcdnum		' Send number in B2 to lcd

	B2 = W3 / 1000		' Get next digit to display
	W3 = W3 // 1000		' Remove digit from remainder
	GoSub lcdnum		' Send number in B2 to lcd

	B2 = W3 / 100		' Get next digit to display
	W3 = W3 // 100		' Remove digit from remainder
	GoSub lcdnum		' Send number in B2 to lcd

	B2 = W3 / 10		' Get next digit to display
	W3 = W3 // 10		' Remove digit from remainder
	GoSub lcdnum		' Send number in B2 to lcd

	B2 = W3			' Get last digit to display
	B5 = 0			' No blanking on last digit
	GoSub lcdnum		' Send number in B2 to lcd

	Pause 200		' Wait .2 second

	Goto loop		' Do it forever


' Subroutine to read ADC
readadc: Peek ADCON0, B0	' Read current contents of ADCON0
        Bit1 = 1		' Set bit 1 of B0
        Poke ADCON0, B0		' Set ADCON0.1 high to start conversion

notdone: Peek ADCON0, B0	' Store contents of ADCON0 to B0
	If Bit1 = 1 Then notdone	' Wait for low on ADCON0.1, conversion finished

	Peek ADRESL, B6		' Move low result to B6 (W3)
	Peek ADRESH, B7		' Move high result to B7
	Return


' Subroutine to display zero blanked digit on lcd
lcdnum:	If B5 = 0 Then lcdnuma	' Check blanking
	If B2 = 0 Then lcdnume	' Don't display zero
	B5 = 0			' It's a number other than zero so clear blanking
lcdnuma: B2 = B2 + 48		' Add ASCII offset to display number
	GoTo lcddata		' Send number and return
lcdnume: Return


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
