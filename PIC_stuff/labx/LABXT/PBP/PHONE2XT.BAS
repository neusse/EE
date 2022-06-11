' PicBasic Pro 2.42 or later, LAB-XT Experimenter Board, PIC16F877-20

' Same as phone1xt.bas, but with Caller ID display.

' EPIC Programmer should not be connected to the ICSP header
' when running this code.  It may interfere with the operation
' of the keypad.  



DEFINE	LOADER_USED	1				' Only required for melabs Loader
DEFINE OSC 20						' Define for 20MHz crystal on LAB-XT

' Set Hserin/Hserout to 9600 baud
DEFINE HSER_BAUD	9600			
DEFINE HSER_RCSTA	90h				
DEFINE HSER_TXSTA	24h				

' Define LCD registers and bits
DEFINE  LCD_DREG        PORTD
DEFINE  LCD_DBIT        4
DEFINE  LCD_RSREG       PORTE
DEFINE  LCD_RSBIT       0
DEFINE  LCD_EREG        PORTE
DEFINE  LCD_EBIT        1

led3	VAR	PORTC.0					' LED3 output pin
led4	VAR PORTC.1					' LED4 output pin

sieze	VAR	PORTD.1					' Relay control pin (sieze line)
dtmf_ready	VAR PORTA.4				' Data ready signal from MT8870
voice_int	VAR	PORTA.5				' End of Message signal from voice chip
select_dtmf	VAR	PORTD.3				' Data output enable to MT8870
loop_current	VAR PORTA.3			' Loop current present (active low)
ring_detect		VAR	PORTA.2			' Ring detect pin (active low, square wave)
dtmf_out	VAR	PORTE.2				' DTMF signal output pin
cid_serial_data	VAR	PORTA.0			' Caller ID data from FSK chip
tone_detect	VAR PORTA.1				' Indicates audio signal present on line
speaker		VAR	PORTC.2				' Speaker output pin
select_voice	VAR	PORTD.2			' Chip select for voice recorder
serial_mcu_out	VAR	PORTC.5			' SPI data output
serial_clk		VAR	PORTC.3			' SPI clock pin


ADCON1 = 7      ' Set PORTA and PORTE to digital
TRISD = %11110000	' Set low bits of PORTD to output
TRISC = %11111000	' Set LED and Speaker pins to output
PORTD = 0           ' Intialize output state of PORTD

Pause 100       ' Wait for LCD to start up
LCDOut $fe,1	' Clear display

' Define program variables
h		VAR		BYTE			' Loop counter, misc
i		VAR		BYTE			' Loop counter, misc
j		VAR		BYTE			' Loop counter, misc
col     VAR     BYTE            ' Keypad column
row     VAR     BYTE            ' Keypad row
key     VAR     BYTE            ' Key value
disp_key    VAR     BYTE		' Key label
entry_string	VAR	BYTE[20]	' Array for storing user keyboard entry
ring_freq	VAR	WORD			' Frequency of ring signal (speaker PWM)
length		VAR	BYTE			' Length of caller id string
cid_string	VAR	BYTE[96]		' Array for storing caller id string


OPTION_REG.7 = 0        		' Enable PORTB pullups
'INTCON2.7 = 0

initialize:
	For i = 0 TO 19				' Clear the user-entry array variable
		entry_string[i] = $FF	' Store $FF in each location of array
	Next i
	led3 = 0
	i = 0						' Set user-entry to location 0
	key = $FF					' Set key value to $FF (cleared)
	sieze = 0					' Deactivate the line-sieze relay (Hang Up)
	Pause 250
	LCDOut $fe, 1, "A=Off Hook  D=Dial", $FE, $C0  ' Display sign-on message

mainloop:

	GoSub getkey            	' Check for user keypad entry
	
	IF (ring_detect = 0) Then	' Check for ring-detect (incoming call, active low)
		j = 0					' Clear j variable (time elapsed since last ring-detect)
ring_cycle:
		led3 = 1				' Light LED to indicate incoming call
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
		led3 = 0				' Shut off the LED
		IF key = $FF Then GoSub caller_id	' If end of ring, check for caller id
	EndIF
		
		
		
	Select Case key				' Take action based on user keypad entry
	
		Case 12					' User entry "A" - Off Hook
			sieze = 1			' Activate sieze relay
			Pause 250			' Pause 250mS to establish loop current
	  		LCDOut $FE, 2, "B=Hang Up, Dial #'s", $FE, $C0	' New prompt on LCD
      
		Case 13,14				' User entries "B" or "C" - Hang Up or Clear
			GoTo initialize		' Hang Up and initialize variables

      	Case 15					' User entry "D" - Dial user-entered string
			LCDOut $FE, 2, "Dial Tone Detect... "	' Indicate status on LCD
			IF sieze = 1 Then	' If already Off Hook, get new dial tone
				sieze = 0		' Deactivate sieze relay (hang up)
				Pause 750		' Pause 750mS to drop line
			EndIF	
			sieze = 1			' Activate sieze relay (off hook)
			Pause 150			' Pause 150mS to establish loop current
			j = 0				' Clear j (number of tone-detect attempts)
