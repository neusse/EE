' PICBASIC PRO program to send and receive from the hardware serial port

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
col     Var     Byte            ' Keypad column
row     Var     Byte            ' Keypad row
key     Var     Byte            ' Key value
lastkey Var     Byte            ' Last key storage


        ADCON1 = 7              ' Set PORTA and PORTE to digital
        Low PORTE.2             ' LCD R/W line low (W)
	Pause 500		' Wait for LCD to startup

        OPTION_REG.7 = 0        ' Enable PORTB pullups

        key = 0                 ' Initialize vars
        lastkey = 0


        Lcdout $fe, 1           ' Initialize and clear display

mainloop:   Hserin 1, tlabel, [char]        ' Get a char from serial port
        Lcdout char             ' Send char to display
tlabel: Gosub getkey            ' Get a keypress if any
        If (key != 0) and (key != lastkey) Then
                Hserout [key]   ' Send key out serial port
        Endif
        lastkey = key           ' Save last key value
        Goto mainloop               ' Do it all over again

' Subroutine to get a key from keypad
getkey:
        key = 0                 ' Preset to no key
        For col = 0 To 3        ' 4 columns in keypad
                PORTB = 0       ' All output pins low
                TRISB = (dcd col) ^ $ff ' Set one column pin to output
                row = PORTB >> 4        ' Read row
                If row != $f Then gotkey        ' If any keydown, exit
        Next col

        Return                  ' No key pressed

gotkey: ' Change row and column to ASCII key number
        key = (col * 4) + (ncd (row ^ $f)) + "0"
        Return                  ' Subroutine over

        End
