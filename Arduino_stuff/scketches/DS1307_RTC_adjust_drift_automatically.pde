#include "Wire.h"
#define DS1307_ADDRESS 0x68

# reference web page.
# https://forum.arduino.cc/t/ds1307-rtc-adjust-drift-automatically/116592



const int setyearago=1;  //when was the RTC set?
const int setmonth=10;
const int setday=4;
const int spdx100=580;  // secs/day slow error measured over 11 months 580

int second,minute,hour,weekDay,monthDay,month,year;
int errsec,i,j;
long since12,since12wrong;

void ferrsec(){
long t=setyearago*365;
t+=(month-setmonth)*30;
t+=(monthDay-setday);
errsec=t*spdx100/100;
//Serial.println(errsec/60.0);
since12wrong=long(hour)*60*60+minute*60+second;
since12=since12wrong+errsec;
//since12%=(24*60*60); untested and wrong let it overflow
//return;  //skip adjusting
second+=errsec%60;
if(second>=60){
  minute++;
  second-=60;
  }
minute+=errsec/60; 
while(minute>=60){
  hour++;  //could overflow past 23
  minute-=60;
  }
if(hour>=24){
  monthDay++;  //still not good enough could overflow monthDay
  hour-=24;
  }
}
void setup(){
  Wire.begin();
  Serial.begin(9600);
}
void loop(){
  printDate();
  delay(1000);
}
byte bcdToDec(byte val){
  return ( (val/16*10) + (val%16) );
}
void printDate(){
  Wire.beginTransmission(DS1307_ADDRESS);
  Wire.send(0);
  Wire.endTransmission();
  Wire.requestFrom(DS1307_ADDRESS,7);
  second = bcdToDec(Wire.receive());
  minute = bcdToDec(Wire.receive());
  hour = bcdToDec(Wire.receive() & 0b111111); //24 hour time
  weekDay = bcdToDec(Wire.receive()); //0-6 -> sunday - Saturday
  monthDay = bcdToDec(Wire.receive());
  month = bcdToDec(Wire.receive());
  year = bcdToDec(Wire.receive());
  ferrsec();
  Serial.print(month);
  Serial.print("/");
  Serial.print(monthDay);
  Serial.print("/");
  Serial.print(year);
  Serial.print(" ");
  Serial.print(hour);
  Serial.print(":");
  Serial.print(minute);
  Serial.print(":");
  Serial.println(second);
}