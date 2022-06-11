' TESTX4.BAS
'  For PIC12F683 and melabs PICBASIC PRO Compiler
'
' Test program for LAB-X4

' Disable reset so button can be used
@	device	mclr_off

Include "modedefs.bas"		' Mode definitions for Serout

' Alias pins
LED	Con	0		' Alias GPIO.0 to LED
LCD	Var	GPIO.1		' LCD TX pin
PB	Var	GPIO.3		' Alias GPIO.3 to push button

' Allocate variables
adval	var	byte		' Create adval to store result


	ANSEL = %00001000	' Set AN3 analog, rest digital
	CMCON0 = 7		' Analog comparators off

	Pause 500		' Wait .5 second for LCD to init


mainloop:	ADCIN 3, adval		' Read channel 3 to adval

	Serout LCD, T2400, [$fe, 1]	' Clear screen
	Serout LCD, T2400, ["Pot = ", #adval]	' Display the decimal value

	If PB = 0 Then		' If button pressed...
		Low LED		' Turn on LED
	Else
		High LED	' Turn off LED
	Endif

	Pause 100		' Do it all about 10 times a second

	Goto mainloop		' Do it forever

	End
