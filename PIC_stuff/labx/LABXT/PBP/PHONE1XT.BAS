' PicBasic Pro 2.42 or later, LAB-XT Experimenter Board, PIC16F877-20

' Simple telephone.  Press keys for on-hook, off-hook, and to dial.
' Incoming call sounds ringer and flashes LED. Watches for loop-current
' wink when off-hook.

' EPIC Programmer should not be connected to the ICSP header
' when running this code.  It may interfere with the operation
' of the keypad.  




DEFINE	LOADER_USED	1				' Only required for melabs Loader
DEFINE OSC 20						' Define for 20MHz crystal on LAB-XT

' Define LCD registers and bits
DEFINE  LCD_DREG        PORTD
DEFINE  LCD_DBIT        4
DEFINE  LCD_RSREG       PORTE
DEFINE  LCD_RSBIT       0
DEFINE  LCD_EREG        PORTE
DEFINE  LCD_EBIT        1

led3	VAR	PORTC.0					' LED3 output pin

sieze	VAR	PORTD.1					' Relay control pin (sieze line)
loop_current	VAR PORTA.3			' Loop current present (active low)
ring_detect		VAR	PORTA.2			' Ring detect pin (active low, square wave)
dtmf_out	VAR	PORTE.2				' DTMF signal output pin
tone_detect	VAR PORTA.1				' Indicates audio signal present on line
speaker		VAR	PORTC.2				' Speaker output pin


ADCON1 = 7      ' Set PORTA and PORTE to digital
TRISD = %11110000	' Set low bits of PORTD to output
PORTD = 0           ' Intialize output state of PORTD


' Define program variables
j		VAR		BYTE			' Loop counter, misc
col     VAR     BYTE            ' Keypad column
row     VAR     BYTE            ' Keypad row
key     VAR     BYTE            ' Key value
disp_key    VAR     BYTE		' Key label
ring_freq	VAR	WORD			' Frequency of ring signal (speaker PWM)


OPTION_REG.7 = 0        		' Enable PORTB pullups (16F877)
'INTCON2.7 = 0					' Enable PORTB pullups (18F452)

initialize:
	key = $FF					' Set key value to $FF (cleared)
	sieze = 0					' Deactivate the line-sieze relay (Hang Up)
	Pause 250
	LCDOut $fe, 1, "Press A for Off-Hook", $FE, $C0  ' Display sign-on message

mainloop:

	' If Off Hook and the loop_current drops, Hang-Up the phone 
	' and initialize variables.  
	IF (sieze = 1) AND (loop_current = 1) Then initialize

	GoSub getkey            	' Check for user keypad entry


	' Take action based on user keypad entry
	Select Case key				
	
		Case 12					' User entry "A" - Off Hook
			sieze = 1			' Activate sieze relay
			Pause 250			' Pause 250mS to establish loop current
	  		LCDOut $FE, 1, "Press B to Hang Up", $FE, $C0	' New prompt on LCD
      
		Case 13,14				' User entries "B" or "C" - Hang Up or Clear
			GoTo initialize		' Hang Up and initialize variables

		Case Is < 12			' User pressed number or *# key
			LCDOut $FE, $C0, disp_key		' Display key label on LCD
			IF sieze = 1 Then	' If Off Hook, dial the digit
				DTMFOut dtmf_out,200,10,[key]	' Dial DTMF for user-entered digit
			EndIF

	End Select					' Continue program

	

	' Check for incoming call
	IF (ring_detect = 0) Then	' Check for ring-detect (incoming call, active low)
		j = 0					' Clear j variable (time elapsed since last ring-detect)
ring_cycle:
		High led3				' Light LED to indicate incoming call
		Pause 1					' Pause 1mS so we can time this loop
		GoSub getkey			' Check for user entry
		j = j + 1				' Each count of j represents 1mS of time 
		' If user pressed "A", he wants to answer the call. Ignore other keys.
		' If 60mS has elapsed without a ring-detect, the ring has ended
		IF (j > 60) OR (key = 12) Then stop_ringing 
		IF ring_detect = 1 Then ring_cycle	' Stay in this loop if no ring-detect (60mS max)
		
		IF ring_freq = 2150 Then	' On each ring detect, change the speaker frequency.
			ring_freq = 2500		' This gives us the familiar 20Hz warble tone. The 
		Else						' frequencies used (2150 and 2500) gave the most
			ring_freq = 2150		' speaker volume when tested.
		EndIF
		HPwm 1,127,ring_freq	' Initiate the speaker tone using HPWM. The output will continue until silenced.
		led3 = 0
		Pause 30				' Pause 30mS.  (Low period of ring-detect)		
		j = 30					' Set j to 30 (30mS)
		GoTo ring_cycle			' Loop to keep monitoring the ring-detect
stop_ringing:					' Jump here at end of ring or to answer call
		HPwm 1,0,0				' Silence the speaker
		Low led3				' Shut off the LED
	EndIF
		
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
	
	' Translate key to DTMFOUT tone
	' 1   2   3   12
	' 4   5   6   13
	' 7   8   9   14
	' 10  0   11  15
	LookUp key,[1,2,3,12,4,5,6,13,7,8,9,14,10,0,11,15],key
	
Return			' Return to main loop

        End
