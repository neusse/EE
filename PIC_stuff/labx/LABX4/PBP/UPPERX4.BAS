' UPPERX4.BAS
'  For PIC12F683 and melabs PICBASIC PRO Compiler
'
' Upper case serial filter.

Include "modedefs.bas"		' Include serial modes

TX	Var	GPIO.1		' Define serial out pin
RX	Var	GPIO.2		' Define serial in pin

B0      var     byte


	ANSEL = 0		' Set all digital
	CMCON0 = 7		' Analog comparators off


mainloop:   Serin RX, T2400, B0	' B0 = input character
        If (B0 < "a") or (B0 > "z") Then print  ' If lower case, convert to upper
	B0 = B0 - $20

print:  Serout TX, T2400, [B0]	' Send character
        Goto mainloop		' Forever

	End
