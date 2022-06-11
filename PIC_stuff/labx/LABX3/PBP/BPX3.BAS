' PICBASIC PRO program to simulate an LCD Backpack

' Define LCD registers and bits
Define  LCD_DREG        PORTA
Define  LCD_DBIT        0
Define  LCD_RSREG       PORTA
Define  LCD_RSBIT       4
Define  LCD_EREG        PORTB
Define  LCD_EBIT        3


char    Var     Byte            ' Storage for serial character
mode    Var     Byte            ' Storage for serial mode
rcv     Var     PORTB.1         ' Serial receive pin
baud    Var     PORTB.7         ' Baud rate pin - 0 = 2400, 1 = 9600
state   Var     PORTA.5         ' Inverted or true serial data - 1 = true


        CMCON = 7               ' PORTA is digital
        Pause 100               ' Wait for LCD to startup

        mode = 0                ' Set mode

        If (baud == 1) Then
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
