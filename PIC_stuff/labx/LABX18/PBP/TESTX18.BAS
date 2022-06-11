' TESTX18.BAS
'  For PIC16F88 and melabs PICBASIC PRO Compiler
'
' PICBASIC PRO test program for LAB-X18

' Define LCD pins
Define  LCD_DREG        PORTA
Define  LCD_DBIT        0
Define  LCD_RSREG       PORTB
Define  LCD_RSBIT       6
Define  LCD_EREG        PORTB
Define  LCD_EBIT        3

' Alias pins
LED1	Var	PORTB.0
S1	Var	PORTB.7

' Allocate variables
char	Var	Byte
x       Var     Byte


        ANSEL = %00010000       ' Make the pot analog and rest digital
        CMCON = 7		' Set PORTA to digital
        OPTION_REG.7 = 0        ' Enable PORTB pullups for button

        Pause 100               ' Wait for LCD to start

        Goto mainloop           ' Skip subroutines


' Subroutine to get a char from serial port
getchar:
        char = 0
        Hserin 0, tlabel, [char]
tlabel: Hserout [$55]
        Return


mainloop:
	Adcin 4, x		' Read pot

        Lcdout $fe, 1, "pot=", #x	' Send values to LCD

        Gosub getchar           ' Get char from serial port

        If char = $55 Then
                Lcdout $fe, $c0, "loopback"
        Endif

	If !S1 Then		' Check switch 1
		High LED1	' Turn on LED 1
	Else
		Low LED1	' Turn off LED 1
	Endif

        Pause 200		' Do it all about 5 times a second

        Goto    mainloop        ' Do it forever

        End
