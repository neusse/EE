' PICBASIC PRO program to show button press on LED

        CMCON = 7               ' PORTA to digital
        OPTION_REG = $7f	' Enable PORTB pull-ups
        TRISB = %11001111       ' Set PORTB.4,5 (LEDs) to output, rest to input

mainloop:	PORTB = 0		' Turn off LEDs

        ' Check any button pressed to toggle on LED
        If PORTB.7 = 0 Then     ' If 1st button pressed...
                PORTB.4 = 1     ' Turn on 1st LED
        Endif
        If PORTA.5 = 0 Then     ' If 2nd button pressed...
                PORTB.5 = 1     ' Turn on 2nd LED
        Endif

	Pause 2			' Pause 2mS
	Goto mainloop		' Do it forever

        End
