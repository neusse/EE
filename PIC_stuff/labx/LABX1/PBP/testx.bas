' PICBASIC PRO test program for LAB-X1

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
i       Var     Byte
leds    Var     Byte
char    Var     Byte
col     Var     Byte            ' Keypad column
row     Var     Byte            ' Keypad row
key     Var     Byte            ' Key value
x       Var     Byte
y       Var     Byte
z       Var     Byte


        ADCON1 = 4              ' Set PortA 0, 1, 3 to analog inputs

        OPTION_REG.7 = 0        ' Enable PORTB pullups

        TRISD = 0               ' PORTD to all output

'        Low PORTE.2             ' LCD R/W line low (W)
        Pause 100               ' Wait for LCD to start

        Goto mainloop		' Skip subroutines


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

' Subroutine to get a key from keypad
getkey:
        key = 0                 ' Set to no key

        For col = 0 To 3        ' 4 columns in keypad
                PORTB = 0       ' All output pins low
                TRISB = (dcd col) ^ $ff ' Set one column pin to output
                row = PORTB >> 4        ' Read row
                If row != $f Then gotkey        ' If any keydown, exit
        Next col

        Return                  ' No key pressed

gotkey: ' Change row and column to key number 1 - 16
        key = (col * 4) + (ncd (row ^ $f))
        Return                  ' Subroutine over

' Subroutine to get a char from serial port
getchar:
        char = 0
        Hserin 0, tlabel, [char]
tlabel: Hserout [$55]
        Return


mainloop:
        leds = 1

        For i = 1 To 8          ' Do For loop 8 times

        Gosub getx              ' Get x value
        Gosub gety              ' Get y value
        Gosub getz              ' Get z value
        Gosub getkey            ' Get key from keypad
        Gosub getchar           ' Get char from serial port

        Lcdout $fe, 1, "x=", #x, " y=", #y, " z=", #z   ' Send values to LCD

        If key != 0 Then
                Lcdout $fe, $c0, "key=", #key
        Endif

        If char = $55 Then
                Lcdout $fe, $c8, "loopback"
        Endif

        PORTD = leds
        leds = leds << 1

        Sound PORTC.2, [i * 10 , 16]    ' Do it allabout 5 times a second

        Next i

        Goto mainloop		' Do it forever

        End
