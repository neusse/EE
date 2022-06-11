' PicBasic Pro 2.40 or later, LAB-XT Experimenter Board, PIC16F877-20

' Program to display key label on LCD

' EPIC Programmer should not be connected to the ICSP header
' when running this code.  It may interfere with the operation
' of the keypad.  



' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
DEFINE	LOADER_USED	1

' Define for 20MHz crystal
DEFINE  OSC  20

' Define LCD connections
DEFINE  LCD_DREG        PORTD
DEFINE  LCD_DBIT        4
DEFINE  LCD_RSREG       PORTE
DEFINE  LCD_RSBIT       0
DEFINE  LCD_EREG        PORTE
DEFINE  LCD_EBIT        1


' Define program variables
col     VAR     BYTE            ' Keypad column
row     VAR     BYTE            ' Keypad row
key     VAR     BYTE            ' Key value
disp_key	VAR	BYTE			' Key ASCII value


OPTION_REG.7 = 0        ' Enable PORTB pullups (16F877)
'INTCON2.7 = 0			' Enable PORTB pullups (18F452)

ADCON1 = 7              ' Make PORTA and PORTE digital

Pause 150               ' Wait for LCD to start

LCDOut $fe, 1, "Press any key"  ' Display sign on message

mainloop:   GoSub getkey            ' Get a key from the keypad
		IF key != $FF Then		' Check to see if a key was pressed
	        LCDOut $fe, 1, disp_key     ' Display ASCII key label
    	EndIF
        GoTo mainloop               ' Do it forever


' Subroutine to get a key from keypad
getkey:
	' Check for keypress
	For row = 0 TO 3        ' Loop for 4 rows in keypad
        PORTB = 0       ' All output pins low
        TRISB = ~(DCD row)  ' Set one row pin to output
        '@ NOP				' Fudge for 18F452
        col = PORTB >> 4	' Read column pins

        IF col != $0F Then	' Check if key is pressed
        	HPwm 1,127,7500	' Begin speaker tick
        	GoTo gotkey 	' If any keydown, exit
        EndIF
	Next row				' Repeat for the next row
	
	key = $FF				' No keys down, set key to $FF
	Return          		' Return to main loop
	
gotkey: 						' Change row and column to key number 0 - 15
	Pause 15                ' Debounce
	HPwm 1,0,0				' End speaker tick
	
	' Wait for all keys up
	PORTB = 0               ' All output pins low
	TRISB = $F0             ' Least significant 4 pins out, top 4 pins in
	IF ((PORTB >> 4) != $0F) Then gotkey	' If any keys down, loop
	key = (row * 4) + (NCD (col^$0F)) - 1	' Combine row and column into numeric value
	
	
	' Translate key to display label:
	' 1  2  3  A
	' 4  5  6  B
	' 7  8  9  C
	' *  0  #  D
	LookUp key,["123A456B789C*0#D"],disp_key
	
	
Return			' Return to main loop


        End
