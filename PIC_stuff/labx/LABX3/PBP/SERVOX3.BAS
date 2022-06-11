' PicBasic Pro program to move RC servo using buttons
'  Button 1 moves servo left, 2 moves servo right
'  Press both buttons to center servo

Define  LCD_DREG        PORTA   ' Define LCD connections
Define  LCD_DBIT        0
Define  LCD_RSREG       PORTA
Define  LCD_RSBIT       4
Define  LCD_EREG        PORTB
Define  LCD_EBIT        3

pos     Var     Word		' Servo position

servo1  Var     PORTB.6		' Alias servo pin


        CMCON = 7		' PORTA to digital
        Pause 100		' Wait for LCD to startup

        OPTION_REG = $7f	' Enable PORTB pullups
        Low servo1		' Servo output low

        Gosub center		' Center servo


' Main program loop
mainloop:
        ' Check any button pressed to move servo
        If PORTB.7 = 0 Then
                If PORTA.5 = 0 Then
                        Gosub center
                Else
                        Gosub left
                Endif
        Endif
        If PORTA.5 = 0 Then
                Gosub right
        Endif

        servo1 = 1		' Start servo pulse
        Pauseus 1000 + pos
        servo1 = 0		' End servo pulse

        Pause 16		' Servo update rate about 60Hz

        Goto mainloop		' Do it all forever


' Move servo left
left:   If pos < 1000 Then
                pos = pos + 1
		Lcdout $fe, 1, "Position = ", #pos
        Endif
        Return


' Move servo right
right:  If pos != 0 Then
                pos = pos - 1
		Lcdout $fe, 1, "Position = ", #pos
        Endif
        Return


' Center servo
center: pos = 500
	Lcdout $fe, 1, "Position = ", #pos
        Return

        End
