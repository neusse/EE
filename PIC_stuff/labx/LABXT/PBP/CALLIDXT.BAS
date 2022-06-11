' PicBasic Pro 2.42 or later, LAB-XT Experimenter Board, PIC16F877-20

' Displays Caller ID information on LCD.  Connect either jack on the
' LAB-XT to a telephone line.  Caller ID service must be provided
' by your local phone company.  This code only reads Multiple Data
' Message Format.  LED4 lights when ring is present.


DEFINE	LOADER_USED	1		' Only required for melabs Loader

DEFINE OSC 20				' Match the crystal on the board

' Define LCD registers and bits
DEFINE  LCD_DREG        PORTD
DEFINE  LCD_DBIT        4
DEFINE  LCD_RSREG       PORTE
DEFINE  LCD_RSBIT       0
DEFINE  LCD_EREG        PORTE
DEFINE  LCD_EBIT        1

ring_detect		VAR	PORTA.2	' Define the ring-detect input pin
cid_serial_data	VAR	PORTA.0	' Define the Caller-ID serial input pin
led4			VAR	PORTC.1	' Define LED output

idstring	VAR	BYTE[96]	' Array variable for recording the CID data
h			VAR BYTE		' Variable for loop count and timing
i			VAR	BYTE		' Variable for loop count
length		VAR	BYTE		' Variable stores the length of CID data string

ADCON1 = 7      			' Set PORTA and PORTE to digital
Pause 200       			' Wait for LCD to start up

LCDOut $fe,1, "Caller ID for LAB-XT"	' Vanity display

mainloop:
	IF ring_detect = 1 Then mainloop	' Wait here until ring detected
	
	High led4						' Light LED to indicate incoming ring

time_after:	
	IF ring_detect = 0 Then i = 0	' Clear timer variable if still ringing
	i = i + 1						' Increment timer variable
	Pause 1							' Pause 1mS
	IF i < 250 Then time_after		' Loop here until 250mS after ring stops
	
	Low led4						' Ring finished, kill LED

	' Look for CID data, abort if no data for 500mS
	SerIn2 cid_serial_data, 813, 500, mainloop, [wait($80),length,STR idstring\length] 


	LCDOut $fe,1					' Clear the display
	
	For i = 0 TO length				' Begin loop, each count represents a character
									' in the recorded CID data string.

		Select Case idstring[i]		' For each character, check for known parameter types
		
			Case $01				' Parameter type 01 (hex) is date and time.
				i = i + 1			' Move index pointer to parameter length character.
									' This avoids the length character being mistaken for
									' a parameter-type code.

				LCDOut $fe,$80,idstring[i+1],idstring[i+2],_	' Display date and time
				$FE,$C0, idstring[i+3],idstring[i+4], " ",_
				$FE,$83, idstring[i+5],idstring[i+6],":",_
				idstring[i+7],idstring[i+8]
				
			Case $02, $04			' Parameter type 02 is the phone number.
									' Parameter type 04 is the reason, if there is no number
				LCDOut $FE,$89		' Move the LCD cursor to position 9 on line 1
				GoSub disp_string	' Display the number string

			Case $07, $08			' Parameter type 07 is the caller's name.
									' Parameter type 08 is the reason, if there is no name
				LCDOut $FE,$C3		' Move the LCD cursor to position 4, line 2
				GoSub disp_string	' Display the name string
			
		End Select

	Next i							' Loop to the next character in the array
	
GoTo mainloop							' Return and wait for next ring
	
' Subroutine to display text string. This routine is called when a variable length CID parameter
' type is read from the array. The number of characters to display is stored in the next array
' location after the parameter type.

disp_string:					

	i = i + 1						' Move the index pointer to the parameter-length byte

	IF idstring[i]=1 Then			' If the parameter is only 1 character long, then display a reason

		IF idstring[i+1] = "O" Then LCDOut "Out Of Area"	' "O" is Out Of Area
		IF idstring[i+1] = "P" Then LCDOut "Blocked"		' "P" is Private Caller

	Else							' If the parameter is longer than 1 character

		For h = 1 TO idstring[i]	' Loop from 1 to the length of the parameter
			LCDOut idstring[i+h]	' Display each character in the parameter
		Next h						' Do it for the next character

	EndIF
Return
