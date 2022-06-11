' PICBASIC program to demonstrate operation of an LCD in 4-bit mode

Symbol  PORTA = 5       ' PORTA is register 5
Symbol  TRISA = $85     ' PORTA data direction is register hexadecimal 85
Symbol  CMCON = $1f     ' CMCON is register hexadecimal 1f

        Poke CMCON, 7   ' Set analog pins to digital
        Poke TRISA, 0   ' Set all PORTA lines to output

	Pause 100	' Wait for LCD to power up

	Gosub lcdinit	' Initialize the lcd

loop:	Gosub lcdclr	' Clear lcd screen
	For B4 = 0 to 4	' Send string to lcd one letter at a time
		Lookup B4, ("Hello"), B2	' Get letter from string
		Gosub lcddata	' Send letter in B2 to lcd
	Next B4
	Pause 500	' Wait .5 second

	Gosub lcdclr	' Clear lcd screen
	For B4 = 0 to 4	' Send string to lcd one letter at a time
                Lookup B4, ("World"), B2        ' Get letter from string
		Gosub lcddata	' Send letter in B2 to lcd
	Next B4
	Pause 500	' Wait .5 second

	Goto loop	' Do it forever


' Subroutine to initialize the lcd - uses B2 and B3
lcdinit: Pause 15	' Wait at least 15ms

        Poke PORTA, $03 ' Initialize the lcd
	Gosub lcdtog	' Toggle the lcd enable line

	Pause 5		' Wait at least 4.1ms

        Poke PORTA, $03 ' Initialize the lcd
	Gosub lcdtog	' Toggle the lcd enable line

	Pause 1		' Wait at least 100us

        Poke PORTA, $03 ' Initialize the lcd
	Gosub lcdtog	' Toggle the lcd enable line

	Pause 1		' Wait once more for good luck

        Poke PORTA, $02 ' Put lcd into 4 bit mode
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
lcdcom: Poke PORTA, 0   ' Set RS to command
lcdcd:  Peek PORTA, B0  ' Get RS
        B0 = B0 & %00010000     ' Isolate RS
        B3 = B2 / 16 | B0       ' Move top 4 bits to bottom
        Poke PORTA, B3  ' Send upper 4 bits to lcd
	Gosub lcdtog	' Toggle the lcd enable line

        B3 = B2 & $0f | B0      ' Isolate botton 4 bits
        Poke PORTA, B3  ' Send lower 4 bits to lcd
	Gosub lcdtog	' Toggle the lcd enable line

        Pause 2         ' Wait 2ms for write to complete
	Return

' Subroutine to send data to the lcd - uses B2 and B3
lcddata: Poke PORTA, $10        ' Set RS to data
	Goto lcdcd
 
' Subroutine to toggle the lcd enable line
lcdtog:
        High 3                  ' Set lcd enable line high
        Low 3                   ' Set lcd enable line low
	Return

        End
