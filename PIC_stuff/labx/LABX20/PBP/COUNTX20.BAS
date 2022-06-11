' PICBASIC PRO program to show binary count on 2 LEDS

i	Var	Byte		' Define loop variable
LEDS	Var	PORTA		' Alias PORTA to LEDS


	ANSEL = %00000000	' Set all pins digital
	ANSELH = %00000000
	TRISA = %11001111	' Set PORTA.4,5 to output


mainloop:	For i = 0 To 3		' Go through For..Next loop 4 times
		LEDS = i * 16	' Show binary value on LEDs
		Pause 500	' Delay for .5 seconds
	Next i

	Goto mainloop		' Go back to do it forever

        End
