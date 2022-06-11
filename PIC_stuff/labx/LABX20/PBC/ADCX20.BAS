' PICBASIC program to send pot value to serial port

' Define the USART registers
Symbol	STATUS = 3		' Set STATUS register address
Symbol	PIR1 =  $0C		' Peripheral Interrupt Flag register
Symbol	RCSTA = $18		' Receive Status and Control register
Symbol	TXREG = $19		' Transmit Data register
Symbol	RCREG = $1A		' Receive Data register
Symbol	ADRESH = $1e		' Set ADRESH address
Symbol	ADCON0 = $1f		' Set ADCON0 address
Symbol	TXSTA = $98		' Transmit Status and Control register
Symbol	SPBRG = $99		' Baud Rate Generator register
Symbol	ANSEL = $11e		' Set ANSEL address
Symbol	ANSELH = $11f		' Set ANSELH address


' Initialize analog
	Poke STATUS, $80	' Set IRP in STATUS register to 1 to access high register banks
	Poke ANSEL, %00000100	' Set AN2 analog, rest digital
	Poke ANSELH, %00000000	' Set all pins digital
	Poke STATUS, 0		' Reset IRP in STATUS register to 0
	Poke ADCON0, %00001001	' Configure and turn on A/D Module

' Initialize USART
	Poke SPBRG, 25		' Set baud rate to 2400
	Poke RCSTA, %10010000	' Enable serial port and continuous receive
	Poke TXSTA, %00100000	' Enable transmit and asynchronous mode


loop:   GoSub readadc		' Read pot on AN2

	B1 = B2 / 100 + 48: Gosub charout	' Send 100s
	B1 = B1 - 48 * 100
	B2 = B2 - B1
	B1 = B2 / 10 + 48: Gosub charout	' Send 10s
	B1 = B1 - 48 * 10
	B2 = B2 - B1
	B1 = B2 + 48: Gosub charout	' Send 1s

	B1 = 13: Gosub charout	' Send a carriage return
	B1 = 10: Gosub charout	' Send a line feed

	Pause 500		' Wait .5 second

	Goto loop		' Do it forever


' Subroutine to read ADC
readadc: Peek ADCON0, B0	' Read current contents of ADCON0
        Bit1 = 1		' Set bit 1 of B0
        Poke ADCON0, B0		' Set ADCON0.1 high to start conversion

notdone: Peek ADCON0, B0	' Store contents of ADCON0 to B0
	If Bit1 = 1 Then notdone	' Wait for low on ADCON0.1, conversion finished

	Peek ADRESH, B2		' Move result to B2
	Return


' Subroutine to send a character to USART transmitter
charout: Peek PIR1, B0		' Get flag register to B0
	If Bit4 = 0 Then charout	' Wait for transmit register empty

	Poke TXREG, B1		' Send character to transmit register

	Return			' Go back to caller

	End
