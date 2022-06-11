' PICBASIC PRO test program for LAB-X20 (16F690)

' Define LCD pins
Define	LCD_DREG	PORTC
Define	LCD_DBIT	0
Define	LCD_RSREG	PORTC
Define	LCD_RSBIT	4
Define	LCD_EREG	PORTC
Define	LCD_EBIT	5

' Alias pins
SW1	Var	PORTA.0
SW2	Var	PORTA.1
AN2	Con	2		' PORTA.2
LED1	Var	PORTA.4
LED2	Var	PORTA.5

' Allocate variables
char	var	byte
x       var     byte


        ANSEL = %00000100	' Set PORTA.2 analog, rest digital
        ANSELH = %00000000
        WPUA = %00000011        ' Enable pullups for buttons
        WPUB = %00000000
        OPTION_REG.7 = 0

        Pause 100               ' Wait for LCD to start


mainloop: Adcin AN2, x		' Read ADC

        Lcdout $fe, 1, "Pot1 = ", #x	' Send value to LCD

        Gosub getchar           ' Get char from serial port

        If char = $55 Then
                Lcdout $fe, $c0, "loopback"
        Endif

	If !SW1 Then		' Check switch 1
		High LED1	' Turn on LED 1
	Else
		Low LED1	' Turn off LED 1
	Endif

	If !SW2 Then		' Check switch 2
		High LED2	' Turn on LED 2
	Else
		Low LED2	' Turn off LED 2
	Endif

        Pause 200		' Do it all about 5 times a second

        Goto    mainloop        ' Do it forever


' Subroutine to get a char from serial port
getchar:
        char = 0
        Hserin 0, tlabel, [char]
tlabel: Hserout [$55]
        Return

        End
