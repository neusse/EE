' PICBASIC program to blink an LED connected to PORTB.4 about once a second

loop:   High 4          ' Turn on LED connected to PORTB.4
	Pause 500	' Delay for .5 seconds

        Low 4           ' Turn off LED connected to PORTB.4
	Pause 500	' Delay for .5 seconds

	Goto loop	' Go back to loop and blink LED forever

	End

