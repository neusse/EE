' PICBASIC PRO program to send "Hello World" on serial port

Include "modedefs.bas"		' Mode definitions for Serout


	ANSEL = %00000000	' Set all pins digital
	ANSELH = %00000000


mainloop:	Serout PORTB.7, T2400, ["Hello", 10, 13]	' Display "Hello", move to next line
	Pause 500		' Wait .5 second

	Serout PORTB.7, T2400, ["World", 10, 13, 10, 13]	' Display "World", skip a line
	Pause 500		' Wait .5 second

	Goto mainloop		' Do it forever

	End
