/*
 * GPS support for Alpha Clock Five
 * (C) 2013 William B Phelps
 * All commercial rights reserved
 */

#include "gps.h"
#include "alphafive.h"
#include <DS1307RTC.h>  // For optional RTC module. (This library included with the Arduino Time library)

uint8_t GPS_mode = 0;  // 0, 48, 96
#define gpsTimeoutLimit 5  // 5 seconds until we display the "no gps" message

unsigned long tGPSupdateUT = 0;  // time since last GPS update in UT
unsigned long tGPSupdate = 0;  // time since last GPS update in local time
byte GPSupdating = false;

int8_t TZ_hour = -8;
int8_t TZ_minutes = 0;
//uint8_t DST_offset = 0;

// GPS parser for 406a
#define GPSBUFFERSIZE 128 // plenty big
char gpsBuffer[GPSBUFFERSIZE];

// get data from gps and update the clock (if possible)
void getGPSdata(void) {
//  char charReceived = UDR0;  // get a byte from the port
  char charReceived = Serial1.read();
  uint8_t bufflen = strlen(gpsBuffer);
  //If the buffer has not been started, check for '$'
  if ( ( bufflen == 0 ) &&  ( '$' != charReceived ) )
    return;  // wait for start of next sentence from GPS
  if ( bufflen < (GPSBUFFERSIZE - 1) ) {  // is there room left? (allow room for null term)
    if ( '\r' != charReceived ) {  // end of sentence?
      strncat(gpsBuffer, &charReceived, 1);  // add char to buffer
      return;
    }
    strncat(gpsBuffer, "*", 1);  // mark end of buffer just in case
    //beep(1000, 1);  // debugging
    // end of sentence - is this the message we are looking for?
    if (strncmp(gpsBuffer, "$GPRMC", 6) == 0)
      parseGPSdata(gpsBuffer);  // check for GPRMC sentence and set clock
  }  // if space left in buffer
  // either buffer is full, or the message has been processed. reset buffer for next message
  memset( gpsBuffer, 0, GPSBUFFERSIZE );  // clear GPS buffer
}  // getGPSdata

uint8_t gpshour, gpsminute, gpssecond, gpsyear, gpsmonth, gpsday;
uint32_t latitude, longitude;
uint8_t groundspeed, trackangle;
char latdir, longdir;
char status;
char checksum[3];
char gpsTime[11];
uint16_t gps_cks_errors, gps_parse_errors, gps_time_errors;

uint32_t parsedecimal(char *str) {
  uint32_t d = 0;
  while (str[0] != 0) {
    if ((str[0] > '9') || (str[0] < '0'))
      return d;  // no more digits
    d = (d*10) + (str[0] - '0');
    str++;
  }
  return d;
}
const char hex[17] = "0123456789ABCDEF";
uint8_t atoh(char x) {
  return (strchr(hex, x) - hex);
}
uint32_t hex2i(char *str, uint8_t len) {
  uint32_t d = 0;
  for (uint8_t i=0; i<len; i++) {
    d = (d*10) + (strchr(hex, str[i]) - hex);
  }
  return d;
}
//  225446       Time of fix 22:54:46 UTC
//  A            Navigation receiver warning A = OK, V = warning
//  4916.45,N    Latitude 49 deg. 16.45 min North
//  12311.12,W   Longitude 123 deg. 11.12 min West
//  000.5        Speed over ground, Knots
//  054.7        Course Made Good, True
//  191194       Date of fix  19 November 1994
//  020.3,E      Magnetic variation 20.3 deg East
//  *68          mandatory checksum

