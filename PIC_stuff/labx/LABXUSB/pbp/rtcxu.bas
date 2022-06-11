' PICBASIC PRO LCD clock program using Dallas DS1307 I2C RTC

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

' RESET_ORG can be set to move the BASIC program out of the way
' of any boot loader running from location 0, such as the
' Microchip USB boot loader
'Define	RESET_ORG	800h

Define	OSC	48		' Core is running at 48MHz

Define  LCD_DREG        PORTD   ' Define LCD connections
Define  LCD_DBIT        4
Define  LCD_RSREG       PORTE
Define  LCD_RSBIT       0
Define  LCD_EREG        PORTE
Define  LCD_EBIT        1

' Alias pins
SDA	Var	PORTA.4
SCL	Var	PORTA.5

' Allocate variables
RTCYear	Var	Byte
RTCMonth Var	Byte
RTCDate	Var	Byte
RTCDay	Var	Byte
RTCHour	Var	Byte
RTCMin	Var	Byte
RTCSec	Var	Byte
RTCCtrl Var	Byte


	ADCON1 = 15		' PORTA and E digital
	Low PORTE.2		' LCD R/W low = write
	Pause 100		' Wait for LCD to startup

' Set initial time to 8:00:00AM 06/21/05
	RTCYear = $05
	RTCMonth = $06
	RTCDate = $21
	RTCDay = $02
	RTCHour = $08
	RTCMin = 0
	RTCSec = 0
	RTCCtrl = 0
	Gosub settime		' Set the time

	Goto mainloop		' Skip over subroutines


' Subroutine to write time to RTC
settime:
	I2CWrite SDA, SCL, $D0, $00, [RTCSec, RTCMin, RTCHour, RTCDay, RTCDate, RTCMonth, RTCYear, RTCCtrl]
	Return

' Subroutine to read time from RTC
gettime:
	I2CRead SDA, SCL, $D0, $00, [RTCSec, RTCMin, RTCHour, RTCDay, RTCDate, RTCMonth, RTCYear, RTCCtrl]
	Return

' Main program loop - in this case, it only updates the LCD with the time
mainloop:
	Gosub gettime		' Read the time from the RTC

        ' Display time on LCD
	Lcdout $fe, 1, hex2 RTCMonth, "/", hex2 RTCDate, "/" , hex2 RTCYear,_
		"  ", hex2 RTCHour, ":", hex2 RTCMin, ":", hex2 RTCSec

	Pause 500		' Do it about 2 times a second

	Goto mainloop		' Do it forever

        End
