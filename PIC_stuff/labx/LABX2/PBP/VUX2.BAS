' PICBASIC PRO program to display result of ADC in 3 segment bargraph.
' The last LED in the graph dims or brightens with changes in the 
' analog input.

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1


' Define ADCIN parameters
Define  ADC_BITS        8	' Set number of bits in result
Define  ADC_CLOCK       3	' Set clock source (3=rc)
Define  ADC_SAMPLEUS    50	' Set sampling time in uS

adval	Var	Byte		' ADC result variable
i	Var     Byte    	' For-loop variable
position Var	Byte		' LED position variable
bright	Var	Byte		' Brightness variable


        ADCON1 = %00000010	' Set PORTA analog

mainloop:   ADCIN 0, adval		' Store ADC value to adval
	
	position = adval / 85	' Position of last lit LED
	bright = (adval // 85) * 3	' Brightness of last lit LED

	For i = 0 To 2		' Set each LED
		If i < position Then
			High i	' Turn on if lower than last lit LED 
		Else
			Low i	' Turn off if higher than last lit
		Endif
	Next i

	PWM position,bright,5	' Dim the last LED

        Goto mainloop		' Do it forever

        End
