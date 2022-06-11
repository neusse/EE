' PICBASIC PRO test program for LAB-X1

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

' RESET_ORG can be set to move the BASIC program out of the way
' of any boot loader running from location 0, such as the
' Microchip USB boot loader
'Define	RESET_ORG	800h

Define	OSC	48		' Core is running at 48MHz

' Define LCD pins
Define  LCD_DREG        PORTD
Define  LCD_DBIT        4
Define  LCD_RSREG       PORTE
Define  LCD_RSBIT       0
Define  LCD_EREG        PORTE
Define  LCD_EBIT        1

' Allocate variables
i       var     byte
leds    var     byte
char    var     byte
col     var     byte            ' Keypad column
row     var     byte            ' Keypad row
key     var     byte            ' Key value
x       var     byte
y       var     byte


	BAUDCON.3 = 1		' Set for 16-bit baud rate generator
	SPBRG = 1249		' Set for 2400 baud
	SPBRGH = 1249 / 256
	ADCON1 = $d		' Set PortA 0, 1 to analog inputs
	INTCON2.7 = 0		' Enable PORTB pullups
	TRISD = 0		' PORTD to all output
'	Low PORTE.2		' LCD R/W line low (W)
        Pause 100               ' Wait for LCD to start

	GoTo mainloop		' Skip subroutines


' Subroutine to get a key from keypad
getkey:
        key = 0                 ' Set to no key

        For col = 0 to 3        ' 4 columns in keypad
                PORTB = 0       ' All output pins low
                TRISB = (dcd col) ^ $ff ' Set one column pin to output
		Pauseus 1
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

        For i = 1 to 8          ' Do For loop 8 times

	        Adcin 0, x	' Get x value
	        Adcin 1, y	' Get y value
        	Gosub getkey	' Get key from keypad
	        Gosub getchar	' Get char from serial port

        	Lcdout $fe, 1, "x=", #x, " y=", #y	' Send values to LCD

	        If key != 0 Then
        	        Lcdout $fe, $c0, "key=", #key
	        Endif

        	If char = $55 Then
                	Lcdout $fe, $c8, "loopback"
	        Endif

        	PORTD = leds
        	leds = leds << 1

	        Sound PORTC.2, [i * 10 , 16]	' Do it all about 5 times a second

        Next i

        GoTo mainloop		' Do it forever

        End
