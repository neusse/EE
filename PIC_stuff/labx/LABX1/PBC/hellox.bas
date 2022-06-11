' PICBASIC program to send "Hello World" on hardware serial port (USART)

' Define the USART registers
Symbol  PIR1 =  $0C             ' Peripheral Interrupt Flag register
Symbol  RCSTA = $18             ' Receive Status and Control register
Symbol  TXREG = $19             ' Transmit Data register
Symbol  RCREG = $1A             ' Receive Data register
Symbol  TXSTA = $98             ' Transmit Status and Control register
Symbol  SPBRG = $99             ' Baud Rate Generator register


' Initialize USART
        Poke SPBRG, 25		' Set baud rate to 2400
        Poke RCSTA, %10010000	' Enable serial port and continuous receive
        Poke TXSTA, %00100000	' Enable transmit and asynchronous mode


' Send "Hello world" in infinite loop
loop:	For B2 = 0 To 12	' Send string to lcd one letter at a time
		Lookup B2, ("Hello world", 13, 10), B1	' Get letter from string
		Gosub charout	' Send letter in B1 to USART
        Next B2
        Pause 500		' Wait .5 second
        Goto loop		' Do it forever


' Subroutine to send a character to USART transmitter
charout: Peek PIR1, B0		' Get flag register to B0
        If Bit4 = 0 Then charout	' Wait for transmit register empty

        Poke TXREG, B1		' Send character to transmit register

        Return			' Go back to caller

	End
