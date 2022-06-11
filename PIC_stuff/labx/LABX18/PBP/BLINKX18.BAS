' BLINKX18.BAS
'  For PIC16F88 and melabs PICBASIC PRO Compiler
'
' Blink an LED connected to PORTB.0 about once a second

LED     Var     PORTB.0 ' Alias PORTB.4 to LED

mainloop:   High LED        ' Turn on LED connected to PORTB.4
        Pause 500	' Delay for .5 seconds

        Low LED         ' Turn off LED connected to PORTB.4
        Pause 500	' Delay for .5 seconds

        Goto mainloop	' Go back to mainloop and blink LED forever

        End
