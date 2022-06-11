' PICBASIC program to show button press on LED

Symbol	PORTD = 8		' Set PORTD address
Symbol	TRISD = $88		' Set TRISD address
Symbol	OPTION_REG = $81	' Set OPTION register address

        POKE OPTION_REG, $7f	' Enable PORTB pull-ups

	DIRS = %00001111	' Set one side of buttons to outputs
	PINS = 0		' Set one side of buttons low

	Poke TRISD, 0		' Set PORTD to all output

loop:	Poke PORTD, 0		' Turn off LEDs

        ' Check any button pressed to toggle on LED
	If PIN7 = 1 Then not4	' If 4th button pressed...
	Peek PORTD, B0
	B0 = B0 | %00001000	' Turn on 4th LED
	Poke PORTD, B0

not4:	If PIN6 = 1 Then not3	' If 3rd button pressed...
	Peek PORTD, B0
	B0 = B0 | %00000100	' Turn on 3rd LED
	Poke PORTD, B0

not3:	If PIN5 = 1 Then not2	' If 2nd button pressed...
	Peek PORTD, B0
	B0 = B0 | %00000010	' Turn on 2nd LED
	Poke PORTD, B0

not2:	If PIN4 = 1 Then not1	' If 1st button pressed...
	Peek PORTD, B0
	B0 = B0 | %00000001	' Turn on 1st LED
	Poke PORTD, B0

not1:	Pause 2			' Pause 2mS
	Goto loop		' Do it forever

        End
