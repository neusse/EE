' BPX4.BAS
'  For PIC16F688 and melabs PICBASIC PRO Compiler
'
' LAB-X4 serial LCD controller

@	device	mclr_off

' Define LCD registers and bits (used for init only)
Define  LCD_DREG        PORTC
Define  LCD_DBIT        0
Define  LCD_RSREG       PORTC
Define  LCD_RSBIT       4
Define  LCD_EREG        PORTC
Define  LCD_EBIT        5

LCD_DATA Var	PORTC	' LCD data port
LCD_TRIS Var	TRISC	' LCD data tristate
LCD_RS	Var	PORTC.4	' LCD register select
LCD_E	Var	PORTC.5	' LCD enable

RX	Var	PORTA.2	' Serial receive


c	Var	Byte	' Serial character
mode	Var	Byte	' Serial mode
s	Var	Byte	' Swapped character


	TRISA = $3f	' Set PORTA for all inputs
	OPTION_REG.7 = 0	'Enable internal pullups
	ANSEL = 0	' Set all digital
	CMCON0 = 7	' Analog comparators off

	Pause 100	' Wait for LCD to start up

	mode = 0	' Preset serial mode for 2400, true
	If PORTA.4 == 0 Then mode = 2	' Set for 9600
	If PORTA.5 == 0 Then mode = mode + 4	' Set for inverted

	Lcdout $fe, 1	' Clear screen (also inits LCD)

mainloop:	LCD_TRIS = 0	' Set LCD port for all output
	LCD_RS = 1	' Set for data

	Serin RX, mode, c	' Get serial character

	If c == $fe Then	' Check for command marker
		LCD_RS = 0	' Clear for command
		Serin RX, mode, c	' Get command
	Endif

'	s = c >> 4	' Move upper nibble to lower (slow way)
	s = c & $f0	' Mask to upper nibble only
@	swapf	_s, f	' Move upper nibble to lower (fast way)

	LCD_E = 1	' Enable LCD
	LCD_DATA = LCD_DATA & $f0	' Mask off lower nibble
	LCD_DATA = LCD_DATA | s	' Put upper nibble on LCD data bus
	LCD_E = 0	' Not enable LCD

	c = c & $0f	' Mask to lower nibble only

	LCD_E = 1	' Enable LCD
	LCD_DATA = LCD_DATA & $f0	' Mask off lower nibble
	LCD_DATA = LCD_DATA | c	' Put lower nibble on LCD data bus
	LCD_E = 0	' Not enable LCD

	Goto mainloop	' Do it forever
