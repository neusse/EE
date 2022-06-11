' PICBASIC PRO program to read pot and display on LCD

' Define LCD pins
Define	LCD_DREG	PORTC
Define	LCD_DBIT	0
Define	LCD_RSREG	PORTC
Define	LCD_RSBIT	4
Define	LCD_EREG	PORTC
Define	LCD_EBIT	5

' Allocate variables
x	Var	Byte


        ANSEL = %00000100	' Set PORTA.2 analog, rest digital
        ANSELH = %00000000

	Pause 100		' Wait for LCD to start


mainloop: Adcin 2, x		' Read ADC value on AN2 (PORTA.2)

	Lcdout $fe, 1, "Pot1 = ", #x	' Send value to LCD

	Pause 100		' Do it about 10 times a second

	Goto mainloop		' Do it forever

        End
