' BUTX4.BAS
'  For PIC12F683 and melabs PICBASIC PRO Compiler
'
' Show button press on LED

' Disable reset so button can be used
@	device	mclr_off

LED	Con	0		' Alias GPIO.0 to LED
PB	Var	GPIO.3		' Alias GPIO.3 to push button


	ANSEL = 0		' Set all digital
	CMCON0 = 7		' Analog comparators off


mainloop:   ' Button press turns on LED (MCLRE must not be enabled)
	If PB = 0 Then		' If button pressed...
		Low LED		' Turn on LED
	Else
		High LED	' Turn off LED
	Endif

	Goto mainloop		' Do it forever

	End
