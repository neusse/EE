' I2CX4.BAS
'  For PIC12F683 and melabs PICBASIC PRO Compiler
'
' Read and write to I2C SEEPROMs
'  Write to the first 16 locations of an external serial EEPROM
'  Read first 16 locations back and send to LCD repeatedly
'  Note: for SEEPROMs with byte-sized address

Include "modedefs.bas"		' Mode definitions for Serout

LCD	Var	GPIO.1		' LCD TX pin
SCL	Var	GPIO.4		' Clock pin
SDA	Var	GPIO.5		' Data pin

B0	Var	Byte		' Address
B1	Var	Byte		' Data 1
B2	Var	Byte		' Data 2

	ANSEL = 0		' Set all digital
	CMCON0 = 7		' Analog comparators off

	OPTION_REG.7 = 0	' Enable internal pull ups

	Pause 500		' Wait for LCD to start up

	For B0 = 0 To 15	' Loop 16 times
		B1 = B0 + 100	' B1 is data for SEEPROM
		I2CWRITE SDA, SCL, $A0, B0, [B1]	' Write each location
		Pause 10	' Delay 10ms after each write
	Next B0

mainloop:	For B0 = 0 To 15 Step 2	' Loop 8 times
		I2CREAD SDA, SCL, $A0, B0, [B1, B2]	' Read 2 locations in a row
                Serout LCD, T2400, [$fe, 1, #B0, ": ", #B1, " ", #B2]	' Display 2 locations
		Pause 1000	' Wait 1 second
	Next B0

        Goto mainloop

	End
