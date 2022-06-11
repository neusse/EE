' PICBASIC PRO program to read pots on 16F877 ADC

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

' RESET_ORG can be set to move the BASIC program out of the way
' of any boot loader running from location 0, such as the
' Microchip USB boot loader
'Define	RESET_ORG	800h

Define	OSC	48		' Core is running at 48MHz

' Define LCD pins
Define  LCD_DREG        PORTD
Define  LCD_DBIT        4
Define  LCD_RSREG       PORTE
Define  LCD_RSBIT       0
Define  LCD_EREG        PORTE
Define  LCD_EBIT        1

' Allocate variables
x	Var	byte
y	Var	byte


	ADCON1 = %00001010	' Set PORTA to analog inputs
	Low PORTE.2		' LCD R/W line low (W)
	Pause 100		' Wait for LCD to start

	GoTo mainloop		' Skip subroutines


' Subroutine to read a/d convertor
getad:
	Pauseus 50		' Wait for channel to setup
	ADCON0.1 = 1		' Start conversion
	Pauseus 50		' Wait for conversion
	Return

' Subroutine to get pot x value
getx:
	ADCON0 = $01		' Set A/D Channel 0, On
	Gosub getad
	x = ADRESH
	Return

' Subroutine to get pot y value
gety:
	ADCON0 = $05		' Set A/D Channel 1, On
	Gosub getad
	y = ADRESH
	Return


mainloop:
	GoSub getx		' Get x value
	GoSub gety		' Get y value

	Lcdout $fe, 1, "x=", #x, " y=", #y	' Send values to LCD
	Pause 100		' Do it about 10 times a second

	GoTo mainloop		' Do it forever

	End
