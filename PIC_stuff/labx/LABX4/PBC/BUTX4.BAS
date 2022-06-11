' BUTX4.BAS
'  For PIC12F683 and melabs PICBASIC Compiler
'
' Show button press on LED

Symbol	CMCON0 = $19
Symbol	ADRESH = $1E
Symbol	ADCON0 = $1F
Symbol	ANSEL = $9F

Symbol	LED = 0		' Alias LED to GPIO.0
Symbol	S1 = PIN3	' Set push button to GPIO.3


	Poke CMCON0, 7	' Analog comparators off
	Poke ANSEL, 0	' Set all digital


loop:	High LED	' Turn off LED

	' Button press turns on LED (MCLRE must not be enabled)
        If S1 = 1 Then notpressed	' If not pressed skip next
	Low LED		' Pressed so turn on LED

notpressed: Pause 2	' Pause 2mS
	Goto loop	' Do it forever

	End
