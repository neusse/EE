' HSERX18.BAS
'  For PIC16F88 and melabs PICBASIC PRO Compiler
'
' Send and receive from the hardware serial port
'  LED count characters and flash error if none received for 10 seconds

char	Var	Byte		' Storage for serial character
cnt	Var	Byte		' Storage for character counter


	TRISB = %11111110	' Set PORTB.0 to output
	PORTB = 0		' Turn off LED
	cnt = 0			' Zero character counter

mainloop:   Hserin 10000, allon, [char]	' Get a char from serial port

        Hserout [char]		' Send char out serial port

	cnt = cnt + 1		' Increment character count
	PORTB = cnt		' Send count to LED

	Goto mainloop		' Do it all over again

allon:	PORTB = %00000001	' Error - no character received
	Pause 500		' Blink LED
	PORTB = 0
	Pause 500
	Goto allon

        End
