' PICBASIC PRO program to simulate an LCD Backpack

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

' Define LCD registers and bits
Define  LCD_DREG        PORTD
Define  LCD_DBIT        4
Define  LCD_RSREG       PORTE
Define  LCD_RSBIT       0
Define  LCD_EREG        PORTE
Define  LCD_EBIT        1


char    Var     Byte            ' Storage for serial character
mode    Var     Byte            ' Storage for serial mode
rcv     Var     PORTC.7         ' Serial receive pin
baud    Var     PORTA.0         ' Baud rate pin - 0 = 2400, 1 = 9600
state   Var     PORTA.1         ' Inverted or true serial data - 1 = true


        ADCON1 = 7              ' Set PORTA and PORTE to digital
        Low PORTE.2             ' LCD R/W line low (W)
	Pause 500		' Wait for LCD to startup

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
