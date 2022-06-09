#include <SoftwareSerial.h>

/* port of Peter Anderson's  LCD117_1.BS2  (Parallax Basic Stamp 2) to Arduino
 Paul Badger 2007
 original Peter H. Anderson, Baltimore, MD, Oct, '06
 
 Configured for 20 x 4 display
 Printing demonstration will probably look ugly with shorter displays
 Delays in bargraph section have been tweaked to be close to minimums
 
 I took some liberties with code
 * changed printing demonstration slightly
 * eliminated speaker demonstration
 * simplified bar graph section
 
 */


int N;
int I;
int ByteVar;

int NN;
int Remainder;
int Num_5;

#define rxPin 4  // rxPin is immaterial - not used - just make this an unused Arduino pin number
#define txPin 3
SoftwareSerial mySerial =  SoftwareSerial(rxPin, txPin);


// mySerial is connected to the TX pin so mySerial.print commands are used
// one could just as well use the software mySerial library to communicate on another pin

void setup(){


  pinMode(txPin, OUTPUT);
  mySerial.begin(9600);    // 9600 baud is chip comm speed

  mySerial.print("?G420");
  delay(100);	           // pause to allow LCD EEPROM to program

  mySerial.print("?Bff");  // set backlight to 40 hex
  delay(100);              // pause to allow LCD EEPROM to program

  mySerial.print("?s6");   // set tabs to six spaces
  delay(1000);              // pause to allow LCD EEPROM to program

  mySerial.print("?D00000000000000000");       // define special characters
  delay(100);                                  // delay to allow write to EEPROM
  //crashes LCD without delay
  mySerial.print("?D11010101010101010");
  delay(100);

  mySerial.print("?D21818181818181818");
  delay(100);

  mySerial.print("?D31c1c1c1c1c1c1c1c");
  delay(100);

  mySerial.print("?D41e1e1e1e1e1e1e1e");
  delay(100);

  mySerial.print("?D51f1f1f1f1f1f1f1f");
  delay(100);

  mySerial.print("?c0");		                // turn cursor off
  delay(200);  
  
  mySerial.print("?f");                   // clear the LCD

  delay(1000);

}

void loop(){

  mySerial.print("?f");                   // clear the LCD

  mySerial.print("     LCD #117?n");      //note new line

  mySerial.print("www.phanderson.com?n");

  mySerial.print("?0?1?2?3?4?5?6?7?n");	 // display special characters

  delay(3000);		                 // pause three secs to admire
  
  mySerial.print("?f");                   // clear the LCD

  mySerial.print("?x00?y1");		 // move cursor to beginning of line 1
  mySerial.print("  LCD117 serial PCB");   // crass commercial message
  mySerial.print("?x00?y2");		 // move cursor to beginning of line 1
  mySerial.print("  moderndevice.com");    // crass commercial message

  delay(6000);		                 // pause three secs to admire

  mySerial.print("?f");                  // clear the screen

  mySerial.print("?x00?y0");		 // locate cursor to beginning of line 0
  mySerial.print("DEC  HEX  ASCII  VAR");   // print labels
  delay(100);
                                         // simple printing demonstation  
  for (N = 42; N<= 122; N++){            // pick an arbitrary part of ASCII chart - change as you wish     
    mySerial.print("?x00?y1");		 // locate cursor to beginning of line 1
    mySerial.print(N, DEC);              // display N in decimal format
    mySerial.print("?t");                // tab in

    mySerial.print(N, HEX);              // display N in hexidecimal format
    mySerial.print("?t");                // tab in

    mySerial.print(N, BYTE);             // display N as an ASCII character
    // glitches on ASCHII 63 "?"

    mySerial.print("    ");              // move in four spaces


    // demonstrates debugging a variable
    ByteVar = N + 10;                    // put some data into "ByteVar" (variable)
    mySerial.print(ByteVar, DEC);        // display a  byte varible - easy!
    delay(500);
  }



  mySerial.print("?y3?x00");         // cursor to beginning of line 3
  delay(10);
  mySerial.print("?l");	             // clear line
  delay(10);
                                     // bar graph demo - increasing bar
  for ( N = 0; N <= 100; N++){	     // 20 chars * 5 bits each = 100
    mySerial.print("?y3?x00");       // cursor to beginning of line 3
    delay(10);

    Num_5 = N / 5;                   // calculate solid black tiles
    for (I = 1; I <= Num_5; I++){ 
      mySerial.print("?5");          // print custom character 5 - solid block tiles
      delay(4);
    }

    Remainder = N % 5;               // % sign is modulo operator - calculates remainder              
    // now print the remainder
    mySerial.print("?");             // first half of the custom character command
    mySerial.print(Remainder, DEC);  // prints the custom character equal to remainder
    delay(5);
  }  

  delay(50);

  for ( N = 100; N >= 0; N--){	     // decreasing bar - 20 chars * 5 bits each
    mySerial.print("?y3?x00");       // cursor to beginning of line 3
    delay(10);

    Num_5 = N / 5;                   // calculate solid black tiles
    for (I = 1; I <= Num_5; I++){ 
      mySerial.print("?5");          // print custom character 5 - solid block tiles
      delay(5);
    }

    Remainder = N % 5;               // % sign is modulo operator - calculates remainder              
    // now print the remainder
    mySerial.print("?");             // first half of the custom character command
    mySerial.print(Remainder, DEC);  // prints the custom character equal to remainder
    delay(5);
  }  


}
