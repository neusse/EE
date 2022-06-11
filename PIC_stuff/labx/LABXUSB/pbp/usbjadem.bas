' This USB sample program implements the functionality of the Jan Axelson
' demo which accepts two numbers from the host, increments each and sends
' them back.  An application running on the host sends the numbers and
' displays the returned values.

'  Compilation of this program requires that specific support files be
'  available in the source directory.  You may also need to modify the
'  file USBDESC.ASM so that the proper descriptor files are included. For
'  detailed information, see the file PBP\USB18\USB.TXT.

buffer	Var	Byte[8]
cnt	Var	Byte

Define  OSC     48


	USBInit

' Wait for USB input of 2 numbers.
idleloop:
	USBService	' Must service USB regularly
	cnt = 8		' Specify input buffer size
	USBIn 1, buffer, cnt, idleloop

' Message received.  Increment the bytes and send them back.
	buffer[0] = buffer[0] + 1
	buffer[1] = buffer[1] + 1

outloop:
	USBService	' Must service USB regularly
	USBOut 1, buffer, 2, outloop	' Send the bytes back

	Goto idleloop	' Wait for next buffer
