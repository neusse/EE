' PICBASIC PRO program to blink all the LEDs connected to PORTD

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

i       Var     Byte    ' Define loop variable

LEDS    Var     PORTD   ' Alias PORTD to LEDS


TRISD = %00000000       ' Set PORTD to all output

mainloop:   LEDS = 1        ' First LED on
        Pause 500       ' Delay for .5 seconds

        For i = 1 To 7  ' Go through For..Next loop 7 times
                LEDS = LEDS << 1        ' Shift on LED one to left
                Pause 500       ' Delay for .5 seconds
        Next i

        Goto mainloop       ' Go back to mainloop and blink LED forever

        End
