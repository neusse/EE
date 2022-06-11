' BPX18.BAS
'  For PIC16F88 and melabs PICBASIC PRO Compiler
'
' Simulate an LCD Backpack

' Define LCD registers and bits
Define  LCD_DREG        PORTA
Define  LCD_DBIT        0
Define  LCD_RSREG       PORTB
Define  LCD_RSBIT       6
Define  LCD_EREG        PORTB
Define  LCD_EBIT        3


char    Var     Byte            ' Storage for serial character
mode    Var     Byte            ' Storage for serial mode
rcv     Var     PORTB.2         ' Serial receive pin
baud    Var     PORTB.7         ' Baud rate pin - 1 = 2400, 0 = 9600
state   Var     PORTA.4         ' Inverted or true serial data - 1 = true


        ANSEL = 0               ' PORTA is digital
        CMCON = 7               ' PORTA is digital
        OPTION_REG.7 = 0        ' Enable PORTB pullups for button
        Pause 100               ' Wait for LCD to startup

        mode = 0                ' Set mode

        If (baud == 0) Then
                mode = 2        ' Set baud rate
        Endif

        If (state == 0) Then
                mode = mode + 4 ' Set inverted or true
        Endif


        Lcdout $fe, 1           ' Initialize and clear display

mainloop:   Serin rcv, mode, char   ' Get a char from serial input
        Lcdout char             ' Send char to display
        Goto mainloop               ' Do it all over again

        End
