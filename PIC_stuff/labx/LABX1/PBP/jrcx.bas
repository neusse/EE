' LCD clock program using JRC6355 RTC

' Define LOADER_USED to allow use of the boot loader.
' This will not affect normal program operation.
Define	LOADER_USED	1

        Include "MODEDEFS.BAS"  ' Include Shiftin/out modes

Define  LCD_DREG        PORTD   ' Define LCD connections
Define  LCD_DBIT        4
Define  LCD_RSREG       PORTE
Define  LCD_RSBIT       0
Define  LCD_EREG        PORTE
Define  LCD_EBIT        1

' Alias pins
CE      var     PORTA.2
CLK     var     PORTC.1
SDATA   var     PORTC.3
IO      var     PORTC.5

' Allocate variables
rtcyear var     byte
rtcmonth var    byte
rtcdate var     byte
rtcday  var     byte
rtchr   var     byte
rtcmin  var     byte
rtcsec  var     byte


        Low CE          ' Disable RTC
        Low CLK
        High IO

        ADCON1 = 7      ' PORTA and E digital
        Low PORTE.2     ' LCD R/W low = write
        Pause 100       ' Wait for LCD to startup

        ' Set initial time to 8:00:00AM 07/16/99
        rtcyear = $99
        rtcmonth = $07
        rtcdate = $16
        rtcday = 6
        rtchr = $08
        rtcmin = 0
        rtcsec = 0
        Gosub settime   ' Set the time

        Goto mainloop   ' Skip subroutines


' Subroutine to write time to RTC
settime:
        IO = 1          ' Set RTC to input
        CE = 1          ' Enable transfer

        ' Write all 7 RTC registers
        Shiftout SDATA, CLK, LSBFIRST, [rtcyear, rtcmonth, rtcdate, rtcday\4, rtchr, rtcmin]

        CE = 0          ' Disable RTC
        Return

' Subroutine to read time from RTC
gettime:
        IO = 0          ' Set RTC to output
        CE = 1          ' Enable transfer

        ' Read all 7 RTC registers
        Shiftin SDATA, CLK, LSBPRE, [rtcyear, rtcmonth, rtcdate, rtcday\4, rtchr, rtcmin, rtcsec]

        CE = 0          ' Disable RTC
        Return

' Main program loop - in this case, it only updates the LCD with the time
mainloop:
        Gosub gettime   ' Read the time from the RTC

        ' Display time on LCD
        Lcdout $fe, 1, hex2 rtcmonth, "/", hex2 rtcdate, "/" , hex2 rtcyear,_
        "  ", hex2 rtchr, ":", hex2 rtcmin, ":", hex2 rtcsec

        Pause 300       ' Do it about 3 times a second

        Goto mainloop   ' Do it forever

        End
