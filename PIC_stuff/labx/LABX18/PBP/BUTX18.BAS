' BUTX18.BAS
'  For PIC16F88 and melabs PICBASIC PRO Compiler
'
' Show button press on LED

        ANSEL = 0               ' PORTA is digital
        CMCON = 7               ' PORTA to digital
        OPTION_REG = $7f	' Enable PORTB pull-ups
        TRISB = %11111110       ' Set PORTB.0 (LED) to output, rest to input

mainloop:	PORTB = 0		' Turn off LED

        If PORTB.7 = 0 Then     ' If button pressed...
                PORTB.0 = 1     ' Turn on LED
        Endif

	Pause 2			' Pause 2mS
	Goto mainloop		' Do it forever

        End
