' PICBASIC PRO program to show button press on LED

	ANSEL = %00000000	' Set all pins digital
	ANSELH = %00000000
	WPUA = %00000011	' Enable pullups for buttons
	WPUB = %00000000
	OPTION_REG.7 = 0

	TRISA = %11001111	' Set PORTA.4,5 (LEDs) to output, rest to input


mainloop:	PORTA = 0		' Turn off LEDs

	' Check any button pressed to turn on LED
	If PORTA.0 = 0 Then	' If 1st button pressed...
		PORTA.4 = 1	' Turn on 1st LED
	Endif
	If PORTA.1 = 0 Then	' If 2nd button pressed...
		PORTA.5 = 1	' Turn on 2nd LED
	Endif

	Pause 2			' Pause 2mS
	Goto mainloop		' Do it forever

        End
