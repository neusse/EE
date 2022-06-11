' PICBASIC PRO program to display "Hello World" on LCD

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


        ADCON1 = 7      ' Set PORTA and PORTE to digital
        Low PORTE.2     ' LCD R/W line low (W)
        Pause 100       ' Wait for LCD to start up


mainloop:   Lcdout $fe, 1   ' Clear screen
        Pause 500       ' Wait .5 second

        Lcdout "Hello"  ' Display "Hello"
        Pause 500       ' Wait .5 second

        Lcdout $fe, $c0, "World"        ' Move to line 2  and display "World"
        Pause 500       ' Wait .5 second

        Goto mainloop       ' Do it forever

        End
