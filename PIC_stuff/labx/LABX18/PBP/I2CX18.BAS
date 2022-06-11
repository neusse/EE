' I2CX18.BAS
'  For PIC16F88 and melabs PICBASIC PRO Compiler
'
' Read and write to I2C SEEPROMs
'  Write to the first 16 locations of an external serial EEPROM
'  Read first 16 locations back and send to LCD repeatedly
'  Note: for SEEPROMs with byte-sized address

' Define LCD registers and bits
Define  LCD_DREG        PORTA
Define  LCD_DBIT        0
Define  LCD_RSREG       PORTB
Define  LCD_RSBIT       6
Define  LCD_EREG        PORTB
Define  LCD_EBIT        3


SDA	Var	PORTB.1		' Data pin
SCL	Var	PORTB.4		' Clock pin

B0	Var	Byte		' Address
B1	Var	Byte		' Data 1
B2	Var	Byte		' Data 2


        ANSEL = 0               ' PORTA is digital
        CMCON = 7               ' PORTA is digital

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
