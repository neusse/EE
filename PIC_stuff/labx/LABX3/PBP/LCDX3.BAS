' PICBASIC PRO program to display "Hello World" on LCD

' Define LCD registers and bits
Define	LCD_DREG	PORTA
Define	LCD_DBIT	0
Define	LCD_RSREG	PORTA
Define	LCD_RSBIT	4
Define	LCD_EREG	PORTB
Define	LCD_EBIT	3


	CMCON = 7		' Set PORTA to digital
	Pause 100		' Wait for LCD to start up

mainloop:	Lcdout $fe, 1		' Clear screen
	Pause 500		' Wait .5 second

	Lcdout "Hello"		' Display "Hello"
	Pause 500		' Wait .5 second

	Lcdout $fe, $c0, "World"	' Move to line 2  and display "World"
	Pause 500		' Wait .5 second

	Goto mainloop		' Do it forever

	End
