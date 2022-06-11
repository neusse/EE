' UPPERX4.BAS
'  For PIC12F683 and melabs PICBASIC Compiler
'
' Upper case serial filter.

' Define the ADC registers
Symbol	CMCON0 = $19
Symbol	ADRESH = $1E
Symbol	ADCON0 = $1F
Symbol	ANSEL = $9F

Symbol	TX = 1			' Define serial out pin
Symbol	RX = 2			' Define serial in pin


	Poke CMCON0, 7		' Analog comparators off
	Poke ANSEL, 0		' Set all digital


loop:   Serin RX, T2400, B0	' B0 = input character
        If B0 < "a" Then print  ' If lower case, convert to upper
	If B0 > "z" Then print  ' If lower case, convert to upper
	B0 = B0 - $20

print:  Serout TX, T2400, (B0)	' Send character
        Goto loop		' Forever

	End
