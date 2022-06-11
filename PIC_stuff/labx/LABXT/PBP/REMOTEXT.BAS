' PicBasic Pro 2.42 or later, LAB-XT Experimenter Board, PIC16F877-20

' Demonstrates remote control using DTMF over a phone line.  The
' LAB-XT will answer an incoming call on the third ring and sound
' a short tone to the caller.  The caller can then control 2 leds
' by pressing keys on his telephone.

' Press 1 for LED4 ON
' Press 2 for LED3 ON
' Press 4 for LED4 OFF
' Press 5 for LED3 OFF
' Press 0 to disconnect


DEFINE	LOADER_USED	1		' Only required for melabs Loader
DEFINE OSC 20				' 20MHz crystal on the LAB-XT

' Define LCD registers and bits
DEFINE  LCD_DREG        PORTD
DEFINE  LCD_DBIT        4
DEFINE  LCD_RSREG       PORTE
DEFINE  LCD_RSBIT       0
DEFINE  LCD_EREG        PORTE
DEFINE  LCD_EBIT        1

seize			VAR PORTD.1	' Alias the line seize control pin
loop_current	VAR PORTA.3	' alias the loop current detect input pin
ring_detect		VAR	PORTA.2	' Alias the ring-detect input pin
dtmf_ready		VAR	PORTA.4	' Alias the dtmf data-ready pin
select_dtmf		VAR PORTD.3	' Alias the dtmf enable pin
DTMF_out		VAR PORTE.2	' Alias pin for remote user prompts
led3			VAR PORTC.0	' Alias pin for LED3
led4			VAR PORTC.1	' Alias pin for LED4


TRISD = 0		' Set PORTD to output
PORTD = 0		' Initialize PORTD, all zero
ADCON1 = 7      ' Set PORTA and PORTE to digital
Pause 200       ' Wait for LCD to start up
LCDOut $fe,1	' Clear display



i			VAR	WORD		' Variable for loop count
rings		VAR	BYTE		' Stores number of rings
dtmf_digit	VAR BYTE		' Stores dtmf received digit


initialize:
	LCDOut $fe,1, "Waiting for call"	' Display user prompt
	Low seize				' Release the line
	rings = 0				' Reset ring count to 0
	i = 0
	Low led3				' Shut off LED3
	Low led4				' Shut off LED4
	

mainloop:
	Pause 1					' Pause 1mS
	i = i + 1				' Increment counter
	IF i > 5000 Then initialize		' If 5 seconds have elapsed without ring, re-initialize
	IF ring_detect Then mainloop		' Loop here until ring detected
	
	

ringing:	
	IF ring_detect = 0 Then i = 0	' Clear timer variable if still ringing
	i = i + 1						' Increment timer variable
	Pause 1							' Pause 1mS
	IF i < 250 Then ringing			' Return to loop until 250mS after ring stops
	
	rings = rings + 1				' Increment ring counter
	LCDOut $fe,1, DEC rings," rings detected"	' Display user prompt

	IF rings < 3 Then mainloop			' If less than 3 rings, wait for more
	
	seize = 1						' If ring 5, answer the call
	Pause 250						' Wait 250mS for the line to settle
	
	FreqOut DTMF_out, 500, 800		' Play a short tone to prompt the caller
	LCDOut $fe,1, "Waiting for DTMF"	' Display user prompt
	
	
listen:
	IF (seize = 1) AND (loop_current = 1) Then initialize	' Re-initialize if the call is dropped remotely
	
	IF dtmf_ready = 0 Then listen	' Check for DTMF present, if none loop again

	' If DTMF present, continue

	select_dtmf = 1			' Enable the data output from the MT8870
	Pause 1					' Pause 1 mS to let data settle
	dtmf_digit = (PORTB >> 4)	' Read the top nibble of PORTB for DTMF data

	' Use LOOKUP to change the DTMF data to an ASCII character
	LookUp dtmf_digit, ["_1234567890*#ABCD"], dtmf_digit

dtmf_wait:					
	IF dtmf_ready Then dtmf_wait	' Loop here until DTMF signal stops
	select_dtmf = 0			' Disable the MT8870 data output

	Select Case dtmf_digit	' Take action based on the dtmf digit
	
		Case "1"			' DTMF "1" lights LED3
			High led3
			
		Case "2"			' DTMF "2" lights LED4
			High led4
			
		Case "4"			' DTMF "4" kills LED3
			Low led3
			
		Case "5"			' DTMF "5" kills LED4
			Low led4
			
		Case "0"			' DTMF "0" hangs up and re-initializes
			GoTo initialize
						
	End Select
	
GoTo listen				' Listen for next DTMF digit
		
	
	
	

