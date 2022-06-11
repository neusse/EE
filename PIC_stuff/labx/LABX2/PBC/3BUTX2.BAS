' BUTTON Command
'
' Demonstrates multiple BUTTON commands. Each of 3 buttons toggles an LED.
' Hold a button for 1 second and the LED will flicker (auto-repeat).

Symbol button1 = 4
Symbol button2 = 5
Symbol button3 = 6

Symbol LED1 = 0
Symbol LED2 = 1
Symbol LED3 = 2

Symbol PORTB = $06
Symbol TRISB = $86
Symbol OPTION_REG = $81


	B1 = 0		'Clear buffers
	B2 = 0
	B3 = 0


	Poke TRISB, %11110000	'Set portb 0-3 outputs, 4-7 inputs
	Poke OPTION_REG, %01111111	'Enable PORTB pull-ups
	Poke PORTB, 0	'LEDs off



chk1:	Pause 25
	Button button1,0,40,5,B1,0,chk2	' Check Button 1 (Skip to 2 if Not Pressed)
	Toggle LED1	' Toggle LED if pressed
		
chk2:	Button button2,0,40,5,B2,0,chk3	' Check Button 2 (Skip to 3 if Not Pressed)
	Toggle LED2	' Toggle LED if pressed
		
chk3:	Button button3,0,40,5,B3,0,chk1	' Check Button 3 (Skip to 1 if Not Pressed)
	Toggle LED3	' Toggle LED if pressed

	GoTo chk1	' Do it forever

