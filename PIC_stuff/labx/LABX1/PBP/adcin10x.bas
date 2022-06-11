' PICBASIC PRO program to display result of
' 10-bit A/D conversion on LCD
'
' Connect analog input to channel-0 (RA0)

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

' Define LCD registers and bits
Define	LCD_DREG	PORTD
Define	LCD_DBIT	4
Define	LCD_RSREG	PORTE
Define	LCD_RSBIT	0
Define	LCD_EREG	PORTE
Define	LCD_EBIT	1

' Define ADCIN parameters
Define	ADC_BITS	10	' Set number of bits in result
Define	ADC_CLOCK	3	' Set clock source (3=rc)
Define	ADC_SAMPLEUS	50	' Set sampling time in uS

adval	Var	Word		' Create adval to store result


	TRISA = %11111111	' Set PORTA to all input
	ADCON1 = %10000010	' Set PORTA analog and right justify result
	Low PORTE.2		' LCD R/W line low (W)

	Pause 500		' Wait .5 second

mainloop:	ADCIN 0, adval		' Read channel 0 to adval

	Lcdout $fe, 1		' Clear LCD
	Lcdout "Value: ", DEC adval	' Display the decimal value  

	Pause 100		' Wait .1 second

	Goto mainloop		' Do it forever

	End
