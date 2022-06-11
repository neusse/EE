' PICBASIC program to show button press on LED

Symbol	OPTION_REG = $81

        POKE OPTION_REG, $7f	' Enable PORTB pull-ups

        DIRS = %00000111	' Set PORTB.0-2 (LEDs) to output, 3-7 to input

loop:	PINS = 0		' Turn off LEDs

        ' Check any button pressed to toggle on LED
	If PIN6 = 1 Then not3	' If 3rd button pressed...
	PIN2 = 1		' Turn on 3rd LED

not3:	If PIN5 = 1 Then not2	' If 2nd button pressed...
	PIN1 = 1		' Turn on 2nd LED

not2:	If PIN4 = 1 Then not1	' If 1st button pressed...
	PIN0 = 1		' Turn on 1st LED

not1:	Pause 2			' Pause 2mS
	Goto loop		' Do it forever

        End
