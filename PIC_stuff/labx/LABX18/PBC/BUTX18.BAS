' BUTX18.BAS
'  For PIC16F88 and melabs PICBASIC Compiler
'
' Show button press on LED

Symbol  LED1 = 0                ' Set LED1 to PORTB.0
Symbol  S1 = PIN7               ' Set button 1 to PORTB.7

Symbol  PORTA = 5               ' Set PORTA address
Symbol  TRISA = $85             ' Set TRISA address
Symbol	OPTION_REG = $81	' Set OPTION register address
Symbol	ANSEL = $9b		' Set ANSEL address

        POKE OPTION_REG, $7f	' Enable PORTB pull-ups
	Poke ANSEL, %00010000	' Set AN4 analog, rest digital


loop:   Low LED1                ' Turn off LED

        If PIN7 = 1 Then not1   ' If button pressed...
        High LED1               ' Turn on LED

not1:   Pause 2                 ' Pause 2mS
	Goto loop		' Do it forever

        End
