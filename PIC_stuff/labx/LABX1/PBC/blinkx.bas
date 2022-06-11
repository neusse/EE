' PICBASIC program to blink an LED connected to PORTD.0 about once a second

Symbol	PORTD = 8	' Set PORTD address
Symbol	TRISD = $88	' Set TRISD address

	Poke TRISD, 0	' Set PORTD to all output

loop:	Poke PORTD, 1	' Turn on LED connected to PORTD.0
	Pause 500	' Delay for .5 seconds

	Poke PORTD, 0	' Turn off LED connected to PORTD.0
	Pause 500	' Delay for .5 seconds

	Goto loop	' Go back to loop and blink LED forever

	End
