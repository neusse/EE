' CLOCKX4.BAS
'  For PIC12F683 and melabs PICBASIC PRO Compiler
'
' LCD clock program using On Interrupt
'  Uses TMR0 and prescaler.  Watchdog Timer should be
'  set to off at program time and Nap and Sleep should not be used.
'  Button may be used to set time

' Turn off Watchdog Timer and disable reset so button can be used to set clock
@	device	wdt_off, mclr_off

LCD	Var	GPIO.1	' LCD TX pin
PB	Var	GPIO.3	' Alias GPIO.3 to push button

T2400	Con	396	' 2400 baud, true

hour    var     byte    ' Define hour variable
dhour   var     byte    ' Define display hour variable
minute  var     byte    ' Define minute variable
second  var     byte    ' Define second variable
ticks   var     byte    ' Define pieces of seconds variable
update  var     byte    ' Define variable to indicate update of LCD
i       var     byte    ' Debounce loop variable


	ANSEL = 0	' Set all digital
	CMCON0 = 7	' Analog comparators off

	Pause 500	' Wait for LCD to startup

        hour = 0        ' Set initial time to 00:00:00
        minute = 0
        second = 0
        ticks = 0

        update = 1	' Force first display

' Set TMR0 to interrupt every 16.384 milliseconds
        OPTION_REG = $d5	' Set TMR0 configuration
        INTCON = $a0	' Enable TMR0 interrupts
        On Interrupt Goto tickint


' Main program loop
mainloop:
	' Check button pressed to set time
	If PB = 0 Then
		minute = minute + 1	' Increment minutes
		If minute >= 60 Then
			minute = 0
			hour = hour + 1
			If hour >= 24 Then
				hour = 0
			Endif
		Endif
		For i = 1 To 100	' Debounce and delay for 100ms
			Pause 1	' 1ms at a time so no interrupts are lost
		Next i

		update = 1      ' Set to update screen
	Endif

        ' Check for time to update screen
	If update = 1 Then
                ' Display time as hh:mm:ss
                dhour = hour    ' Change hour 0 to 12
                If (hour // 12) = 0 Then
                        dhour = dhour + 12
                Endif

	        INTCON = $80	' No interrupts during Serout2
                ' Check for AM or PM
                If hour < 12 Then
                        Serout2 LCD, T2400, [$fe, 1, dec2 dhour, ":", dec2 minute, ":", dec2 second, " AM"]
                Else
                        Serout2 LCD, T2400, [$fe, 1, dec2 (dhour - 12), ":", dec2 minute, ":", dec2 second, " PM"]
                Endif

                update = 0      ' Screen updated
	        INTCON = $a0	' Enable TMR0 interrupts
        Endif

        Goto mainloop   ' Do it all forever


' Interrupt routine to handle each timer tick
        Disable         ' Disable interrupts during interrupt handler
tickint: ticks = ticks + 1      ' Count pieces of seconds
        If ticks < 61 Then tiexit       ' 61 ticks per second (16.384ms per tick)

' One second elasped - update time
        ticks = 0
        second = second + 1
        If second >= 60 Then
                second = 0
                minute = minute + 1
                If minute >= 60 Then
                        minute = 0
                        hour = hour + 1
                        If hour >= 24 Then
                                hour = 0
                        Endif
                Endif
        Endif

        update = 1      ' Set to update LCD

tiexit: INTCON.2 = 0    ' Reset timer interrupt flag
        Resume

        End
