' UPPERX18.BAS
'  For PIC16F88 and melabs PICBASIC PRO Compiler
'
' Upper case serial filter.

        Include "modedefs.bas"	' Include serial modes

SI      Var     PORTB.2         ' Define serial in pin
SO      Var     PORTB.5         ' Define serial out pin

B0      Var     Byte

mainloop:   Serin SI, T2400, B0	' B0 = input character
        If (B0 < "a") or (B0 > "z") Then print  ' If lower case, convert to upper
	B0 = B0 - $20

print:  Serout SO, T2400, [B0]	' Send character
        Goto mainloop		' Forever

	End
