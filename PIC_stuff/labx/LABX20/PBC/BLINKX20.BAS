' PICBASIC program to blink an LED connected to PORTA.4 about once a second

Symbol	STATUS = 3		' Set STATUS register address
Symbol	PORTA = 5		' Set PORTA register address
Symbol	TRISA = $85		' Set TRISA register address
Symbol	ANSEL = $11e		' Set ANSEL address
Symbol	ANSELH = $11f		' Set ANSELH address


	Poke STATUS, $80	' Set IRP in STATUS register to 1 to access high register banks
	Poke ANSEL, %00000000	' Set all pins digital
	Poke ANSELH, %00000000	' Set all pins digital
	Poke STATUS, 0		' Reset IRP in STATUS register to 0

	Poke TRISA, 0		' Set PORTA to all output
	Poke PORTA, 0		' Set LEDs to off

loop:	Peek PORTA, B0		' Get PORTA data
	Bit4 = 1		' Turn on LED connected to PORTA.4
	Poke PORTA, B0		' Write data back to PORTA
	Pause 500		' Delay for .5 seconds

	Peek PORTA, B0		' Get PORTA data
	Bit4 = 0		' Turn off LED connected to PORTA.4
	Poke PORTA, B0		' Write data back to PORTA
	Pause 500		' Delay for .5 seconds

	Goto loop		' Go back to loop and blink LED forever

	End
