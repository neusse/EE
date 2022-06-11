' PICBASIC PRO upper case serial filter.

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

        Include "modedefs.bas"	' Include serial modes

SO	Var	PORTC.6		' Define serial out pin
SI	Var	PORTC.7 	' Define serial in pin
B0      Var     Byte

mainloop:   Serin SI, T2400, B0	' B0 = input character
        If (B0 < "a") or (B0 > "z") Then print  ' If lower case, convert to upper
	B0 = B0 - $20
print:  Serout SO, T2400, [B0]	' Send character
        Goto mainloop		' Forever

	End
