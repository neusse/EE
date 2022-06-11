' PICBASIC PRO program to read DS1620 3-wire temperature sensor
'  and display temperature on LCD

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

        Include "MODEDEFS.BAS"

' Define LCD pins
Define  LCD_DREG        PORTD
Define  LCD_DBIT        4
Define  LCD_RSREG       PORTE
Define  LCD_RSBIT       0
Define  LCD_EREG        PORTE
Define  LCD_EBIT        1

' Alias pins
RST     Var     PORTC.0         ' Reset pin
DQ      Var     PORTC.1         ' Data pin
CLK     Var     PORTC.3         ' Clock pin

' Allocate variables
temp    Var     Word            ' Storage for temperature


        Low RST                 ' Reset the device

        ADCON1 = 7              ' Set PORTA and PORTE to digital

        Low PORTE.2             ' LCD R/W line low (W)
        Pause 100               ' Wait for LCD to start

        Lcdout $fe, 1, "Temp in degrees C"      ' Display sign-on message


' Mainloop to read the temperature and display on LCD
mainloop:
        RST = 1                 ' Enable device
        Shiftout DQ, CLK, LSBFIRST, [$ee]       ' Start conversion
        RST = 0

        Pause 1000              ' Wait 1 second for conversion to complete

        RST = 1
        Shiftout DQ, CLK, LSBFIRST, [$aa]       ' Send read command
        Shiftin DQ, CLK, LSBPRE, [temp\9]       ' Read 9 bit temperature
        RST = 0

        ' Display the decimal temperature
        Lcdout $fe, 1, dec (temp >> 1), ".", dec (temp.0 * 5), " degrees C"

        Goto mainloop           ' Do it forever

        End
