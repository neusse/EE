' PICBASIC program to move RC servo using potentiometer

Symbol	pos = B1		' Storage for servo position
Symbol  servo1 = 6              ' Alias servo pin


' Main program loop
mainloop: Pot 0, 127, pos

	pos = pos / 3 + 100
        Pulsout servo1, pos	' Move servo

        Pause 16		' Servo update rate about 60Hz

        Goto mainloop		' Do it all forever

        End
