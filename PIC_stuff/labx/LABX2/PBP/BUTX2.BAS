' PICBASIC PRO program to show button press on LED

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

        OPTION_REG = $7f	' Enable PORTB pull-ups
        TRISB = %11111000	' Set PORTB.0-2 (LEDs) to output, 3-7 to input

mainloop:	PORTB = 0		' Turn off LEDs

        ' Check any button pressed to toggle on LED
        If PORTB.6 = 0 Then	' If 3rd button pressed...
                PORTB.2 = 1	' Turn on 3rd LED
        Endif
        If PORTB.5 = 0 Then	' If 2nd button pressed...
                PORTB.1 = 1	' Turn on 2nd LED
        Endif
        If PORTB.4 = 0 Then	' If 1st button pressed...
                PORTB.0 = 1	' Turn on 1rst LED
        Endif
	Pause 2			' Pause 2mS
	Goto mainloop		' Do it forever

        End
