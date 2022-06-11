' PICBASIC PRO upper case serial filter.

	Include "modedefs.bas"	' Include serial modes

SO	Var	PORTB.7		' Define serial out pin
SI	Var	PORTB.5		' Define serial in pin

B0	Var	Byte


	ANSEL = %00000000	' Set all pins digital
	ANSELH = %00000000


mainloop:	Serin SI, T2400, B0	' B0 = input character
	If (B0 < "a") or (B0 > "z") Then Print	' If upper case, skip conversion
	B0 = B0 - $20		' Lower case so convert to upper

print:	Serout SO, T2400, [B0]	' Send character
	Goto mainloop		' Forever

	End
