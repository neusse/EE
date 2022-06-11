' PicBasic Pro 2.40 or later, LAB-XT Experimenter Board, PIC16F877-20

' Program to blink an LED connected to PORTC.1 about once a second

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
DEFINE	LOADER_USED	1

' Define for 20MHz crystal
DEFINE  OSC 20

LED     VAR     PORTC.1 ' Alias PORTD.0 to LED

mainloop:   High LED        ' Turn on LED connected to PORTD.0
        Pause 500       ' Delay for .5 seconds

        Low LED         ' Turn off LED connected to PORTD.0
        Pause 500       ' Delay for .5 seconds

        GoTo mainloop       ' Go back to loop and blink LED forever
        End
