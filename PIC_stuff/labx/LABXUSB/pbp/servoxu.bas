' PICBASIC PRO program to move RC servo 1 using buttons
'  Button 1 moves servo left, 2 centers servo, 3 moves servo right

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

' RESET_ORG can be set to move the BASIC program out of the way
' of any boot loader running from location 0, such as the
' Microchip USB boot loader
'Define	RESET_ORG	800h

Define	OSC	48		' Core is running at 48MHz

Define  LCD_DREG        PORTD   ' Define LCD connections
Define  LCD_DBIT        4
Define  LCD_RSREG       PORTE
Define  LCD_RSBIT       0
Define  LCD_EREG        PORTE
Define  LCD_EBIT        1

pos     var     word    	' Servo position

servo1  var     PORTA.2 	' Alias servo pin


        INTCON2.7 = 0		' Enable PORTB pullups
        ADCON1 = 15      	' PORTA and PORTE to digital
        Low PORTE.2     	' LCD R/W low = write
        Low servo1      	' Servo output low
        PORTB = 0       	' PORTB lines low to read buttons
        TRISB = $fe     	' Enable first button row
        Pause 100       	' Wait for LCD to startup

        Gosub center		' Center servo

' Main program loop
mainloop:
        ' Check any button pressed to move servo
        If PORTB.4 = 0 Then
                Gosub left
        Endif
        If PORTB.5 = 0 Then
                Gosub center
        Endif
        If PORTB.6 = 0 Then
                Gosub right
        Endif

	servo1 = 1      	' Start servo pulse
	Pauseus pos		' Delay for servo pulse high time
	servo1 = 0      	' End servo pulse

	Pause 16        	' Servo update rate about 60Hz

	Goto mainloop   	' Do it all forever


' Move servo left
left:	If pos < 2000 Then
		pos = pos + 1
		GoSub display	' Display new position on LCD
	Endif
	Return


' Move servo right
right:  If pos > 1000 Then
		pos = pos - 1
		GoSub display	' Display new position on LCD
	Endif
	Return


' Center servo
center: pos = 1500
'	GoSub display	' Display new position on LCD
'	Return


' Display position on LCD
display: Lcdout $fe, 1, "Position = ", #pos
	Return

	End
