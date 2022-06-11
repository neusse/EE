' BLINKX4.BAS
'  For PIC12F683 and melabs PICBASIC PRO Compiler
'
' Blink an LED connected to GPIO.0 about once a second

LED	Con	0	' Alias GPIO.0 to LED


	ANSEL = 0	' Set all digital
	CMCON0 = 7	' Analog comparators off


mainloop:	Low LED		' Turn on LED connected to GPIO.0
	Pause 500	' Delay for .5 seconds

	High LED	' Turn off LED connected to GPIO.0
	Pause 500	' Delay for .5 seconds

	Goto mainloop	' Go back to mainloop and blink LED forever

	End
