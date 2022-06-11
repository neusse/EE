' USB sample program for PIC18F4550 CDC serial port emulation

'  Compilation of this program requires that specific support files be
'  available in the source directory.  You may also need to modify the
'  file USBDESC.ASM so that the proper descriptor files are included. For
'  detailed information, see the file PBP\USB18\USB.TXT.

buffer	Var	Byte[16]
cnt	Var	Byte

LED	Var	PORTB.0

Define  OSC     48


	USBInit
	Low LED		' LED off

' Wait for USB input
idleloop:
	USBService	' Must service USB regularly
	cnt = 16	' Specify input buffer size
	USBIn 3, buffer, cnt, idleloop

' Message received
	Toggle LED

	buffer[0] = "H"
	buffer[1] = "e"
	buffer[2] = "l"
	buffer[3] = "l"
	buffer[4] = "o"
	buffer[5] = " "
	buffer[6] = "W"
	buffer[7] = "o"
	buffer[8] = "r"
	buffer[9] = "l"
	buffer[10] = "d"
	buffer[11] = 13
	buffer[12] = 10
	buffer[13] = 0

outloop:
	USBService	' Must service USB regularly
	USBOut 3, buffer, 14, outloop

	Goto idleloop	' Wait for next buffer
