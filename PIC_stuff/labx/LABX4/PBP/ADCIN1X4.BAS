' ADCIN1X4.BAS
'  For PIC12F683 and melabs PICBASIC PRO Compiler
'
' Display result of 10-bit A/D conversion on LCD

Include "modedefs.bas"		' Mode definitions for Serout

' Define ADCIN parameters
Define	ADC_BITS	10	' Set number of bits in result
Define	ADC_CLOCK	3	' Set clock source (3=rc)
Define	ADC_SAMPLEUS	50	' Set sampling time in uS


LCD	Var	GPIO.1		' LCD TX pin

adval	Var	Word		' Create adval to store result


	ADCON0.7 = 1		' Right justify result
	ANSEL = %00111000	' Set AN3 analog, rest digital
	CMCON0 = 7		' Analog comparators off

	Pause 500		' Wait .5 second for LCD to init

mainloop:	ADCIN 3, adval		' Read channel 3 to adval

	Serout LCD, T2400, [$fe, 1]	' Clear screen
	Serout LCD, T2400, ["Value: ", #adval]	' Display the decimal value  

	Pause 100		' Wait .1 second

	Goto mainloop		' Do it forever

	End
