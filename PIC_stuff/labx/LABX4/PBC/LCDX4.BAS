' LCDX4.BAS
'  For PIC12F683 and melabs PICBASIC Compiler
'
' Display "Hello World" on LCD (and serial port)

' Define the ADC registers
Symbol	CMCON0 = $19
Symbol	ADRESH = $1E
Symbol	ADCON0 = $1F
Symbol	ANSEL = $9F

Symbol	LED = 0		' Alias LED to GPIO.0
Symbol	LCD = 1		' Alias LCD transmit pin


	Poke CMCON0, 7	' Analog comparators off
	Poke ANSEL, 0	' Set all digital

	Pause 500	' Wait .5 second for LCD to init


loop:	Serout LCD, T2400, ($fe, 1)	' Clear screen
	Pause 500	' Wait .5 second

	Serout LCD, T2400, ("Hello")	' Display "Hello"
	Pause 500	' Wait .5 second

	Serout LCD, T2400, ($fe, $c0, "World")	' Move to line 2 and display "World"
	Pause 500	' Wait .5 second

	Goto loop	' Do it forever

	End
