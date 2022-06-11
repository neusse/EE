' PICBASIC program to send and receive from the hardware serial port
' LEDs count characters and flash error if none received for 10 seconds

' Define the USART and other registers
Symbol	STATUS = 3		' Set STATUS register address
Symbol	PORTA = 5		' Set PORTA register address
Symbol	PIR1 =  $0C		' Peripheral Interrupt Flag register
Symbol	RCSTA = $18		' Receive Status and Control register
Symbol	TXREG = $19		' Transmit Data register
Symbol	RCREG = $1A		' Receive Data register
Symbol	TRISA = $85		' Set TRISA register address
Symbol	TXSTA = $98		' Transmit Status and Control register
Symbol	SPBRG = $99		' Baud Rate Generator register
Symbol	ANSEL = $11e		' Set ANSEL address
Symbol	ANSELH = $11f		' Set ANSELH address

Symbol	char = B1		' Storage for serial character
Symbol	i = W1			' Storage for loop counter
Symbol	cnt = B4		' Storage for character count


	Poke STATUS, $80	' Set IRP in STATUS register to 1 to access high register banks
	Poke ANSEL, %00000000	' Set all pins digital
	Poke ANSELH, %00000000	' Set all pins digital
	Poke STATUS, 0		' Reset IRP in STATUS register to 0

' Initialize USART
	Poke SPBRG, 25		' Set baud rate to 2400
	Poke RCSTA, %10010000	' Enable serial port and continuous receive
	Poke TXSTA, %00100000	' Enable transmit and asynchronous mode

	Poke TRISA, %00001111	' Set PORTA to all output
	Poke PORTA, 0		' Set LEDs to off

	cnt = 0			' Zero character counter

loop:	For i = 1 To 10000	' Timeout loop count
		Gosub charin	' Get a char from serial port
		If char = 0 Then donext

		Gosub charout	' Send char out serial port
		cnt = cnt + 1	' Increment character count
		B0 = cnt * 16	' Send count to LED
		Poke PORTA, B0	' Write count to PORTA
		Goto loop	' Start it all over again
donext:	Pause 1
	Next i

allon:	B0 = %00100000		' Error - no character received
	Poke PORTA, B0
	Pause 500               ' Blink LEDs
	B0 = %00010000
	Poke PORTA, B0
	Pause 500
	Goto allon


' Subroutine to get a character from USART receiver
charin:	char = 0		' Preset to no character received

	Peek PIR1, B0		' Get Flag register to B0
	If Bit5 = 0 Then ciret	' If no receive flag then exit

	Peek RCREG, char	' Else get received character to B1

ciret:	Return			' Go back to caller


' Subroutine to send a character to USART transmitter
charout: Peek PIR1, B0		' Get flag register to B0
	If Bit4 = 0 Then charout	' Wait for transmit register empty

	Poke TXREG, char	' Send character to transmit register

	Return			' Go back to caller

	End
