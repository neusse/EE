' PICBASIC PRO program to show button press on LED

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

        OPTION_REG = $7f        ' Enable PORTB pull-ups
        TRISD = 0       ' Set PORTD (LEDs) to all output

mainloop:
        PORTB = 0       ' PORTB lines low to read buttons
        TRISB = $f0     ' Enable all buttons

        PORTD = 0       ' All LEDs off

        ' Check any button pressed to turn on LED
        If PORTB.7 = 0 Then     ' If 4th button pressed...
                PORTD.3 = 1     ' 4th LED on
        Endif
        If PORTB.6 = 0 Then     ' If 3rd button pressed...
                PORTD.2 = 1     ' 3rd LED on
        Endif
        If PORTB.5 = 0 Then     ' If 2nd button pressed...
                PORTD.1 = 1     ' 2nd LED on
        Endif
        If PORTB.4 = 0 Then     ' If 1st button pressed...
                PORTD.0 = 1     ' 1st LED on
        Endif

        Goto mainloop       ' Do it forever

        End
