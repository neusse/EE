' PICBASIC PRO program to read pots on 16F877 ADC

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

' Define LCD pins
Define  LCD_DREG        PORTD
Define  LCD_DBIT        4
Define  LCD_RSREG       PORTE
Define  LCD_RSBIT       0
Define  LCD_EREG        PORTE
Define  LCD_EBIT        1

' Allocate variables
x       Var     Byte
y       Var     Byte
z       Var     Byte

        ADCON1 = 4              ' Set PortA 0, 1, 3 to analog inputs

        Low PORTE.2             ' LCD R/W line low (W)
        Pause 100               ' Wait for LCD to start

        Goto    mainloop        ' Skip subroutines


' Subroutine to read a/d convertor
getad:
        Pauseus 50              ' Wait for channel to setup

        ADCON0.2 = 1            ' Start conversion
        Pauseus 50              ' Wait for conversion

        Return

' Subroutine to get pot x value
getx:
        ADCON0 = $41            ' Set A/D to Fosc/8, Channel 0, On
        Gosub getad
        x = ADRESH
        Return

' Subroutine to get pot y value
gety:
        ADCON0 = $49            ' Set A/D to Fosc/8, Channel 1, On
        Gosub getad
        y = ADRESH
        Return

' Subroutine to get pot z value
getz:
        ADCON0 = $59            ' Set A/D to Fosc/8, Channel 3, On
        Gosub getad
        z = ADRESH
        Return


mainloop:
        Gosub   getx            ' Get x value
        Gosub   gety            ' Get y value
        Gosub   getz            ' Get z value

        Lcdout $fe, 1, "x=", #x, " y=", #y, " z=", #z   ' Send values to LCD
        Pause   100             ' Do it about 10 times a second

        Goto    mainloop        ' Do it forever

        End
