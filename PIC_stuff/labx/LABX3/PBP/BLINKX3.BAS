' PICBASIC PRO program to blink an LED connected to PORTB.4 about once a second

LED     Var     PORTB.4 ' Alias PORTB.4 to LED

mainloop:   High LED        ' Turn on LED connected to PORTB.4
        Pause 500	' Delay for .5 seconds

        Low LED         ' Turn off LED connected to PORTB.4
        Pause 500	' Delay for .5 seconds

        Goto mainloop	' Go back to mainloop and blink LED forever

        End
