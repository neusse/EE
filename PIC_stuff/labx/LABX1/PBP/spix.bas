' PICBASIC PRO program to read and write to SPI SEEPROMs
'
' Write to the first 16 locations of an external serial EEPROM
' Read first 16 locations back and send to LCD repeatedly
' Note: for SEEPROMs with word-sized address

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

        include "modedefs.bas"

CS      Var     PORTA.5                 ' Chip select pin
SCK     Var     PORTC.3                 ' Clock pin
SI      Var     PORTC.4                 ' Data in pin
SO      Var     PORTC.5                 ' Data out pin

addr    Var     Word                    ' Address
B0      Var     Byte                    ' Data

        TRISA.5 = 0                     ' Set CS to output

        ADCON1 = 7                      ' Set PORTA and PORTE to digital
        Low PORTE.2                     ' LCD R/W line low (W)
        Pause 100                       ' Wait for LCD to start up


        For addr = 0 To 15              ' Loop 16 times
                B0 = addr + 100         ' B0 is data for SEEPROM
                Gosub eewrite           ' Write to SEEPROM
                Pause 10                ' Delay 10ms after each write
        Next addr

mainloop:   For addr = 0 To 15              ' Loop 16 times
                Gosub eeread            ' Read from SEEPROM
                Lcdout $fe,1,#addr,": ",#B0     ' Display
                Pause 1000
        Next addr

        Goto mainloop

' Subroutine to read data from addr in serial EEPROM
eeread: CS = 0                          ' Enable serial EEPROM
        Shiftout SI, SCK, MSBFIRST, [$03, addr.byte1, addr.byte0]       ' Send read command and address
        Shiftin SO, SCK, MSBPRE, [B0]   ' Read data
        CS = 1                          ' Disable
        Return

' Subroutine to write data at addr in serial EEPROM
eewrite: CS = 0                         ' Enable serial EEPROM
        Shiftout SI, SCK, MSBFIRST, [$06]       ' Send write enable command
        CS = 1                          ' Disable to execute command
        CS = 0                          ' Enable
        Shiftout SI, SCK, MSBFIRST, [$02, addr.byte1, addr.byte0, B0]   ' Send address and data
        CS = 1                          ' Disable
        Return

        End
