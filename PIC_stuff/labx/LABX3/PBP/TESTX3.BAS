' PICBASIC PRO test program for LAB-X3 (16F628)

' Define LCD pins
Define  LCD_DREG        PORTA
Define  LCD_DBIT        0
Define  LCD_RSREG       PORTA
Define  LCD_RSBIT       4
Define  LCD_EREG        PORTB
Define  LCD_EBIT        3

' Alias pins
S1	Var	PORTB.7
S2	Var	PORTA.5
LED1	Var	PORTB.4
LED2	Var	PORTB.5

' Allocate variables
char	Var	Byte
x       Var     Byte


        CMCON = 7		' Set PORTA to digital

        Pause 100               ' Wait for LCD to start

        Goto mainloop           ' Skip subroutines


' Subroutine to get a char from serial port
getchar:
        char = 0
        Hserin 0, tlabel, [char]
tlabel: Hserout [$55]
        Return


mainloop:
        OPTION_REG.7 = 1        ' Disable PORTB pullups to read pot

	Pot PORTB.0, 127, x

        Lcdout $fe, 1, "pot=", #x	' Send values to LCD

        Gosub getchar           ' Get char from serial port

        If char = $55 Then
                Lcdout $fe, $c0, "loopback"
        Endif

        OPTION_REG.7 = 0        ' Enable PORTB pullups for button

	If !S1 Then		' Check switch 1
		High LED1	' Turn on LED 1
	Else
		Low LED1	' Turn off LED 1
	Endif

	If !S2 Then		' Check switch 2
		High LED2	' Turn on LED 2
	Else
		Low LED2	' Turn off LED 2
	Endif

        Pause 200		' Do it all about 5 times a second

        Goto    mainloop        ' Do it forever

        End