detect:							' Jump here to try again
			h = 0				' Clear h (tone cycles)
			Count tone_detect,150,h	' Count tone cycles for 150mS
			j = j+1				' Increment number of tries
			IF (j < 50) AND (h < 50) Then detect	' Were there 50 tone cycles in 150mS? (>333Hz)
			' If tone detected or no tone for 50 tries, continue
			
			LCDOut $FE, 2, "Dialing:            " 'Indicate status on LCD
			
			For i = 0 TO 19		' Loop through the user-entry array
				IF entry_string[i] = $FF Then end_string	' $FF in array indicates end-of-string
				DTMFOut dtmf_out,100,100,[entry_string[i]]	' Dial the DTMF digit in each location
				entry_string[i] = $FF	' Clear the location after dialed
			Next i				' Next location
end_string:						' Jump here is end-of-string
			i = 0				' Set user-entry location back to 0
			LCDOut $FE, 1, "B=Hang Up, Dial #'s", $FE, $C0	' Display prompt on LCD
			
      		
		Case Is < 12			' User pressed number or *# key
			IF i = 0 Then
				LCDOut $FE,$C0, REP 32\20,$FE,$C0
			EndIF
			LCDOut disp_key		' Display key label on LCD
			IF sieze = 1 Then	' If Off Hook, dial the digit
				DTMFOut dtmf_out,200,10,[key]	' Dial DTMF for user-entered digit
			EndIF
			entry_string[i] = key	' Save digit in current location
			i = i + 1		' Increment location

	End Select					' Continue program

GoTo mainloop               ' Repeat main loop


' Subroutine to get a key from keypad
getkey:

	' If Off Hook and the loop_current drops, Hang-Up the phone 
	' and initialize variables.  Placed here because getkey is
	' frequently called, and we want to avoid delays that hold
	' the line off-hook.
	IF (sieze = 1) AND (loop_current = 1) Then initialize


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



caller_id:

	Pause 200	' Wait 200mS for line to settle

	' Look for CID data, abort if no data for 500mS
	SerIn2 cid_serial_data, 813, 500, mainloop,	[wait($80),length,STR cid_string\length]
	
	LCDOut $fe,1					' Clear the display
	
	For i = 0 TO length				' Begin loop, each count represents a character
									' in the recorded CID data.
									
		Select Case cid_string[i]	' For each character, check for known parameter types
		
			Case $01				' Parameter type 01 (hex) is date and time.
				i = i + 1			' Move index pointer to parameter length character.
									' This avoids the length character being mistaken for
									' a parameter type code.

				LCDOut $fe,$80,cid_string[i+1],cid_string[i+2],_	' Display date and time
				$FE,$C0, cid_string[i+3],cid_string[i+4], " ",_
				$FE,$83, cid_string[i+5],cid_string[i+6],":",_
				cid_string[i+7],cid_string[i+8]
				
			Case $02, $04			' Parameter type 02 is the phone number.
									' Parameter type 04 is the reason, if there is no number
				LCDOut $FE,$89		' Move the LCD cursor to position 9 on line 1
				GoSub disp_string	' Display the number string

			Case $07, $08			' Parameter type 07 is the caller's name.
									' Parameter type 08 is the reason, if there is no name
				LCDOut $FE,$C3		' Move the LCD cursor to position 4, line 2
				GoSub disp_string	' Display the name string
			
		End Select
	Next i
	
	' Because the caller id information overwrites the user-entry on the display,
	' we must reset the user-entry array and pointer.
	For i = 0 TO 19					' Clear the user-entry array variable
		entry_string[i] = $FF		' Store $FF in each location of array
	Next i
	i = 0							' Set user-entry to location 0
Return
	
	

disp_string:						

	i = i + 1						' Move the index pointer to the parameter-length byte
	IF cid_string[i]=1 Then			' If the parameter is only 1 character long, then display a reason
		IF cid_string[i+1] = "O" Then LCDOut "Out Of Area"	' "O" is Out Of Area
		IF cid_string[i+1] = "P" Then LCDOut "Blocked"		' "P" is Private Caller
	Else							' If the parameter is longer than 1 character
		For h = 1 TO cid_string[i]	' Loop from 1 to the length of the parameter
			LCDOut cid_string[i+h]	' Display each character in the parameter
		Next h						' Do it for the next character
	EndIF
Return

        End
