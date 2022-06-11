' PicBasic Pro 2.42 or later, LAB-XT Experimenter Board, PIC16F877-20

' Sample program for dialing with pulses instead of DTMF.  Works as
' a telephone, but doesn't detect incoming calls.  See phone1xt.bas
' for ring detect and ringer code. 

' EPIC Programmer should not be connected to the ICSP header
' when running this code.  It may interfere with the operation
' of the keypad.  

 


DEFINE	LOADER_USED	1			' Only required for melabs Loader
DEFINE OSC 20					' Define for 20MHz crystal on LAB-XT


' Define LCD registers and bits
DEFINE  LCD_DREG        PORTD
DEFINE  LCD_DBIT        4
DEFINE  LCD_RSREG       PORTE
DEFINE  LCD_RSBIT       0
DEFINE  LCD_EREG        PORTE
DEFINE  LCD_EBIT        1

sieze	VAR	PORTD.1				' Relay control pin (sieze line)
loop_current	VAR PORTA.3		' Loop current present (active low)

' Define program variables
h		VAR		BYTE			' Loop counter, misc
col     VAR     BYTE            ' Keypad column
row     VAR     BYTE            ' Keypad row
key     VAR     BYTE            ' Key value
disp_key    VAR     BYTE		' Key label

TRISD = 0						' Set PORTD to outputs
PORTD = 0						' Initialize PORTD, all zeros
ADCON1 = 7      				' Set PORTA and PORTE to digital
Pause 100       				' Wait for LCD to start up
LCDOut $fe,1					' Clear display

OPTION_REG.7 = 0        		' Enable PORTB pullups (16F)
'INTCON2.7 = 0					' Enable PORTB pullups (18F)

initialize:
	key = $FF					' Set key value to $FF (cleared)
	sieze = 0					' Deactivate the line-sieze relay (Hang Up)
	Pause 250					' Wait 250mS for line to settle
	LCDOut $fe, 1, "Press A for off-hook", $FE, $C0  ' Display sign-on message

mainloop:

	' If Off Hook and the loop_current drops, Hang-Up the phone 
	' and initialize variables.  
	IF (sieze = 1) AND (loop_current = 1) Then initialize

	GoSub getkey            	' Check for user keypad entry
		
	Select Case key				' Take action based on user keypad entry
		Case 12					' User entry "A" - Off Hook
			sieze = 1			' Activate sieze relay
			Pause 250			' Pause 250mS to establish loop current
	  		LCDOut $FE, 1, "Press B to hang up", $FE, $C0	' New prompt on LCD
 			LCDOut $fe,$C0, "ready            ", disp_key	' Display user prompt
     
		Case 13,14,15			' User entries "B", "C", "D" - Hang Up
			GoTo initialize		' Hang Up and initialize variables
	
		Case Is < 12			' User pressed number or *# key

			LCDOut $fe,$C0, "Dialing: ", disp_key		' Display key label on LCD
			IF sieze = 1 Then	' If Off Hook, dial the digit

				For h = 1 TO key	' Loop for each pulse
					Pause 45	' 45mS "Make" time
					sieze = 0	' Drop the line
					Pause 65	' 65mS "Break" time
					sieze = 1	' Sieze the line
				Next h			' Next pulse
				Pause 300		' Pause 300mS between digits

			EndIF
			LCDOut $fe,$C0, "ready            ", disp_key	' Display user prompt

	End Select					' Continue program

GoTo mainloop               ' Repeat main loop


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
	
	' Translate key to pulse dial value (* and # are invalid)
	' 1   2   3   12
	' 4   5   6   13
	' 7   8   9   14
	' 0   10  0   15
	LookUp key,[1,2,3,12,4,5,6,13,7,8,9,14,0,10,0,15],key
	
Return			' Return to main loop




        End
