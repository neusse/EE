' PICBASIC PRO program to measure voltage (0-5VDC)
' and display on LCD with 2 decimal places. A
' 60 segment bargraph is also displayed using
' custom LCD characters.
'
' This program uses the */ operator to scale the
' ADC result from 0-1023 to 0-500.  The */ performs
' a divide by 256 automatically, allowing math which
' would normally exceed the limit of a word variable.
'
' Connect analog input to channel-0 (RA0)

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

' Define LCD registers and bits
DEFINE  LCD_DREG        PORTD
DEFINE  LCD_DBIT        4
DEFINE  LCD_RSREG       PORTE
DEFINE  LCD_RSBIT       0
DEFINE  LCD_EREG        PORTE
DEFINE  LCD_EBIT        1

' Define ADCIN parameters
DEFINE  ADC_BITS        10     	' Set number of bits in result
DEFINE  ADC_CLOCK       3     	' Set clock source (3=rc)
DEFINE  ADC_SAMPLEUS    50    	' Set sampling time in uS

' Declare variables
adval  		VAR WORD			' Create adval to store result
fullbars	VAR	BYTE			' Number of full bars at left of graph
barval		VAR	BYTE			' Value passed to bargraph routine
partbar		VAR	BYTE			' ASCII code for partial bar character
pad			VAR	BYTE			' Number of spaces to pad to the right of graph


		TRISA = %11111111		' Set PORTA to all input
        ADCON1 = %10000010		' Set PORTA analog and right justify result
        ' PORTE remains digital to allow operation of the LCD
        
        Low PORTE.2				' LCD R/W line low (W)
        Pause 500       		' Wait .5 second
        
' Load the custom characters to LCD CGRAM. The blank at $0 makes the graphing math work faster.
        
	    LCDOut $FE,64,REP $0\8			' Load blank character (ascii $0)
	    LCDOut $0,REP $10\6,$0			' Load | character (ascii $1)
    	LCDOut $0,REP $14\6,$0			' Load || character (ascii $2)
	    LCDOut $0,REP $15\6,$0			' Load ||| character (ascii $3)
	    
	    LCDOut $FE, 1					' Clear the display


mainloop: 	ADCIN 0, adval					' Read channel 0 to adval (0-1023)

		adval = (adval */ 500)>>2		' equates to: (adval * 500)/1024

        LCDOut $FE,2,"DC Volts= ",DEC (adval/100),".", DEC2 adval	' Display the decimal value
        
        barval = (adval/9)+1			' Scale 0-500 to 60 segment bargraph (1-56)
        
        GoSub bargraph					' Update bargraph with new barval

        GoTo mainloop       				' Do it forever


bargraph:

  	fullbars = (barval MIN 60)/3		' Calculate number of full bars (|||). 
  	
	' partbar holds the ascii code for the partial bar character: $0=" ", $1="|", or $2="||"

  	partbar = (barval MIN 60) // 3		' Calculate ascii code for partial bar character		 
  	
  	pad = 19 - fullbars					' Number of spaces to fill display width.
  	
	LCDOut $fe,$c0, REP $3\fullbars, partbar, REP " "\pad	' Display the bar on second line
	
	Return

        End
