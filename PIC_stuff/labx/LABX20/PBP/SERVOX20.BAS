' PICBASIC PRO program to move RC servo using buttons
'  Button 1 moves servo left, 2 moves servo right
'  Press both buttons to center servo

' Define LCD registers and bits
Define	LCD_DREG	PORTC
Define	LCD_DBIT	0
Define	LCD_RSREG	PORTC
Define	LCD_RSBIT	4
Define	LCD_EREG	PORTC
Define	LCD_EBIT	5

pos	Var	Word		' Servo position

servo1	Var	PORTC.6		' Alias servo pin


	ANSEL = %00000000	' Set all pins digital
	ANSELH = %00000000
	WPUA = %00000011	' Enable pullups for buttons
	WPUB = %00000000
	OPTION_REG.7 = 0

	Pause 100		' Wait for LCD to startup

	Low servo1		' Servo output low

	Gosub center		' Center servo


' Main program loop
mainloop:
	' Check any button pressed to move servo
	If PORTA.0 = 0 Then
		If PORTA.1 = 0 Then
			Gosub center
		Else
			Gosub left
		Endif
	Endif
	If PORTA.1 = 0 Then
		Gosub right
	Endif

	servo1 = 1      	' Start servo pulse
	Pauseus pos		' Delay for servo pulse high time
	servo1 = 0      	' End servo pulse

	Pause 16        	' Servo update rate about 60Hz

	Goto mainloop   	' Do it all forever


' Move servo left
left:	If pos < 2000 Then
		pos = pos + 1
		Gosub display	' Display new position on LCD
	Endif
	Return


' Move servo right
right:  If pos > 1000 Then
		pos = pos - 1
		Gosub display	' Display new position on LCD
	Endif
	Return


' Center servo
center: pos = 1500
'	Gosub display		' Display new position on LCD
'	Return


' Display position on LCD
display: Lcdout $fe, 1, "Position = ", #pos
	Return

	End
