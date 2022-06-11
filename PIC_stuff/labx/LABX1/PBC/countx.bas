' PICBASIC program to show binary count on 8 LEDS

Symbol	PORTD = 8		' Set PORTD address
Symbol	TRISD = $88		' Set TRISD address
Symbol	i = B0			' Define loop variable

	Poke TRISD, %00000000	' Set PORTD to all output


loop:	For i = 0 To 255	' Go through For..Next loop 255 times
		Poke PORTD, i	' Show binary value on LEDs
		Pause 500	' Delay for .5 seconds
	Next i

	Goto loop		' Go back to loop and blink LED forever

	End
