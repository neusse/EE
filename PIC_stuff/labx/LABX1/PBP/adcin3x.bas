' PICBASIC PRO program to display result of 
' 8-bit A/D conversion on LCD
'
' Connect analog inputs to channels 0, 1, 3 (RA0, 1, 3)

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

' Define LCD registers and bits
Define  LCD_DREG        PORTD
Define  LCD_DBIT        4
Define  LCD_RSREG       PORTE
Define  LCD_RSBIT       0
Define  LCD_EREG        PORTE
Define  LCD_EBIT        1

' Define ADCIN parameters
Define  ADC_BITS        8       ' Set number of bits in result
Define  ADC_CLOCK       3       ' Set clock source (3=rc)
Define  ADC_SAMPLEUS    50      ' Set sampling time in uS

adval	Var	Byte		' Create adval to store result


	TRISA = %11111111	' Set PORTA to all input
	ADCON1 = %00000100	' Set PORTA analog

        Pause 500                       ' Wait .5 second


mainloop:
	Lcdout	$fe, 1		' Clear the LCD

	Adcin	0, adval	' Read the first ADC channel
	Lcdout	"0=", #adval	' Send it to the LCD

	Adcin	1, adval	' Read the second ADC channel
	Lcdout	" 1=", #adval	' Send it to the LCD

	Adcin	3, adval	' Read the third ADC channel
	Lcdout	" 3=", #adval	' Send it to the LCD

        Pause   200             ' Delay for time to read the display

        Goto    mainloop        ' Do it forever

        End
