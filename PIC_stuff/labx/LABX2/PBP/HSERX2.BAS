' PICBASIC PRO program to send and receive from the hardware serial port
' LEDs count characters and flash error if none received for 10 seconds

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

char	Var	Byte		' Storage for serial character


	TRISB = %11111000	' Set PORTB.0-2 to outputs
	PORTB = 0		' Turn off LEDs

mainloop:   Hserin 10000, allon, [char]	' Get a char from serial port

	PORTB = PORTB + 1	' Increment LED count

        Hserout [char]		' Send char out serial port
	Goto mainloop		' Do it all over again

allon:	PORTB = 7		' Error - no character received
	Pause 500		' Blink all LEDs
	PORTB = 0
	Pause 500
	Goto allon

        End
