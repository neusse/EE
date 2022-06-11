' PICBASIC program to move RC servo using potentiometer

' Define the ADC registers
Symbol	ADCON0 = $1F
Symbol	ADCON1 = $9F
Symbol	ADRESH = $1E
Symbol	TRISA = $85

Symbol	pos = B1		' Storage for servo position
Symbol	servo1 = 3		' Alias servo pin


	Poke TRISA, $FF		' Set PORTA to all input
    	Poke ADCON1, $02	' Set PORTA analog and LEFT justify result
	Poke ADCON0, $C1	' Configure and turn on A/D Module
	DIRS = %00001111	' Set PORTB.0-3 to output
	PINS = 0		' Set PORTB.0-3 low


' Main program loop
mainloop: Peek ADCON0, B0	' Read current contents of ADCON0
        Bit2 = 1
        Poke ADCON0, B0		' Set ADCON0-bit2 high to start conversion


notdone: Peek ADCON0, B0	' Store contents of ADCON0 to B0
        If Bit2 = 1 Then notdone	' Wait for low on bit-2 of ADCON0, conversion finished

        Peek ADRESH, pos	' Get pot reading

	pos = pos / 3 + 100
        Pulsout servo1, pos	' Move servo

        Pause 16		' Servo update rate about 60Hz

        Goto mainloop		' Do it all forever

        End
