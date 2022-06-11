' PICBASIC PRO program to read LTC1298 ADC

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

        include "modedefs.bas"

' Alias pins
CS      Var     PORTC.5         ' Chip select
CK      Var     PORTC.3         ' Clock
DI      Var     PORTA.2         ' Data in
DO      Var     PORTC.1         ' Data out

' Allocate variables
addr    Var     Byte            ' Channel address / mode
result  Var     Word
x       Var     Word
y       Var     Word
z       Var     Word

        High CS                 ' Chip select inactive

        ADCON1 = 7              ' Set PORTA, PORTE to digital

        Low PORTE.2             ' LCD R/W line low (W)
        Pause 100               ' Wait for LCD to start

        Goto mainloop		' Skip subroutines


' Subroutine to read a/d convertor
getad:
        CS = 0                  ' Chip select active

        ' Send address / mode - Start bit, 3 bit addr, null bit]
        Shiftout DI, CK, MSBFIRST, [1\1, addr\3, 0\1]

        Shiftin DO, CK, MSBPRE, [result\12]  ' Get 12-bit result

        CS = 1                  ' Chip select inactive
        Return

' Subroutine to get x value (channel 0)
getx:
        addr = $05              ' Single ended, channel 0, MSBF high
        Gosub getad
        x = result
        Return

' Subroutine to get y value (channel 1)
gety:
        addr = $07              ' Single ended, channel 1, MSBF high
        Gosub getad
        y = result
        Return

' Subroutine to get z value (differential)
getz:
        addr = $01              ' Differential (ch0 = +, ch1 = -), MSBF high
        Gosub getad
        z = result
        Return


mainloop:
        Gosub   getx            ' Get x value
        Gosub   gety            ' Get y value
        Gosub   getz            ' Get z value

        Lcdout $fe, 1, "x=", #x, " y=", #y, " z=", #z   ' Send values to LCD
        Pause   100             ' Do it about 10 times a second

        Goto    mainloop        ' Do it forever

        End
