' PICBASIC PRO program to read DS1820 1-wire temperature sensor
'  and display temperature on LCD

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
command Var     Byte            ' Storage for command
i       Var     Byte            ' Storage for loop counter
temp    Var     Word            ' Storage for temperature
DQ      Var     PORTC.0         ' Alias DS1820 data pin
DQ_DIR  Var     TRISC.0         ' Alias DS1820 data direction pin


        ADCON1 = 7              ' Set PORTA and PORTE to digital

        Low PORTE.2             ' LCD R/W line low (W)
        Pause 100               ' Wait for LCD to start

        Lcdout $fe, 1, "Temp in degrees C"      ' Display sign-on message


' Mainloop to read the temperature and display on LCD
mainloop:
        Gosub init1820          ' Init the DS1820

        command = $cc           ' Issue Skip ROM command
        Gosub write1820

        command = $44           ' Start temperature conversion
        Gosub write1820

        Pause 2000              ' Wait 2 seconds for conversion to complete

        Gosub init1820          ' Do another init

        command = $cc           ' Issue Skip ROM command
        Gosub write1820

        command = $be           ' Read the temperature
        Gosub write1820
        Gosub read1820

        ' Display the decimal temperature
        Lcdout $fe, 1, dec (temp >> 1), ".", dec (temp.0 * 5), " degrees C"

        Goto mainloop           ' Do it forever


' Initialize DS1820 and check for presence
init1820:
        Low DQ                  ' Set the data pin low to init
        Pauseus 500             ' Wait > 480us
        DQ_DIR = 1              ' Release data pin (set to input for high)

        Pauseus 100             ' Wait > 60us
        If DQ = 1 Then
                Lcdout $fe, 1, "DS1820 not present"
                Pause 500
                Goto mainloop   ' Try again
        Endif
        Pauseus 400             ' Wait for end of presence pulse
        Return


' Write "command" byte to the DS1820
write1820:
        For i = 1 To 8          ' 8 bits to a byte
                If command.0 = 0 Then
                        Gosub write0    ' Write a 0 bit
                Else
                        Gosub write1    ' Write a 1 bit
                Endif
                command = command >> 1  ' Shift to next bit
        Next i
        Return

' Write a 0 bit to the DS1820
write0:
        Low DQ
        Pauseus 60              ' Low for > 60us for 0
        DQ_DIR = 1              ' Release data pin (set to input for high)
        Return

' Write a 1 bit to the DS1820
write1:
        Low DQ                  ' Low for < 15us for 1
@       nop                     ' Delay 1us at 4MHz
        DQ_DIR = 1              ' Release data pin (set to input for high)
        Pauseus 60              ' Use up rest of time slot
        Return


' Read temperature from the DS1820
read1820:
        For i = 1 To 16         ' 16 bits to a word
                temp = temp >> 1        ' Shift down bits
                Gosub readbit   ' Get the bit to the top of temp
        Next i
        Return

' Read a bit from the DS1820
readbit:
        temp.15 = 1             ' Preset read bit to 1
        Low DQ                  ' Start the time slot
@       nop                     ' Delay 1us at 4MHz
        DQ_DIR = 1              ' Release data pin (set to input for high)
        If DQ = 0 Then
                temp.15 = 0     ' Set bit to 0
        Endif
        Pauseus 60              ' Wait out rest of time slot
        Return

        End
