' PICBASIC PRO program to show binary count on 3 LEDS

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

i       Var     Byte		' Define loop variable
LEDS    Var     PORTB		' Alias PORTB to LEDS


	TRISB = %11111000	' Set PORTB.0-2 to output

mainloop:   For i = 0 To 7          ' Go through For..Next loop 8 times
                LEDS = i	' Show binary value on LEDs
                Pause 500	' Delay for .5 seconds
        Next i

        Goto mainloop		' Go back to loop and blink LED forever

        End
