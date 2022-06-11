' PICBASIC PRO program to blink an LED connected to PORTB.0 about once a second

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

LED     Var     PORTB.0	' Alias PORTB.0 to LED

mainloop:   High LED	' Turn on LED connected to PORTB.0
        Pause 500	' Delay for .5 seconds

        Low LED		' Turn off LED connected to PORTB.0
        Pause 500	' Delay for .5 seconds

        Goto mainloop	' Go back to loop and blink LED forever

        End
