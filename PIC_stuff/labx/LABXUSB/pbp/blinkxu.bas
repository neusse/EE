' PICBASIC PRO program to blink an LED connected to PORTD.0 about once a second

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

' RESET_ORG can be set to move the BASIC program out of the way
' of any boot loader running from location 0, such as the
' Microchip USB boot loader
'Define	RESET_ORG	800h

Define	OSC	48		' Core is running at 48MHz

LED	Var	PORTD.0		' Alias PORTD.0 to LED


mainloop:	High LED		' Turn on LED connected to PORTD.0
	Pause 500		' Delay for .5 seconds

	Low LED			' Turn off LED connected to PORTD.0
	Pause 500		' Delay for .5 seconds

	Goto mainloop		' Go back to mainloop and blink LED forever

        End
