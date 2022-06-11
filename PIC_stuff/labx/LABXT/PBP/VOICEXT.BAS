' PicBasic Pro 2.42 or later, LAB-XT Experimenter Board, PIC16F877-20


' Program to record and play multiple voice messages.
' Uses hardware SPI for 2-way communication to the voice device.
' Record messages in sequence by pressing the A key, speaking into
' a headset mic, then pressing the B key to stop recording.  The first
' message may be played back by pressing 0, the second by pressing 1, etc.

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


select_voice	VAR	PORTD.2			' Chip select for voice recorder
serial_mcu_out	VAR	PORTC.5			' SPI data output
serial_clk		VAR	PORTC.3			' SPI clock pin
voice_int		VAR	PORTA.5			' Interrupt signal from voice device


ADCON1 = 7      ' Set PORTA and PORTE to digital
Pause 200       ' Wait for LCD to start up
LCDOut $fe,1	' Clear display

' Define program variables
col     		VAR     BYTE            ' Keypad column
row     		VAR     BYTE            ' Keypad row
key     		VAR     BYTE            ' Key value

control			VAR		BYTE
address			VAR		WORD
isd_data_in		VAR	WORD
isd_data_out	VAR	WORD
message_loc		VAR WORD[16]
i				VAR	BYTE

i = 0
message_loc[0]=0
High select_voice

' set up SPI port
BF	VAR	SSPSTAT.0		' Alias Buffer Full flag
SSPSTAT = %01000000		' Set SMP=0, CKE=1
SSPCON =  %00100010		' Set CKP=0, SPI master, clock = Fosc/64, Enable the port
TRISC = %00010100		' Set data-direction to allow SPI on PortC



OPTION_REG.7 = 0        ' Enable PORTB pullups

initialize:

	LCDOut $fe, 1, "A to record"	' Display intitial prompt
	LCDOut $fe,$C0, "B to stop"		

mainloop:


	'IF (isd_on = 1) AND (voice_int = 0) Then GoSub finish

	GoSub getkey			' Get a key from the keypad
	Select Case key			' Take action based on key

		Case 12				' "A" key starts recording
			LCDOut $fe,1, "recording message: ",DEC i		' Display
			LCDOut $fe,$c0, "address: ",HEX message_loc[i]	' Display	
			address = message_loc[i]	' Set address to begin recording
			GoSub record				' send record command to voice chip


		Case 13				' "B" key stops recording
			LCDOut $fe,1, "stop"		' Display		
			GoSub finish	' Send stop command and receive end address
			i = (i + 1) & $0F		' Increment message counter, loop 0 to 15
			message_loc[i] = (isd_data_in >> 2) + 2	' Remove status bits from end address, add 2 for separation
			

		Case Is < 10		' Number keys play the corresponding message
			LCDOut $fe,1, "playing message: ",DEC key			' Display
			LCDOut $fe,$c0, "address: ", HEX message_loc[key]	' Display
			address = message_loc[key]	' Set playback address
			GoSub ply		' Send play command
wait_for_int:
			IF voice_int = 1 Then wait_for_int	' Loop here until end of message
			GoSub finish	' Power down the voice chip
			GoTo initialize	' Reinitialize the display
			
	End Select
	
       
GoTo mainloop               ' Do it forever



' Subroutine to get a key from keypad
getkey:
	' Check for keypress
	For row = 0 TO 3        ' Loop for 4 rows in keypad
        PORTB = 0       	' All output pins low
        TRISB = ~(DCD row)  ' Set one row pin to output
        '@ NOP				' Fudge for 18F452
        col = PORTB >> 4	' Read column pins

        IF col != $0F Then	' Check if key is pressed
        	HPwm 1,127,7500	' Begin speaker tick
        	GoTo gotkey 	' If any keydown, exit loop and handle it.
        EndIF
	Next row				' Repeat for the next row
	
	key = $FF				' No keys down, set key to $FF
	Return          		' Return to main loop
	
gotkey: 					' Change row and column to key number 0 - 15
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
	'LookUp key,["123A456B789C*0#D"],disp_key
	
	' Translate key to DTMFOUT tone
	' 1   2   3   12
	' 4   5   6   13
	' 7   8   9   14
	' 10  0   11  15
	LookUp key,[1,2,3,12,4,5,6,13,7,8,9,14,10,0,11,15],key
	
Return			' Return to main loop



' ISD4003 Control Values:
power_up	CON	%00100000	' Power up the device	
set_play	CON %11100000	' Set the playback address
play		CON %11110000	' Start playback
set_rec		CON %10100000	' Set the record address
rec			CON	%10110000	' Start recording
power_dwn	CON %00010000	' Stop playback or record and power down the device


record:		'Record a message
		control = power_up	' Set control byte to power up
		GoSub spi_send		' Send to device

		Pause 100			' Pause to let the device come up

		control = set_rec	' Set control byte to set record address
		GoSub spi_send		' Send to device
		
		Return				' Return to main loop
		
		
ply:
		control = power_up	' Set control byte to power up
		GoSub spi_send		' Send to device

		Pause 50			' Pause to let the device come up
		
		control = set_play	' Set control byte to set play address
		GoSub spi_send		' Send to device
		
		Return
		
finish:
		control = power_dwn	' Set control byte to power down
		GoSub spi_send		' Send to device
		
		Return				' Return to main loop
		
		
spi_send:		' Use hardware SPI port to send and receive simultaneously


		Low select_voice	' Select voice chip
				
		address.highbyte = (address.highbyte & %00000111) | control ' Combine address and control data
		isd_data_out = address REV 16 	' Reverse the bits for LSB first

		SSPBUF = isd_data_out.highbyte	' Write the first byte to SSPBUF to initiate trasfer

		GoSub spi_wait					' Wait for transfer to finish
						
		isd_data_in.highbyte = SSPBUF	' Read the incoming data from SSPBUF

		SSPBUF = isd_data_out.lowbyte	' Write the second byte to SSPBUF to initiate transfer

		GoSub spi_wait					' Wait for transfer to finish
		
		isd_data_in.lowbyte = SSPBUF	' Read the incoming data from SSPBUF
		
		isd_data_in = isd_data_in REV 16	' Reverse the bits of incoming data (received LSB first)

		High select_voice 	' Deselect voice chip
		
		Return	

	
spi_wait:					' Wait for transfer to finish
		IF BF = 0 Then spi_wait		' If the flag is still zero, keep waiting
		BF = 0				' Reset the flag
		Return


        End
