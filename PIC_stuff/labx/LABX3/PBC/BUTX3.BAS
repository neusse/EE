' PICBASIC program to show button press on LED

Symbol  LED1 = 4                ' Set LED1 to PORTB.4
Symbol  LED2 = 5                ' Set LED1 to PORTB.5
Symbol  S1 = PIN7               ' Set button 1 to PORTB.7

Symbol  PORTA = 5               ' Set PORTA address
Symbol  TRISA = $85             ' Set TRISA address
Symbol	OPTION_REG = $81	' Set OPTION register address

        POKE OPTION_REG, $7f	' Enable PORTB pull-ups


loop:   Low LED1                ' Turn off LEDs
        Low LED2

        ' Check any button pressed to toggle on LED
        If PIN7 = 1 Then not1   ' If 1st button pressed...
        High LED1               ' Turn on 1st LED

not1:   Peek PORTA, B0          ' Get PORTA bits to B0
        If BIT5 = 1 Then not0   ' If 2nd button pressed...
        High LED2               ' Turn on 1st LED


not0:   Pause 2                 ' Pause 2mS
	Goto loop		' Do it forever

        End
