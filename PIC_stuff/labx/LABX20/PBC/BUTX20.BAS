' PICBASIC program to show button press on LED

Symbol	STATUS = 3		' Set STATUS register address
Symbol	PORTA = 5		' Set PORTA register address
Symbol	TRISA = $85		' Set TRISA register address
Symbol	ANSEL = $11e		' Set ANSEL address
Symbol	ANSELH = $11f		' Set ANSELH address
Symbol	WPUA = $95		' Set WPUA address
Symbol	OPTION_REG = $81	' Set OPTION register address


	Poke STATUS, $80	' Set IRP in STATUS register to 1 to access high register banks
	Poke ANSEL, %00000000	' Set all pins digital
	Poke ANSELH, %00000000	' Set all pins digital
	Poke STATUS, 0		' Reset IRP in STATUS register to 0
	Poke WPUA, %00000011	' Enable pull-ups for buttons
	Poke OPTION_REG, $7f

	Poke TRISA, %00001111	' Set PORTA to LEDs out, rest in


loop:
	Poke PORTA, 0		' Set LEDs to off

	' Check any button pressed to toggle on LED
	Peek PORTA, B0		' Get PORTA to bits
	If Bit0 = 1 Then not1	' If 1st button pressed...
	Bit4 = 1		' Turn on LED connected to PORTA.4
	Poke PORTA, B0		' Write data back to PORTA

not1:
	If Bit1 = 1 Then not2	' If 2nd button pressed...
	Bit5 = 1		' Turn on LED connected to PORTA.5
	Poke PORTA, B0		' Write data back to PORTA

not2:
	Pause 2			' Pause 2mS
	Goto loop		' Do it forever

	End
