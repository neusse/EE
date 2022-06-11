' PicBasic Pro 2.42 or later, LAB-XT Experimenter Board, PIC16F877-20

' Telemarketing stopper.  Reads caller id and plays Special Information Tones (SIT)
' when CID information has been blocked.


DEFINE	LOADER_USED	1			' Only required for melabs Loader
DEFINE OSC 20					' Define for 20MHz crystal on LAB-XT

led4			VAR PORTC.1		' LED4 output pin
sieze			VAR	PORTD.1		' Relay control pin (sieze line)
loop_current	VAR PORTA.3		' Loop current present (active low)
ring_detect		VAR	PORTA.2		' Ring detect pin (active low, square wave)
dtmf_out		VAR	PORTE.2		' DTMF signal output pin
cid_serial_data	VAR	PORTA.0		' Caller ID data from FSK chip


ADCON1 = 7      ' Set PORTA and PORTE to digital
TRISD = 0		' Set PORTD to output
PORTD = 0		' Initialize PORTD, all low

' Define program variables
j		VAR		BYTE			' Loop counter, misc
ring_freq	VAR	WORD			' Frequency of ring signal (speaker PWM)
cid_code	VAR BYTE			' Stores reason code from CID string

initialize:
	
	sieze = 0					' Deactivate the line-sieze relay (Hang Up)
	Pause 250					' Wait 250mS for things to settle 

mainloop:

	' If Off Hook and the loop_current drops, the caller has hung up. Drop the line
	IF (sieze = 1) AND (loop_current = 1) Then initialize	

	
	IF (ring_detect = 0) Then	' Check for ring-detect (incoming call, active low)
		j = 0					' Clear j variable (time elapsed since last ring-detect)
ring_cycle:
		High led4				' Light LED to indicate incoming call
		Pause 1					' Pause 1mS so we can time this loop
		j = j + 1				' Each count of j represents 1mS of time 
		IF (j > 60) Then stop_ringing		' If no ring_detect for 60mS, ring has ended
		IF ring_detect = 1 Then ring_cycle	' Stay in this loop until ring_detect
		Pause 30				' Pause 30mS.  (Low period of ring-detect)		
		j = 30					' Set j to 30 (30mS)
		GoTo ring_cycle			' Loop to keep monitoring the ring-detect
stop_ringing:					' Jump here at end of ring or to answer call

		Low led4				' Shut off the LED
		Pause 250				' Wait 250mS for line to settle

		' Look for CID data, abort if no data for 500mS
		SerIn2 cid_serial_data, 813, 500, mainloop,	[wait($80),wait($04,$01), cid_code]
		IF cid_code = "P" Then block_call	' Check for "Private" code
	EndIF	
		
GoTo mainloop               ' Repeat main loop


block_call:						' Jumps here if turned on and the caller id is blocked
	sieze = 1					' Sieze line (Off Hook)
	Pause 500					' Wait 500mS to establish loop current 
	FreqOut dtmf_out,330,950	' Send 950Hz tone for 330mS
	Pause 25					' 25mS of silence
	FreqOut dtmf_out,330,1400	' Send 1400Hz tone for 330mS
	Pause 25					' 25mS of silence
	FreqOut dtmf_out,330,1800	' Send 1800Hz tone for 330mS
	Pause 1000					' 1 second of silence
GoTo mainloop						' Back to main loop

End
