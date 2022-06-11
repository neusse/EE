' PICBASIC program to send pot value to serial port

' Define the USART registers
Symbol  PIR1 =  $0C			' Peripheral Interrupt Flag register
Symbol  RCSTA = $18			' Receive Status and Control register
Symbol  TXREG = $19			' Transmit Data register
Symbol  RCREG = $1A			' Receive Data register
Symbol  TXSTA = $98			' Transmit Status and Control register
Symbol  SPBRG = $99			' Baud Rate Generator register

' Initialize USART
        Poke SPBRG, 25			' Set baud rate to 2400
        Poke RCSTA, %10010000		' Enable serial port and continuous receive
        Poke TXSTA, %00100000		' Enable transmit and asynchronous mode


loop:   Pot 0, 127, B2


	B1 = B2 / 100 + 48: Gosub charout	' Send 100s
	B1 = B1 - 48 * 100
	B2 = B2 - B1
	B1 = B2 / 10 + 48: Gosub charout	' Send 10s
	B1 = B1 - 48 * 10
	B2 = B2 - B1
	B1 = B2 + 48: Gosub charout	' Send 1s

        B1 = 13: Gosub charout		' Send a carriage return
        B1 = 10: Gosub charout		' Send a line feed
		
        Pause 500			' Wait .5 second

        Goto loop			' Do it forever


' Subroutine to send a character to USART transmitter
charout: Peek PIR1, B0			' Get flag register to B0
        If Bit4 = 0 Then charout	' Wait for transmit register empty

        Poke TXREG, B1			' Send character to transmit register

        Return				' Go back to caller

        End
