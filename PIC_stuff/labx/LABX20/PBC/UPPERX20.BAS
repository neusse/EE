' PICBASIC upper case serial filter.

' Define the USART registers
Symbol	STATUS = 3		' Set STATUS register address
Symbol	PIR1 =  $0C		' Peripheral Interrupt Flag register
Symbol	RCSTA = $18		' Receive Status and Control register
Symbol	TXREG = $19		' Transmit Data register
Symbol	RCREG = $1A		' Receive Data register
Symbol	TXSTA = $98		' Transmit Status and Control register
Symbol	SPBRG = $99		' Baud Rate Generator register
Symbol	ANSEL = $11e		' Set ANSEL address
Symbol	ANSELH = $11f		' Set ANSELH address

Symbol	char = B1


	Poke STATUS, $80	' Set IRP in STATUS register to 1 to access high register banks
	Poke ANSEL, %00000000	' Set all pins digital
	Poke ANSELH, %00000000	' Set all pins digital
	Poke STATUS, 0		' Reset IRP in STATUS register to 0

' Initialize USART
	Poke SPBRG, 25		' Set baud rate to 2400
	Poke RCSTA, %10010000	' Enable serial port and continuous receive
	Poke TXSTA, %00100000	' Enable transmit and asynchronous mode

loop:	Gosub charin		' char = input character
	If char < "a" or char > "z" Then print	' If lower case, convert to upper
	char = char - $20
print:	Gosub charout		' Send character
	Goto loop		' Forever

' Subroutine to get a character from USART receiver
charin:	Peek PIR1, B0		' Get Flag register to B0
	If Bit5 = 0 Then charin	' If no receive flag then keep checking

	Peek RCREG, char	' Else get received character to B1

	Return			' Go back to caller


' Subroutine to send a character to USART transmitter
charout: Peek PIR1, B0		' Get flag register to B0
	If Bit4 = 0 Then charout	' Wait for transmit register empty

	Poke TXREG, char	' Send character to transmit register

	Return			' Go back to caller

        End
