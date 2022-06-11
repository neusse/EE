' ADCX18.BAS
'  For PIC16F88 and melabs PICBASIC PRO Compiler
'
' Read pot and display on LCD

' Define LCD pins
Define  LCD_DREG        PORTA
Define  LCD_DBIT        0
Define  LCD_RSREG       PORTB
Define  LCD_RSBIT       6
Define  LCD_EREG        PORTB
Define  LCD_EBIT        3

' Allocate variables
x       Var     Byte


        ANSEL = %00010000       ' Make the pot analog and rest digital
        CMCON = 7               ' Set PORTA to digital

        Pause 100               ' Wait for LCD to start


mainloop: Adcin 4, x		' Read the pot

        Lcdout $fe, 1, "pot=", #x       ' Send value to LCD

        Pause   100             ' Do it about 10 times a second

        Goto    mainloop        ' Do it forever

        End
