' PICBASIC program to blink 4 LEDS in sequence

Symbol	PORTD = 8		' Set PORTD address
Symbol	TRISD = $88		' Set TRISD address
Symbol	i = B0			' Define loop variable
Symbol	l = B1			' Set storage for LED

	Poke TRISD, %00000000	' Set PORTD to all output

loop:   l = 1			' First LED on
	Poke PORTD, l
        Pause 2500		' Delay for .5 seconds

        For i = 1 To 3          ' Go through For..Next loop 3 more times
                l = l * 2	' Shift on LED one to left
		Poke PORTD, l
                Pause 2500	' Delay for .5 seconds
        Next i

        Goto loop		' Go back to loop and blink LED forever

        End
