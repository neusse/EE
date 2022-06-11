' VMETERX4.BAS
'  For PIC12F683 and melabs PICBASIC PRO Compiler
'
' Measure voltage (0-5VDC) and display on LCD with 2 decimal places
'  This program uses the */ operator to scale the
'  ADC result from 0-1023 to 0-500.  The */ performs
'  a divide by 256 automatically, allowing math which
'  would normally exceed the limit of a word variable.
'
'  Connect analog input to channel-3 (RA4)

' Define ADCIN parameters
Define	ADC_BITS	10	' Set number of bits in result
Define	ADC_CLOCK	3	' Set clock source (3=rc)
Define	ADC_SAMPLEUS	50	' Set sampling time in uS


LCD	Var	GPIO.1		' LCD TX pin

T2400	Con	396		' 2400 baud, true

adval	Var	Word		' Create adval to store result


	ADCON0.7 = 1		' Right justify result
	ANSEL = %00001000	' Set AN3 analog, rest digital
	CMCON0 = 7		' Analog comparators off

	Pause 500		' Wait .5 second for LCD to init

mainloop:	ADCIN 3, adval		' Read channel 3 to adval (0-1023)

	adval = (adval */ 500)>>2	' Equates to: (adval * 500)/1024

	Serout2 LCD, T2400, [$fe, 1]	' Clear screen
	Serout2 LCD, T2400, ["DC Volts= ", DEC (adval/100), ".", DEC2 adval]	' Display the decimal value

	Pause 100		' Wait .1 second

	Goto mainloop		' Do it forever

	End
