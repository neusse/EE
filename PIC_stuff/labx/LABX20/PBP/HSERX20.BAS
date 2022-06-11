' PICBASIC PRO program to send and receive from the hardware serial port
' LEDs count characters and flash error if none received for 10 seconds

char	Var	Byte		' Storage for serial character
cnt	Var	Byte		' Storage for character counter


	ANSEL = %00000000	' Set all pins digital
	ANSELH = %00000000
	TRISA = %11001111	' Set PORTA.4,5 to outputs
	PORTA = 0		' Turn off LEDs
	cnt = 0			' Zero character counter


mainloop:	Hserin 10000, allon, [char]	' Get a char from serial port

	Hserout [char]		' Send char out serial port

	cnt = cnt + 1		' Increment character count
	PORTA = cnt << 4	' Send count to LED

	Goto mainloop		' Do it all over again


allon:	PORTA = %00110000	' Error - no character received
	Pause 500		' Blink all LEDs
	PORTA = 0
	Pause 500
	Goto allon

	End
