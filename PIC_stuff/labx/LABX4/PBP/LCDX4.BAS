' LCDX4.BAS
'  For PIC12F683 and melabs PICBASIC PRO Compiler
'
' Display "Hello World" on LCD (and serial port)

Include "modedefs.bas"		' Mode definitions for Serout

LCD	Var	GPIO.1		' LCD TX pin


	ANSEL = 0		' Set all digital
	CMCON0 = 7		' Analog comparators off

	Pause 500		' Wait .5 second for LCD to init


mainloop:	Serout LCD, T2400, [$fe, 1]	' Clear screen
        Pause 500       	' Wait .5 second

        Serout LCD, T2400, ["Hello"]	' Display "Hello"
        Pause 500       	' Wait .5 second

        Serout LCD, T2400, [$fe, $c0, "World"]	' Move to line 2  and display "World"
        Pause 500       	' Wait .5 second

        Goto mainloop       	' Do it forever

        End
