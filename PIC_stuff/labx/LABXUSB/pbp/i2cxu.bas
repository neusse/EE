' PICBASIC PRO program to read and write to I2C SEEPROMs
'
' Write to the first 16 locations of an external serial EEPROM
' Read first 16 locations back and send to LCD repeatedly
' Note: for SEEPROMs with byte-sized address

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

SDA	Var	PORTA.4		' Data pin
SCL	Var	PORTA.5		' Clock pin

B0	Var	Byte		' Address
B1	Var	Byte		' Data 1
B2	Var	Byte		' Data 2


	ADCON1 = 15		' Set PORTA and PORTE to digital
	Low PORTE.2		' LCD R/W line low (W)
	Pause 100		' Wait for LCD to start up

	For B0 = 0 To 15	' Loop 16 times
		B1 = B0 + 100	' B1 is data for SEEPROM
		I2CWRITE SDA, SCL, $A0, B0, [B1]	' Write each location
		Pause 10	' Delay 10ms after each write
	Next B0

mainloop:	For B0 = 0 To 15 Step 2	' Loop 8 times
		I2CREAD SDA, SCL, $A0, B0, [B1, B2]	' Read 2 locations in a row
		Lcdout $fe, 1, #B0, ": ", #B1, " ", #B2, " "	' Display 2 locations
		Pause 1000
	Next B0

	Goto mainloop

        End
