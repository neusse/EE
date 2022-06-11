' PICBASIC PRO program to read and write to I2C SEEPROMs
' that require a word-sized address
'
' Write to the first 16 locations of an external serial EEPROM
' Read first 16 locations back and send to LCD repeatedly

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

' RESET_ORG can be set to move the BASIC program out of the way
' of any boot loader running from location 0, such as the
' Microchip USB boot loader
'Define	RESET_ORG	800h

Define	OSC	48		' Core is running at 48MHz

' Define LCD registers and bits
DEFINE  LCD_DREG        PORTD
DEFINE  LCD_DBIT        4
DEFINE  LCD_RSREG       PORTE
DEFINE  LCD_RSBIT       0
DEFINE  LCD_EREG        PORTE
DEFINE  LCD_EBIT        1

SDA	Var	PORTA.4		' Data pin
SCL	Var	PORTA.5		' Clock pin

address	Var	Word		' Address
B1	Var	Byte		' Data 1
B2	Var	Byte		' Data 2


	ADCON1 = 15		' Set PORTA and PORTE to digital
	Low PORTE.2		' LCD R/W line low (W)
	Pause 100		' Wait for LCD to start up

	For address = 0 To 15	' Loop 16 times
		B1 = address + 100	' B1 is data for SEEPROM
		I2CWrite SDA, SCL, $A0, address, [B1]	' Write each location
		Pause 10	' Delay 10ms after each write
	Next address

mainloop:	For address = 0 To 15 Step 2	' Loop 8 times
		I2CRead SDA, SCL, $A0, address, [B1, B2]	' Read 2 locations in a row
		LCDOut $fe, 1, #address, ": ", #B1, " ", #B2, " "	' Display 2 locations
		Pause 1000
	Next address

	GoTo mainloop

        End
