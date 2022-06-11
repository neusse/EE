' PicBasic Pro 2.40 or later, LAB-XT Experimenter Board, PIC16F877-20

' Simple DTMF digit-grabber that monitors for DTMF on a telephone line
' and displays any digits received.  Tracks display position and wraps
' to first position on new line.  Press RESET to clear display.

' Connect the LAB-XT in series, phone to J3 and line to J4.


DEFINE	LOADER_USED	1		' Only required for melabs Loader

DEFINE OSC 20				' 20MHz crystal on the board


' Define LCD registers and bits
DEFINE  LCD_DREG        PORTD
DEFINE  LCD_DBIT        4
DEFINE  LCD_RSREG       PORTE
DEFINE  LCD_RSBIT       0
DEFINE  LCD_EREG        PORTE
DEFINE  LCD_EBIT        1

led4	VAR PORTC.1			' LED indicator output

dtmf_ready	VAR PORTA.4		' Ready input from MT8870
select_dtmf	VAR	PORTD.3		' Enable output to MT8870

dtmf_digit	VAR BYTE		' Stores most recent DTMF digit
lcd_position	VAR	BYTE	' Stores LCD cursor position (character)
lcd_line	VAR	BIT			' Stores LCD cursor position (line)

ADCON1 = 7      			' Set PORTA and PORTE to digital
TRISD = 0					' Set all pins on PORTD to output
PORTD = 0
Pause 200       			' Wait for LCD to start up
lcd_position = 1			' Set LCD position variable to first character
lcd_line = 0				' Set LCD line variable to first line
LCDOut $fe,1				' Clear display, cursor to line 1 home

mainloop:
	
	IF dtmf_ready = 0 Then mainloop	' Check for DTMF present, if none loop again

	' If DTMF present, continue

	High led4				' Light LED while DTMF signal present
	select_dtmf = 1			' Enable the data output from the MT8870
	Pause 1					' Pause 1 mS to let data settle

	dtmf_digit = (PORTB >> 4)	' Read the top nibble of PORTB for DTMF data

	' Use LOOKUP to change the DTMF data to an ASCII character
	LookUp dtmf_digit, ["_1234567890*#ABCD"], dtmf_digit

dtmf_wait:					
	IF dtmf_ready Then dtmf_wait	' Loop here until DTMF signal stops

	select_dtmf = 0			' Disable the MT8870 data output
	Low led4				' Shut off LED (no DTMF present)
	
	
	' Check the LCD cursor position

	IF lcd_position > 20 Then	' If the cursor is past the end of a line:

		lcd_position = 1		' Set cursor position variable to character 1
		lcd_line = ~lcd_line	' Move cursor line variable to the other line

		' Move the cursor on the display to match variables
		IF lcd_line Then
			LCDOut $fe,$C0		' Move cursor to line 2, character 1
		Else
			LCDOut $fe,2		' Move cursor to line 1, character 1
		EndIF

	EndIF

	LCDOut dtmf_digit			' Send the DTMF character to the LCD
	lcd_position = lcd_position + 1	' Increment the position variable

		
	GoTo mainloop				' Do it forever
