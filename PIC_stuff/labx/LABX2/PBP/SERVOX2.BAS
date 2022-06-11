' PICBASIC PRO program to move RC servo using potentiometer

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

' Define ADCIN parameters
Define  ADC_BITS        10	' Set number of bits in result
Define  ADC_CLOCK       3	' Set clock source (3=rc)
Define  ADC_SAMPLEUS    50	' Set sampling time in uS

pos     Var     Word		' Servo position
servo1  Var     PORTB.3		' Alias servo pin


	TRISA = %11111111	' Set PORTA to all input
	TRISB = %11110000	' Set PORTB.0-3 to output
	PORTB = 0		' Set PORTB.0-3 low
        ADCON1 = %10000010	' Set PORTA analog and right justify result


' Main program loop
mainloop: ADCIN 0, pos		' Store value of analog input in pos

        servo1 = 1		' Start servo pulse
        Pauseus 1000 + pos
        servo1 = 0		' End servo pulse

        Pause 16		' Servo update rate about 60Hz

        Goto mainloop		' Do it all forever

        End