//$GPRMC,225446.000,A,4916.45,N,12311.12,W,000.5,054.7,191194,020.3,E*68\r\n
// 0         1         2         3         4         5         6         7
// 0123456789012345678901234567890123456789012345678901234567890123456789012
//    0     1       2    3    4     5    6   7     8      9     10  11 12
void parseGPSdata(char *gpsBuffer) {
  time_t tNow, tDelta;
  tmElements_t tm;
  uint8_t gpsCheck1, gpsCheck2;  // checksums
  //	char gpsTime[10];  // time including fraction hhmmss.fff
  char gpsFixStat;  // fix status
  //	char gpsLat[7];  // ddmm.ff  (with decimal point)
  //	char gpsLatH;  // hemisphere 
  //	char gpsLong[8];  // dddmm.ff  (with decimal point)
  //	char gpsLongH;  // hemisphere 
  //	char gpsSpeed[5];  // speed over ground
  //	char gpsCourse[5];  // Course
  //	char gpsDate[6];  // Date
  //	char gpsMagV[5];  // Magnetic variation 
  //	char gpsMagD;  // Mag var E/W
  //	char gpsCKS[2];  // Checksum without asterisk
  char *ptr;
  uint32_t tmp;
  if ( strncmp( gpsBuffer, "$GPRMC,", 7 ) == 0 ) {  
    //beep(1000, 1);
    //Calculate checksum from the received data
    ptr = &gpsBuffer[1];  // start at the "G"
    gpsCheck1 = 0;  // init collector
    /* Loop through entire string, XORing each character to the next */
    while (*ptr != '*') // count all the bytes up to the asterisk
    {
      gpsCheck1 ^= *ptr;
      ptr++;
      if (ptr>(gpsBuffer+GPSBUFFERSIZE)) goto GPSerror1;  // extra sanity check, can't hurt...
    }
    // now get the checksum from the string itself, which is in hex
    gpsCheck2 = atoh(*(ptr+1)) * 16 + atoh(*(ptr+2));
    if (gpsCheck1 == gpsCheck2) {  // if checksums match, process the data
      //beep(1000, 1);
      ptr = strtok(gpsBuffer, ",*\r");  // parse $GPRMC
      if (ptr == NULL) goto GPSerror1;
      ptr = strtok(NULL, ",*\r");  // Time including fraction hhmmss.fff
      if (ptr == NULL) goto GPSerror1;
      if ((strlen(ptr) < 6) || (strlen(ptr) > 10)) goto GPSerror1;  // check time length
      //			strncpy(gpsTime, ptr, 10);  // copy time string hhmmss
      tmp = parsedecimal(ptr);   // parse integer portion
      tm.Hour = tmp / 10000;
      tm.Minute = (tmp / 100) % 100;
      tm.Second = tmp % 100;
      ptr = strtok(NULL, ",*\r");  // Status
      if (ptr == NULL) goto GPSerror1;
      gpsFixStat = ptr[0];
      if (gpsFixStat == 'A') {  // if data valid, parse time & date
        ptr = strtok(NULL, ",*\r");  // Latitude including fraction
        if (ptr == NULL) goto GPSerror1;
        //				strncpy(gpsLat, ptr, 7);  // copy Latitude ddmm.ff
        ptr = strtok(NULL, ",*\r");  // Latitude N/S
        if (ptr == NULL) goto GPSerror1;
        //				gpsLatH = ptr[0];
        ptr = strtok(NULL, ",*\r");  // Longitude including fraction hhmm.ff
        if (ptr == NULL) goto GPSerror1;
        //				strncpy(gpsLong, ptr, 7);
        ptr = strtok(NULL, ",*\r");  // Longitude Hemisphere
        if (ptr == NULL) goto GPSerror1;
        //				gpsLongH = ptr[0];
        ptr = strtok(NULL, ",*\r");  // Ground speed 000.5
        if (ptr == NULL) goto GPSerror1;
        //				strncpy(gpsSpeed, ptr, 5);
        ptr = strtok(NULL, ",*\r");  // Track angle (course) 054.7
        if (ptr == NULL) goto GPSerror1;
        //				strncpy(gpsCourse, ptr, 5);
        ptr = strtok(NULL, ",*\r");  // Date ddmmyy
        if (ptr == NULL) goto GPSerror1;
        //				strncpy(gpsDate, ptr, 6);
        if (strlen(ptr) != 6) goto GPSerror1;  // check date length
        tmp = parsedecimal(ptr);
        tm.Day = tmp / 10000;
        tm.Month = (tmp / 100) % 100;
        tm.Year = tmp % 100;
        ptr = strtok(NULL, "*\r");  // magnetic variation & dir
        if (ptr == NULL) goto GPSerror1;
        if (ptr == NULL) goto GPSerror1;
        ptr = strtok(NULL, ",*\r");  // Checksum
        if (ptr == NULL) goto GPSerror1;
        //				strncpy(gpsCKS, ptr, 2);  // save checksum chars

        tm.Year = y2kYearToTm(tm.Year);  // convert yy year to (yyyy-1970) (add 30)
        tNow = makeTime(tm);  // convert to time_t
        tDelta = abs(tNow-tGPSupdateUT);

        if ((tGPSupdateUT > 0) && (tDelta > SECS_PER_DAY))  goto GPSerror2;  // GPS time jumped more than 1 day
        GPSupdating = false;  // valid GPS data received, flip the LED off

        if ((tm.Second == 59) || (tDelta >= 60)) {  // update RTC once/minute or if it's been 60 seconds
          //beep(1000, 1);  // debugging
          a5loadOSB_DP("____2",a5_brightLevel);  // wbp
          a5BeginFadeToOSB();  
          GPSupdating = true;
          tGPSupdateUT = tNow;  // remember time of this update (UT)
          tNow = tNow + (long)(TZ_hour + DST_offset) * SECS_PER_HOUR;  // add time zone hour offset & DST offset
          if (TZ_hour < 0)  // add or subtract time zone minute offset
            tNow = tNow - (long)TZ_minutes * SECS_PER_MIN;  // 01feb13/wbp
          else
            tNow = tNow + (long)TZ_minutes * SECS_PER_MIN;  // 01feb13/wbp
          setTime(tNow);
          if (UseRTC)  
            RTC.set(now());  // set RTC from adjusted GPS time & date

          tGPSupdate = tNow;  // remember time of this update (local time)
          Serial.println("time set from GPS");
        }

      } // if fix status is A
    } // if checksums match
    else  // checksums do not match
    gps_cks_errors++;  // increment error count
    return;
GPSerror1:
    gps_parse_errors++;  // increment error count
    goto GPSerror2a;
GPSerror2:
    gps_time_errors++;  // increment error count
GPSerror2a:
    Serial.println("GPS error");
//    beep(2093,1);  // error signal - I'm leaving this in for now /wm
    a5tone(2093,200);
//???    flash_display(200);  // flash display to show GPS error
    strcpy(gpsBuffer, "");  // wipe GPS buffer
  }  // if "$GPRMC"
}

//void uart_init(uint16_t BRR) {
//  /* setup the main UART */
//  UBRR0 = BRR;               // set baudrate counter
//  UCSR0B = _BV(RXEN0) | _BV(TXEN0);
//  UCSR0C = _BV(USBS0) | (3<<UCSZ00);
//  DDRD |= _BV(PD1);
//  DDRD &= ~_BV(PD0);
//}

void GPSinit(uint8_t gps) {
//	switch (gps) {
//		case(0):  // no GPS
//			break;
//		case(48):
//			uart_init(BRRL_4800);
//			break;
//		case(96):
//			uart_init(BRRL_9600);
//			break;
//	}
    tGPSupdate = 0;  // reset GPS last update time
    GPSupdating = false;  // GPS not updating yet
//	gpsDataReady_ = false;
//  gpsBufferPtr = 0;
//  gpsNextBuffer = gpsBuffer1;
//  gpsLastBuffer = gpsBuffer2;
}

