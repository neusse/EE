' PICBASIC PRO program to read and write to Microwire SEEPROM 93LC56A
'
' Write to the first 16 locations of an external serial EEPROM
' Read first 16 locations back and send to LCD repeatedly
' Note: for SEEPROMs with byte-sized address

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
CLK     Var     PORTC.3                 ' Clock pin
DI      Var     PORTC.4                 ' Data in pin
DO      Var     PORTC.5                 ' Data out pin

addr    Var     Byte                    ' Address
B0      Var     Byte                    ' Data

        Low CS                          ' Chip select inactive

        ADCON1 = 7                      ' Set PORTA and PORTE to digital
        Low PORTE.2                     ' LCD R/W line low (W)
        Pause 100                       ' Wait for LCD to start up


        Gosub eewriteen                 ' Enable SEEPROM writes
        
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
eeread: CS = 1                          ' Enable serial EEPROM
        Shiftout DI, CLK, MSBFIRST, [%1100\4, addr]     ' Send read command and address
        Shiftin DO, CLK, MSBPOST, [B0]  ' Read data
        CS = 0                          ' Disable
        Return

' Subroutine to write data at addr in serial EEPROM
eewrite: CS = 1                         ' Enable serial EEPROM
        Shiftout DI, CLK, MSBFIRST, [%1010\4, addr, B0] ' Send write command, address and data
        CS = 0                          ' Disable
        Return

' Subroutine to enable writes to serial EEPROM
eewriteen: CS = 1                       ' Enable serial EEPROM
        Shiftout DI, CLK, MSBFIRST, [%10011\5, 0\7]     ' Send write enable command and dummy clocks
        CS = 0                          ' Disable
        Return

        End
