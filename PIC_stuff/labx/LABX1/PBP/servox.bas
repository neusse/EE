' PICBASIC PRO program to move RC servo 1 using buttons
'  Button 1 moves servo left, 2 centers servo, 3 moves servo right

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

Define  LCD_DREG        PORTD   ' Define LCD connections
Define  LCD_DBIT        4
Define  LCD_RSREG       PORTE
Define  LCD_RSBIT       0
Define  LCD_EREG        PORTE
Define  LCD_EBIT        1

pos     Var     Word    ' Servo position

servo1  Var     PORTC.1 ' Alias servo pin


        ADCON1 = 7      ' PORTA and PORTE to digital
        Low PORTE.2     ' LCD R/W low = write
        Pause 100       ' Wait for LCD to startup

        OPTION_REG = $7f        ' Enable PORTB pullups
        Low servo1      ' Servo output low

        Gosub center    ' Center servo


' Main program loop
mainloop:
        PORTB = 0       ' PORTB lines low to read buttons
        TRISB = $fe     ' Enable first button row

        ' Check any button pressed to move servo
        If PORTB.4 = 0 Then
                Gosub left
        Endif
        If PORTB.5 = 0 Then
                Gosub center
        Endif
        If PORTB.6 = 0 Then
                Gosub right
        Endif

        Lcdout $fe, 1, "Position = ", #pos

        servo1 = 1      ' Start servo pulse
        Pauseus 1000 + pos
        servo1 = 0      ' End servo pulse

        Pause 16        ' Servo update rate about 60Hz

        Goto mainloop   ' Do it all forever


' Move servo left
left:   If pos < 1000 Then
                pos = pos + 1
        Endif
        Return


' Move servo right
right:  If pos != 0 Then
                pos = pos - 1
        Endif
        Return


' Center servo
center: pos = 500
        Return

        End
