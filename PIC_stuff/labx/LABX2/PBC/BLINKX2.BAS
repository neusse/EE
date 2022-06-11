' PICBASIC program to blink an LED connected to PORTB.0 about once a second

Symbol	LED = 0		' Alias PORTB.0 to LED

loop:	High LED	' Turn on LED connected to PORTB.0
        Pause 500	' Delay for .5 seconds

        Low LED		' Turn off LED connected to PORTB.0
        Pause 500	' Delay for .5 seconds

        Goto loop	' Go back to loop and blink LED forever

        End
