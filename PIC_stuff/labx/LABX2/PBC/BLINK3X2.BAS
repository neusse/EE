' PICBASIC program to blink 3 LEDS in sequence

Symbol	i = B0			' Define loop variable

	DIRS = %11111111	' Set PORTB to all output

loop:   PINS = 1		' First LED on
        Pause 500		' Delay for .5 seconds

        For i = 1 To 2          ' Go through For..Next loop 2 times
                PINS = PINS * 2	' Shift on LED one to left
                Pause 500	' Delay for .5 seconds
        Next i

        Goto loop		' Go back to loop and blink LED forever

        End
