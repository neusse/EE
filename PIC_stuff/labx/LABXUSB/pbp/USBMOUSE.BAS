' USB sample program for PIC18F4550 to move mouse cursor

'  Compilation of this program requires that specific support files be
'  available in the source directory.  You may also need to modify the
'  file USBDESC.ASM so that the proper descriptor files are included. For
'  detailed information, see the file PBP\USB18\USB.TXT.

buffer	Var	Byte[4]
loopcnt	Var	Byte
state	Var	Byte

Define  OSC     48


	USBInit
	
	buffer[0] = 0
	buffer[1] = 0
	buffer[2] = 0
	buffer[3] = 0

movecursor:
	For state = 0 To 3	' Move through each state
		For loopcnt = 1 To 16	' 16 steps in each direction
			Branch state, [up, right, down, left]

up:
			buffer[1] = 0
			buffer[2] = -2
			Goto endgame
down:
			buffer[1] = 0
			buffer[2] = 2
			Goto endgame
left:
			buffer[1] = -2
			buffer[2] = 0
			Goto endgame
right:
			buffer[1] = 2
			buffer[2] = 0

endgame:
			USBService	' Must service USB regularly
			USBOut 1, buffer, 4, endgame  ' Send buffer to endpoint 1
		Next loopcnt
	Next state
	Goto movecursor	' Do it forever
