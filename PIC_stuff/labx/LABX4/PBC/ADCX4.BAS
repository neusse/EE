' ADCX4.BAS
'  For PIC12F683 and melabs PICBASIC Compiler
'
' Display 8-bit A/D conversion from potentiometer

' Connect analog input to channel-3 (RA4)

' Define the ADC registers
Symbol	CMCON0 = $19
Symbol	ADRESH = $1E
Symbol	ADCON0 = $1F
Symbol	ANSEL = $9F

Symbol	LCD = 1			' LCD TX pin


	Poke CMCON0, 7		' Analog comparators off
	Poke ANSEL, %00111000	' Set AN3 analog, rest digital, rc clock
	Poke ADCON0, %00001101	' Configure and turn on A/D Module

	Pause 500		' Wait .5 second for LCD to init


loop:   Peek ADCON0, B0		' Read current contents of ADCON0
        Bit1 = 1		' Set bit 1 of B0
        Poke ADCON0, B0		' Set ADCON0.1 high to start conversion

notdone: Peek ADCON0, B0	' Store contents of ADCON0 to B0
	If Bit1 = 1 Then notdone	' Wait for low on ADCON0.1, conversion finished

	Peek ADRESH, B0		' Move result to B0
	Serout LCD, T2400, ($fe, 1, "Pot = ", #B0)	' Clear screen and display value
	Pause 500		' Wait .5 second

	Goto loop		' Do it forever

	End
