' PICBASIC PRO program to blink all the LEDs connected to PORTD

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

' RESET_ORG can be set to move the BASIC program out of the way
' of any boot loader running from location 0, such as the
' Microchip USB boot loader
'Define	RESET_ORG	800h

Define	OSC	48		' Core is running at 48MHz

i       var     byte    	' Define loop variable

LEDS    var     PORTD		' Alias PORTD to LEDS


	TRISD = %00000000	' Set PORTD to all output

mainloop:	LEDS = 1		' First LED on
	Pause 500		' Delay for .5 seconds

	For i = 1 To 3		' Go through For..Next loop 3 times
		LEDS = LEDS << 1	' Shift on LED one to left
		Pause 500	' Delay for .5 seconds
        Next i

        Goto mainloop		' Go back to loop and blink LED forever

        End
