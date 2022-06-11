' PICBASIC program to display result of ADC in 3 segment bargraph.
' The last LED in the graph dims or brightens with changes in the 
' analog input.

' Define the ADC registers
Symbol ADCON0 = $1F
Symbol ADCON1 = $9F
Symbol ADRESH = $1E
Symbol TRISA = $85


Symbol	adval = B1			' ADC result variable
Symbol	i = B2				' For-loop variable
Symbol	position = B3			' LED position variable
Symbol	bright = B4			' Brightness variable


	Poke TRISA, $FF			' Set PORTA to all input
    	Poke ADCON1, $02		' Set PORTA analog and LEFT justify result
	Poke ADCON0, $C1		' Configure and turn on A/D Module


loop:   Peek ADCON0, B0			' Read current contents of ADCON0
        Bit2 = 1
        Poke ADCON0, B0			' Set ADCON0-bit2 high to start conversion


notdone: Peek ADCON0, B0		' Store contents of ADCON0 to B0
        If Bit2 = 1 Then notdone	' Wait for low on bit-2 of ADCON0, conversion finished

        Peek ADRESH, adval		' Move HIGH bit of result to B2

	position = adval / 85		' Position of last lit LED
	bright = adval // 85 * 3	' Brightness of last lit LED

	For i = 0 To 2			' Set each LED
		If i < position Then ledon
			Low i		' Turn off if higher than last lit
			Goto lednext

ledon:			High i		' Turn on if lower than last lit LED 
lednext: Next i

	PWM position, bright, 5		' Dim the last LED

        Goto loop			' Do it forever

        End
