' PICBASIC PRO program to display pot on 2 segment bargraph.
' The last LED in the graph dims or brightens with changes in the pot.


potval	Var	Byte		' Pot result variable
i	Var	Byte    	' For-loop variable
position Var	Byte		' LED position variable
bright	Var	Byte		' Brightness variable


        ANSEL = %00000100	' Set PORTA.2 analog, rest digital
        ANSELH = %00000000


mainloop:	Adcin 2, potval		' Read Pot on PORTA.2
	
	position = potval / 127	' Position of last lit LED
	bright = (potval // 127) * 2	' Brightness of last lit LED

	For i = 0 To 1		' Set each LED
		If i < position Then
			High i + 4	' Turn on if lower than last lit LED 
		Else
			Low i + 4	' Turn off if higher than last lit
		Endif
	Next i

	Pwm position + 4, bright, 5	' Dim the last LED

	Goto mainloop		' Do it forever

	End
