' LCD clock program using Dallas1202/1302 RTC

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
RST     var     PORTA.2
IO      var     PORTC.1
SCLK    var     PORTC.3

' Allocate variables
rtcyear var     byte
rtcday  var     byte
rtcmonth var    byte
rtcdate var     byte
rtchr   var     byte
rtcmin  var     byte
rtcsec  var     byte
rtccontrol var  byte


        Low RST         ' Reset RTC
        Low SCLK

        ADCON1 = 7      ' PORTA and E digital
        Low PORTE.2     ' LCD R/W low = write
        Pause 100       ' Wait for LCD to startup

        ' Set initial time to 8:00:00AM 07/16/99
        rtcyear = $99
        rtcday = $06
        rtcmonth = $07
        rtcdate = $16
        rtchr = $08
        rtcmin = 0
        rtcsec = 0
        Gosub settime   ' Set the time

        Goto mainloop   ' Skip subroutines


' Subroutine to write time to RTC
settime:
        RST = 1         ' Ready for transfer

        ' Enable write
        Shiftout IO, SCLK, LSBFIRST, [$8e, 0]

        RST = 0         ' Reset RTC

        RST = 1         ' Ready for transfer

        ' Write all 8 RTC registers in burst mode
        Shiftout IO, SCLK, LSBFIRST, [$be, rtcsec, rtcmin, rtchr, rtcdate, rtcmonth, rtcday, rtcyear, 0]

        RST = 0         ' Reset RTC
        Return

' Subroutine to read time from RTC
gettime:
        RST = 1         ' Ready for transfer

        Shiftout IO, SCLK, LSBFIRST, [$bf]      ' Read all 8 RTC registers in burst mode
        Shiftin IO, SCLK, LSBPRE, [rtcsec, rtcmin, rtchr, rtcdate, rtcmonth, rtcday, rtcyear, rtccontrol]

        RST = 0         ' Reset RTC
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
