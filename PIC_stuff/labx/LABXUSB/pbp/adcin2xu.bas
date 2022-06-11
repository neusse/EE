' PICBASIC PRO program to display result of 
' 8-bit A/D conversion on LCD
'
' Connect analog inputs to channels 0, 1 (RA0, 1)

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

' RESET_ORG can be set to move the BASIC program out of the way
' of any boot loader running from location 0, such as the
' Microchip USB boot loader
'Define	RESET_ORG	800h

Define	OSC	48		' Core is running at 48MHz

' Define LCD registers and bits
Define  LCD_DREG        PORTD
Define  LCD_DBIT        4
Define  LCD_RSREG       PORTE
Define  LCD_RSBIT       0
Define  LCD_EREG        PORTE
Define  LCD_EBIT        1

' Define ADCIN parameters
Define	ADC_BITS	8	' Set number of bits in result
Define	ADC_CLOCK	3	' Set clock source (3=rc)
Define	ADC_SAMPLEUS	50	' Set sampling time in uS

adval	var	byte		' Create adval to store result


	TRISA = %11111111	' Set PORTA to all input
	ADCON1 = %00001010	' Set PORTA analog

	Pause 500		' Wait .5 second

mainloop:
	Lcdout $fe, 1		' Clear the LCD

	Adcin 0, adval		' Read the first ADC channel
	Lcdout "0=", #adval	' Send it to the LCD

	Adcin 1, adval		' Read the second ADC channel
	Lcdout " 1=", #adval	' Send it to the LCD

	Pause 200		' Delay for time to read the display

	GoTo mainloop		' Do it forever

	End
