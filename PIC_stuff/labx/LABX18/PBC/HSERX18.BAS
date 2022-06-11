' HSERX18.BAS
'  For PIC16F88 and melabs PICBASIC Compiler
'
' Send and receive from the hardware serial port
'  LEDs count characters and flash error if none received for 10 seconds

' Define the USART registers
Symbol  PIR1 =  $0C             ' Peripheral Interrupt Flag register
Symbol  RCSTA = $18             ' Receive Status and Control register
Symbol  TXREG = $19             ' Transmit Data register
Symbol  RCREG = $1A             ' Receive Data register
Symbol  TXSTA = $98             ' Transmit Status and Control register
Symbol  SPBRG = $99             ' Baud Rate Generator register

Symbol	char = B1		' Storage for serial character
Symbol	i = W1			' Storage for loop counter
Symbol	cnt = B4		' Storage for character count

' Initialize USART
        Poke SPBRG, 25		' Set baud rate to 2400
        Poke RCSTA, %10010000	' Enable serial port and continuous receive
        Poke TXSTA, %00100000	' Enable transmit and asynchronous mode

        DIRS = %00000001        ' Set LED to output
        PINS = 0                ' Turn off LED

	cnt = 0			' Zero character counter

loop:	For i = 1 To 10000	' Timeout loop count
		Gosub charin	' Get a char from serial port
		If char = 0 Then donext

	        Gosub charout	' Send char out serial port
		cnt = cnt + 1	' Increment character count
                PINS = cnt	' Send count to LED
		Goto loop	' Start it all over again
donext:	Pause 1
	Next i

allon:  PINS = %00000001        ' Error - no character received
        Pause 500               ' Blink LED
        PINS = %00000000
	Pause 500
	Goto allon


' Subroutine to get a character from USART receiver
charin: char = 0		' Preset to no character received

        Peek PIR1, B0		' Get Flag register to B0
        If Bit5 = 0 Then ciret	' If no receive flag then exit

        Peek RCREG, char	' Else get received character to B1

ciret:  Return			' Go back to caller


' Subroutine to send a character to USART transmitter
charout: Peek PIR1, B0		' Get flag register to B0
        If Bit4 = 0 Then charout	' Wait for transmit register empty

        Poke TXREG, char	' Send character to transmit register

        Return			' Go back to caller

        End
