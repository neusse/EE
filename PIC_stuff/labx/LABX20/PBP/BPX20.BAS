' PICBASIC PRO program to simulate an LCD Backpack

' Define LCD registers and bits
Define	LCD_DREG	PORTC
Define	LCD_DBIT	0
Define	LCD_RSREG	PORTC
Define	LCD_RSBIT	4
Define	LCD_EREG	PORTC
Define	LCD_EBIT	5


char	Var	Byte		' Storage for serial character
mode	Var	Byte		' Storage for serial mode
rcv	Var	PORTB.5		' Serial receive pin
baud	Var	PORTA.0		' Baud rate pin - 0 = 2400, 1 = 9600
state	Var	PORTA.1		' Inverted or true serial data - 1 = true


	ANSEL = %00000000	' Set all pins digital
	ANSELH = %00000000
	WPUA = %00000011	' Enable pullups for buttons
	WPUB = %00000000
	OPTION_REG.7 = 0

	Pause 100		' Wait for LCD to startup

	mode = 0		' Set mode, baud rate = 2400, true

	If (baud == 1) Then
		mode = 2	' Set baud rate to 9600
	Endif

	If (state == 0) Then
		mode = mode + 4 ' Set inverted
	Endif


	Lcdout $fe, 1		' Initialize and clear display

mainloop:	Serin rcv, mode, char	' Get a char from serial input
	Lcdout char		' Send char to display
	Goto mainloop		' Do it all over again

	End
