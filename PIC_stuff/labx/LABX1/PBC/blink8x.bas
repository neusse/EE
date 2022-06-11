' PICBASIC program to blink 8 LEDS in sequence

Symbol	PORTD = 8		' Set PORTD address
Symbol	TRISD = $88		' Set TRISD address
Symbol	i = B0			' Define loop variable
Symbol	l = B1			' Set storage for LED

	Poke TRISD, %00000000	' Set PORTD to all output

loop:   l = 1			' First LED on
	Poke PORTD, l
        Pause 500		' Delay for .5 seconds

        For i = 1 To 8          ' Go through For..Next loop 8 times
                l = l * 2	' Shift on LED one to left
		Poke PORTD, l
                Pause 500	' Delay for .5 seconds
        Next i

        Goto loop		' Go back to loop and blink LED forever

        End
