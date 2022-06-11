' BLINKX18.BAS
'  For PIC16F88 and melabs PICBASIC Compiler
'
' Blink an LED connected to PORTB.0 about once a second

loop:   High 0          ' Turn on LED connected to PORTB.0
	Pause 500	' Delay for .5 seconds

        Low 0           ' Turn off LED connected to PORTB.0
	Pause 500	' Delay for .5 seconds

	Goto loop	' Go back to loop and blink LED forever

	End

