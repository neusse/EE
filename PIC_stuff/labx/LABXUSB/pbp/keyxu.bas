' PICBASIC PRO program to display key number on LCD

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

' RESET_ORG can be set to move the BASIC program out of the way
' of any boot loader running from location 0, such as the
' Microchip USB boot loader
'Define	RESET_ORG	800h

Define	OSC	48		' Core is running at 48MHz

' Define LCD connections
Define  LCD_DREG        PORTD
Define  LCD_DBIT        4
Define  LCD_RSREG       PORTE
Define  LCD_RSBIT       0
Define  LCD_EREG        PORTE
Define  LCD_EBIT        1


' Define program variables
col     var     byte            ' Keypad column
row     var     byte            ' Keypad row
key     var     byte            ' Key value


        INTCON2.7 = 0		' Enable PORTB pullups
        ADCON1 = 15		' Make PORTA and PORTE digital
        Low PORTE.2             ' LCD R/W low (write)
        Pause 100               ' Wait for LCD to start

        Lcdout $fe, 1, "Press any key"  ' Display sign on message

mainloop:   Gosub getkey            ' Get a key from the keypad
        Lcdout $fe, 1, #key     ' Display ASCII key number
        Goto mainloop               ' Do it forever


' Subroutine to get a key from keypad
getkey:
        Pause 50                ' Debounce

getkeyu:
        ' Wait for all keys up
        PORTB = 0               ' All output pins low
        TRISB = $f0             ' Bottom 4 pins out, top 4 pins in
        If ((PORTB >> 4) != $f) Then getkeyu    ' If any keys down, loop

        Pause 50                ' Debounce

getkeyp:
        ' Wait for keypress
        For col = 0 to 3        ' 4 columns in keypad
                PORTB = 0       ' All output pins low
                TRISB = (dcd col) ^ $ff ' Set one column pin to output
		Pauseus 1
                row = PORTB >> 4        ' Read row
                If row != $f Then gotkey        ' If any keydown, exit
        Next col

        Goto getkeyp            ' No keys down, go look again

gotkey: ' Change row and column to key number 1 - 16
        key = (col * 4) + (ncd (row ^ $f))
        Return                  ' Subroutine over

        End
