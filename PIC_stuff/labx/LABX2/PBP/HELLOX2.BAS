' PICBASIC PRO program to send "Hello World" on serial port

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

Include	"modedefs.bas"		' Mode definitions for Serout


mainloop:	Serout PORTC.6, T2400, ["Hello", 10, 13]	' Display "Hello", next line
	Pause 500		' Wait .5 second

	Serout PORTC.6, T2400, ["World", 10, 13, 10, 13]	' Display "World", skip a line
	Pause 500		' Wait .5 second

	Goto mainloop		' Do it forever

	End
