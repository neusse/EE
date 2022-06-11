' PICBASIC program to show binary count on 3 LEDS

Symbol	i = B0			' Define loop variable


	DIRS = %00000111	' Set PORTB.0-2 to output

loop:   For i = 0 To 7          ' Go through For..Next loop 8 times
                PINS = i	' Show binary value on LEDs
                Pause 500	' Delay for .5 seconds
        Next i

        Goto loop		' Go back to loop and blink LED forever

        End
