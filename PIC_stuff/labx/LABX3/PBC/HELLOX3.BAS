' PICBASIC program to send "Hello World" on serial port

' Send "Hello world" in infinite loop
loop:	Serout 2, T2400, ("Hello", 10, 13)	' Display "Hello", next line
	Pause 500		' Wait .5 second

	Serout 2, T2400, ("World", 10, 13, 10, 13)	' Display "World", skip a line
	Pause 500		' Wait .5 second

	Goto loop		' Do it forever

	End
