' Read an analog voltage on RA0 and send the decimal representation
' of the value on the serial port at 2400 baud.  8-bit conversion
' yields 0-255 result for 0-5 volt input.

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

' Define ADCIN parameters
Define  ADC_BITS        8	' Set number of bits in result
Define  ADC_CLOCK       3	' Set clock source (3=rc)
Define  ADC_SAMPLEUS    50	' Set sampling time in uS

adval	Var Byte		' Create adval to store result


	TRISA = %11111111	' Set PORTA to all input
        ADCON1 = %00000010	' Set PORTA analog

mainloop:	ADCIN 0, adval		' Read channel 0 to adval

	Serout2 PORTC.6, 396, ["Value: ", DEC adval, 13, 10]	' Display value

        Pause 100		' Wait .1 second

        Goto mainloop		' Do it forever

        End
