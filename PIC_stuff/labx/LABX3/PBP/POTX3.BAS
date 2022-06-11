' PICBASIC PRO program to read pot and display on LCD

' Define LCD pins
Define  LCD_DREG        PORTA
Define  LCD_DBIT        0
Define  LCD_RSREG       PORTA
Define  LCD_RSBIT       4
Define  LCD_EREG        PORTB
Define  LCD_EBIT        3

' Allocate variables
x       Var     Byte


        CMCON = 7               ' Set PORTA to digital

        Pause 100               ' Wait for LCD to start


mainloop: Pot PORTB.0, 127, x

        Lcdout $fe, 1, "pot=", #x       ' Send value to LCD

        Pause   100             ' Do it about 10 times a second

        Goto    mainloop        ' Do it forever

        End
