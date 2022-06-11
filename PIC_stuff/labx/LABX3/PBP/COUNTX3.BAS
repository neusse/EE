' PICBASIC PRO program to show binary count on 2 LEDS

i       Var     Byte		' Define loop variable
LEDS    Var     PORTB		' Alias PORTB to LEDS


        TRISB = %11001111       ' Set PORTB.4,5 to output

mainloop:   For i = 0 To 3          ' Go through For..Next loop 4 times
                LEDS = i * 16   ' Show binary value on LEDs
                Pause 500	' Delay for .5 seconds
        Next i

        Goto mainloop		' Go back to loop and blink LED forever

        End
