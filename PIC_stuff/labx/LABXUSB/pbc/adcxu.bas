' PICBASIC program to send result of 
' 8-bit A/D conversion with serout
'
' Connect analog input to channel-0 (RA0)

' Define the ADC registers
Symbol ADCON0 = $1F
Symbol ADCON1 = $9F
Symbol ADRESH = $1E
Symbol TRISA = $85

' Define the USART registers
Symbol  PIR1 =  $0C			' Peripheral Interrupt Flag register
Symbol  RCSTA = $18			' Receive Status and Control register
Symbol  TXREG = $19			' Transmit Data register
Symbol  RCREG = $1A			' Receive Data register
Symbol  TXSTA = $98			' Transmit Status and Control register
Symbol  SPBRG = $99			' Baud Rate Generator register

' Initialize USART
        Poke SPBRG, 129			' Set baud rate to 2400
        Poke RCSTA, %10010000		' Enable serial port and continuous receive
        Poke TXSTA, %00100000		' Enable transmit and asynchronous mode

	Poke TRISA, $FF			' Set PORTA to all input
    	Poke ADCON1, $02		' Set PORTA analog and LEFT justify result
	Poke ADCON0, $C1		' Configure and turn on A/D Module


loop:   Peek ADCON0, B0			' Read current contents of ADCON0
        Bit2 = 1
        Poke ADCON0, B0			' Set ADCON0-bit2 high to start conversion


notdone: Pause 5
        Peek ADCON0, B0			' Store contents of ADCON0 to B0
        If Bit2 = 1 Then notdone	' Wait for low on bit-2 of ADCON0, conversion finished

        Peek ADRESH, B2			' Move HIGH bit of result to B2

	B1 = B2 / 100 + 48: Gosub charout	' Send 100s
	B1 = B1 - 48 * 100
	B2 = B2 - B1
	B1 = B2 / 10 + 48: Gosub charout	' Send 10s
	B1 = B1 - 48 * 10
	B2 = B2 - B1
	B1 = B2 + 48: Gosub charout	' Send 1s

        B1 = 13: Gosub charout		' Send a carriage return
        B1 = 10: Gosub charout		' Send a line feed
		
        Pause 2500			' Wait .5 second

        Goto loop			' Do it forever


' Subroutine to send a character to USART transmitter
charout: Peek PIR1, B0			' Get flag register to B0
        If Bit4 = 0 Then charout	' Wait for transmit register empty

        Poke TXREG, B1			' Send character to transmit register

        Return				' Go back to caller

	End
