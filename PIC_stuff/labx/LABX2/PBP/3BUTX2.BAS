' BUTTON Command
'
' Demonstrates multiple BUTTON commands. Each of 3 buttons toggles an LED.
' Hold a button for 1 second and the LED will flicker (auto-repeat).

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

button1	VAR	PORTB.4
button2	VAR	PORTB.5
button3	VAR	PORTB.6

LED1	VAR	PORTB.0
LED2	VAR	PORTB.1
LED3	VAR	PORTB.2

B1      VAR     BYTE	'Working buffer 1 for button command
B2      VAR     BYTE	'Working buffer 2 for button command
B3      VAR     BYTE	'Working buffer 3 for button command

Clear			'Clear buffers
PORTB = 0		'LEDs off

TRISB = %11110000	'Set portb 0-3 outputs, 4-7 inputs
OPTION_REG.7 = 0	'Enable PORTB pull-ups



chk1:	Pause 25
	Button button1,0,40,5,B1,0,chk2	' Check Button 1 (Skip to 2 if Not Pressed)
	Toggle LED1	' Toggle LED if pressed
		
chk2:	Button button2,0,40,5,B2,0,chk3	' Check Button 2 (Skip to 3 if Not Pressed)
	Toggle LED2	' Toggle LED if pressed
		
chk3:	Button button3,0,40,5,B3,0,chk1	' Check Button 3 (Skip to 1 if Not Pressed)
	Toggle LED3	' Toggle LED if pressed

	GoTo chk1	' Do it forever

