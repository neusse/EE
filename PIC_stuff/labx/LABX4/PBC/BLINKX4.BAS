' BLINKX4.BAS
'  For PIC12F683 and melabs PICBASIC Compiler
'
' Blink an LED connected to GPIO.0 about once a second

' Define the ADC registers
Symbol	CMCON0 = $19
Symbol	ADRESH = $1E
Symbol	ADCON0 = $1F
Symbol	ANSEL = $9F

Symbol	LED = 0		' Alias LED to GPIO.0


	Poke CMCON0, 7	' Analog comparators off
	Poke ANSEL, 0	' Set all digital


loop:	Low LED		' Turn on LED connected to GPIO.0
	Pause 500	' Delay for .5 seconds

	High LED	' Turn off LED connected to GPIO.0
	Pause 500	' Delay for .5 seconds

	Goto loop	' Go back to loop and blink LED forever

	End
