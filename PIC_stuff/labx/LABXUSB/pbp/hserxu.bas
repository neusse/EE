' PICBASIC PRO program to send and receive from the hardware serial port

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

' RESET_ORG can be set to move the BASIC program out of the way
' of any boot loader running from location 0, such as the
' Microchip USB boot loader
'Define	RESET_ORG	800h

Define	OSC	48		' Core is running at 48MHz

' Define LCD registers and bits
Define  LCD_DREG        PORTD
Define  LCD_DBIT        4
Define  LCD_RSREG       PORTE
Define  LCD_RSBIT       0
Define  LCD_EREG        PORTE
Define  LCD_EBIT        1

char    var     byte            ' Storage for serial character
col     var     byte            ' Keypad column
row     var     byte            ' Keypad row
key     var     byte            ' Key value
lastkey var     byte            ' Last key storage


	BAUDCON.3 = 1		' Set for 16-bit baud rate generator
	SPBRG = 1249		' Set for 2400 baud
	SPBRGH = 1249 / 256
        INTCON2.7 = 0		' Enable PORTB pullups
        ADCON1 = 15		' Set PORTA and PORTE to digital
        Low PORTE.2             ' LCD R/W line low (W)
	Pause 500		' Wait for LCD to startup

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
        For col = 0 to 3        ' 4 columns in keypad
                PORTB = 0       ' All output pins low
                TRISB = (dcd col) ^ $ff ' Set one column pin to output
		Pauseus 1
                row = PORTB >> 4        ' Read row
                If row != $f Then gotkey        ' If any keydown, exit
        Next col

        Return                  ' No key pressed

gotkey: ' Change row and column to ASCII key number
        key = (col * 4) + (ncd (row ^ $f)) + "0"
        Return                  ' Subroutine over

        End
