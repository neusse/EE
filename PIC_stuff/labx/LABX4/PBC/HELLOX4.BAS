' HELLOX4.BAS
'  For PIC12F683 and melabs PICBASIC Compiler
'
' Send "Hello World" on serial port

' Define the ADC registers
Symbol	CMCON0 = $19
Symbol	ADRESH = $1E
Symbol	ADCON0 = $1F
Symbol	ANSEL = $9F

Symbol	TX = 1		' Alias serial transmit pin


	Poke CMCON0, 7	' Analog comparators off
	Poke ANSEL, 0	' Set all digital


' Send "Hello world" in infinite loop
loop:	Serout TX, T2400, ("Hello", 10, 13)	' Display "Hello", next line
	Pause 500	' Wait .5 second

	Serout TX, T2400, ("World", 10, 13, 10, 13)	' Display "World", skip a line
	Pause 500	' Wait .5 second

	Goto loop	' Do it forever

	End
