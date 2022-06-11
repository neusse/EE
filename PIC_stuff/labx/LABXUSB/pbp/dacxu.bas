' PICBASIC PRO program to demonstrate the use of the MAX549A
' Digital to Analog Converter.  This program causes the DAC
' to output a sawtooth wave on channel A and a sinewave on 
' channel B.  Written for the PIC18F4550 on the LAB-XUSB
' Experimenter Board.  

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

' RESET_ORG can be set to move the BASIC program out of the way
' of any boot loader running from location 0, such as the
' Microchip USB boot loader
'Define	RESET_ORG	800h

Define	OSC	48		' Core is running at 48MHz

CS	Var	PORTC.0		' Alias DAC chip select pin
Sclk	Var	PORTC.1		' Alias DAC serial clock pin
Din	Var 	PORTC.2		' Alias DAC	serial data pin

Achout	Var	Byte		' stores value for DAC A channel
Bchout	Var	Byte		' stores value for DAC B channel

updateA	Con	%00001001	' DAC instruction: update channel A
updateB	Con	%00001010	' DAC instruction: update channel B


	TRISC = %11111000	' Set DAC control pins to output

	CS = 1			' Set chip select high (not selected)
	Sclk = 0		' Set clock low (idle state)

' Loop counts 0 to 255 repeatedly and sends this value to channel A on
' the DAC.  The SIN of the channel A value is sent to channel B. 
mainloop:
	Achout = Achout + 1	' Increment channel A value
	Bchout = (SIN Achout) + 127     ' Calculate SIN, offset by 127 to avoid negative values
	Gosub dacout		' Update DAC
	Goto mainloop		' Do it  forever
	

' Routine to update DAC outputs
dacout:
	CS = 0			' Chip select low to activate serial communication
	Shiftout Din, Sclk, 1, [updateA\8, Achout\8]	' send instruction and value in 16 bits (channel A)
	CS = 1			' Chip select high tells DAC to update output
	CS = 0			' Chip select low to activate serial communication
	Shiftout Din, Sclk, 1, [updateB\8, Bchout\8]	' send instruction and value in 16 bits (channel B)
	CS = 1			' Chip select high tells DAC to update output
	Return

	End
