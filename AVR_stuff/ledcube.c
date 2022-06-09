/*
LEDcube
Firmware
for use with ATtiny2313
24-September-07

Distributed under Creative Commons 2.5 -- Attib & Share Alike
*/

/*
to program the ATtiny2313, execute the following two commands:
     make ledcube.hex
     make program-ledcube
*/


#include <avr/io.h>             // this contains all the IO port definitions
#include <avr/interrupt.h>      // definitions for interrupts
#include <avr/sleep.h>          // definitions for power-down modes
#include <avr/pgmspace.h>       // definitions or keeping constants in program memory


/*
The hardware for this project is as follows:
     ATtiny2313 has 20 pins:
       pin 1   connects to serial port programming circuitry
       pin 2   PD0 - ground for bottom plane of 3x3 LEDs
       pin 3   PD1 - ground for middle plane of 3x3 LEDs
       pin 6   PD2 - ground for top plane of 3x3 LEDs
       pin 7   PD3 - +V for lower-left LED of each plane (through a 47 ohm resistor)
       pin 10  ground
       pin 12  PB0 - +V for upper-right LED of each plane (R8)
       pin 13  PB1 - +V for upper-middle LED of each plane (R7)
       pin 14  PB2 - +V for upper-left LED of each plane (R6)
       pin 15  PB3 - +V for middle-right LED of each plane (R5)
       pin 16  PB4 - +V for midle-middle LED of each plane (R4)
       pin 17  PB5 - +V for middle-left LED of each plane (R3) -- also connects to serial port programming circuitry
       pin 18  PB6 - +V for lower-right LED of each plane (R2) -- also connects to serial port programming circuitry
       pin 19  PB7 - +V for lower-middle LED of each plane (R1) -- also connects to serial port programming circuitry
       pin 20  +3v
    All other pins are unused

    This firmware requires that the clock frequency of the ATtiny 
      is the default that it is shipped with:  8.0MHz internal oscillator
*/


/*
The C compiler creates code that will transfer all constants into RAM when the microcontroller
resets.  Since this firmware has a table (brainwaveTab) that is too large to transfer into RAM,
the C compiler needs to be told to keep it in program memory space.  This is accomplished by
the macro PROGMEM (this is used, below, in the definition for the brainwaveTab).  Since the
C compiler assumes that constants are in RAM, rather than in program memory, when accessing
the brainwaveTab, we need to use the pgm_read_byte() and pgm_read_dword() macros, and we need
to use the brainwveTab as an address, i.e., precede it with "&".  For example, to access 
imageTab[3].topRow0, which is a byte, this is how to do it:
     pgm_read_byte( &imageTab[3].topRow0 );
And to access imageTab[3].imageDuration, which is a double-word, this is how to do it:
     pgm_read_dword( &imageTab[3].imageDuration );
*/


// table of values for 3x3x3 LEDs
// 0 is off, 1 is on for each LED
// last element must have 0 duration
struct imageElement {
  unsigned char topRow0;
  unsigned char midRow0;
  unsigned char botRow0;
  unsigned char topRow1;
  unsigned char midRow1;
  unsigned char botRow1;
  unsigned char topRow2;
  unsigned char midRow2;
  unsigned char botRow2;
  unsigned long int imageDuration;  // Duration for this element to be displayed before going to next element (divide by 10,000 to get seconds)
} const imageTab[] PROGMEM = {
  { 0b111, 0b111, 0b111, 0b111, 0b101, 0b111, 0b111, 0b111, 0b111, 50000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110, 50000 },
  { 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b100, 50000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110, 50000 },
  { 0b111, 0b111, 0b111, 0b111, 0b101, 0b111, 0b111, 0b111, 0b111, 40000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110, 40000 },
  { 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b100, 40000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110, 40000 },
  { 0b111, 0b111, 0b111, 0b111, 0b101, 0b111, 0b111, 0b111, 0b111, 30000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110, 30000 },
  { 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b100, 30000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110, 30000 },
  { 0b111, 0b111, 0b111, 0b111, 0b101, 0b111, 0b111, 0b111, 0b111, 20000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110, 20000 },
  { 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b100, 20000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110, 20000 },
  { 0b111, 0b111, 0b111, 0b111, 0b101, 0b111, 0b111, 0b111, 0b111, 10000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110, 10000 },
  { 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b100, 10000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110, 10000 },
  { 0b111, 0b111, 0b111, 0b111, 0b101, 0b111, 0b111, 0b111, 0b111,  7000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110,  7000 },
  { 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b100,  7000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110,  7000 },
  { 0b111, 0b111, 0b111, 0b111, 0b101, 0b111, 0b111, 0b111, 0b111,  4000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110,  4000 },
  { 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b100,  4000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110,  4000 },
  { 0b111, 0b111, 0b111, 0b111, 0b101, 0b111, 0b111, 0b111, 0b111,  4000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110,  4000 },
  { 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b100,  4000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110,  4000 },
  { 0b111, 0b111, 0b111, 0b111, 0b101, 0b111, 0b111, 0b111, 0b111,  4000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110,  4000 },
  { 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b100,  4000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110,  4000 },
  { 0b111, 0b111, 0b111, 0b111, 0b101, 0b111, 0b111, 0b111, 0b111,  4000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110,  4000 },
  { 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b100,  4000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110,  4000 },
  { 0b111, 0b111, 0b111, 0b111, 0b101, 0b111, 0b111, 0b111, 0b111,  7000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110,  7000 },
  { 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b100,  7000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110,  7000 },
  { 0b111, 0b111, 0b111, 0b111, 0b101, 0b111, 0b111, 0b111, 0b111, 10000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110, 10000 },
  { 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b100, 10000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110, 10000 },
  { 0b111, 0b111, 0b111, 0b111, 0b101, 0b111, 0b111, 0b111, 0b111, 20000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110, 20000 },
  { 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b100, 20000 },
  { 0b000, 0b000, 0b000, 0b000, 0b110, 0b110, 0b000, 0b110, 0b110, 20000 },
  { 0b111, 0b111, 0b111, 0b111, 0b111, 0b111, 0b111, 0b111, 0b111, 20000 },
  { 0b000, 0b000, 0b000, 0b000, 0b111, 0b111, 0b111, 0b111, 0b111, 20000 },
  { 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b111, 0b111, 0b111, 20000 },
  { 0b000, 0b000, 0b000, 0b111, 0b111, 0b111, 0b000, 0b000, 0b000, 20000 },
  { 0b111, 0b111, 0b111, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 20000 },
  { 0b000, 0b000, 0b000, 0b111, 0b111, 0b111, 0b000, 0b000, 0b000, 20000 },
  { 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b111, 0b111, 0b111, 10000 },
  { 0b000, 0b000, 0b000, 0b111, 0b111, 0b111, 0b000, 0b000, 0b000, 10000 },
  { 0b111, 0b111, 0b111, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 10000 },
  { 0b000, 0b000, 0b000, 0b111, 0b111, 0b111, 0b000, 0b000, 0b000, 10000 },
  { 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b111, 0b111, 0b111,  7000 },
  { 0b000, 0b000, 0b000, 0b111, 0b111, 0b111, 0b000, 0b000, 0b000,  7000 },
  { 0b111, 0b111, 0b111, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000,  7000 },
  { 0b000, 0b000, 0b000, 0b111, 0b111, 0b111, 0b000, 0b000, 0b000,  7000 },
  { 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b111, 0b111, 0b111,  7000 },
  { 0b000, 0b000, 0b000, 0b111, 0b111, 0b111, 0b000, 0b000, 0b000,  7000 },
  { 0b111, 0b111, 0b111, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000,  7000 },
  { 0b000, 0b000, 0b000, 0b111, 0b111, 0b111, 0b000, 0b000, 0b000,  7000 },
  { 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b111, 0b111, 0b111, 10000 },
  { 0b000, 0b000, 0b000, 0b111, 0b111, 0b111, 0b000, 0b000, 0b000, 10000 },
  { 0b111, 0b111, 0b111, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 10000 },
  { 0b000, 0b000, 0b000, 0b111, 0b111, 0b111, 0b000, 0b000, 0b000, 10000 },
  { 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b111, 0b111, 0b111, 10000 },
  { 0b000, 0b000, 0b000, 0b111, 0b111, 0b111, 0b111, 0b111, 0b111, 10000 },  // this is a dummy element for end of table (duration=0)
  { 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000, 0b000,     0 },  // this is a dummy element for end of table (duration=0)
};


// This function delays the specified number of 1/10 milliseconds
void delay_one_tenth_ms(unsigned long int ms) {
  unsigned long int timer;
  const unsigned long int DelayCount=87;  // this value was determined by trial and error

  while (ms != 0) {
    // Toggling PD6 is done here to force the compiler to do this loop, rather than optimize it away
    for (timer=0; timer <= DelayCount; timer++) {PIND |= 0b01000000;};
    ms--;
  }
}


// This function displays a 3x3x3 image by multiplexing through the images for the 3 planes.
//   The multiplex rate is about 111Hz.
// This function also acts as a delay for the Duration specified.
void displayImage(int index) {
  unsigned long int duration = pgm_read_dword( &imageTab[index].imageDuration );
  for (int i=0; i<(duration/(90*3*2)); i++) {
    PORTB |= pgm_read_byte( &imageTab[index].topRow0 ) | (pgm_read_byte( &imageTab[index].midRow0 )<<3 ) | (pgm_read_byte( &imageTab[index].botRow0 )<<6 );
    PORTD |= ( ( pgm_read_byte( &imageTab[index].botRow0 ) & 0b100 ) ) << 1;
    PORTD &= ~(1<<PD2);  // turn on top plane
    delay_one_tenth_ms(30);
    PORTD |= (1<<PD2);   // turn off top plane
    PORTB &= ~( pgm_read_byte( &imageTab[index].topRow0 ) | (pgm_read_byte( &imageTab[index].midRow0 )<<3 ) | (pgm_read_byte( &imageTab[index].botRow0 )<<6 ) );
    PORTD &= ~( ( ( pgm_read_byte( &imageTab[index].botRow0 ) & 0b100 ) ) << 1);

    PORTB |= pgm_read_byte( &imageTab[index].topRow1 ) | (pgm_read_byte( &imageTab[index].midRow1 )<<3 ) | (pgm_read_byte( &imageTab[index].botRow1 )<<6 );
    PORTD |= ( ( pgm_read_byte( &imageTab[index].botRow1 ) & 0b100 ) ) << 1;
    PORTD &= ~(1<<PD1);  // turn on middle plane
    delay_one_tenth_ms(30);
    PORTD |= (1<<PD1);   // turn off middle plane
    PORTB &= ~( pgm_read_byte( &imageTab[index].topRow1 ) | (pgm_read_byte( &imageTab[index].midRow1 )<<3 ) | (pgm_read_byte( &imageTab[index].botRow1 )<<6 ) );
    PORTD &= ~( ( ( pgm_read_byte( &imageTab[index].botRow1 ) & 0b100 ) ) << 1);

    PORTB |= pgm_read_byte( &imageTab[index].topRow2 ) | (pgm_read_byte( &imageTab[index].midRow2 )<<3 ) | (pgm_read_byte( &imageTab[index].botRow2 )<<6 );
    PORTD |= ( ( pgm_read_byte( &imageTab[index].botRow2 ) & 0b100 ) ) << 1;
    PORTD &= ~(1<<PD0);  // turn on bottom plane
    delay_one_tenth_ms(30);
    PORTD |= (1<<PD0);   // turn off bottom plane
    PORTB &= ~( pgm_read_byte( &imageTab[index].topRow2 ) | (pgm_read_byte( &imageTab[index].midRow2 )<<3 ) | (pgm_read_byte( &imageTab[index].botRow2 )<<6 ) );
    PORTD &= ~( ( ( pgm_read_byte( &imageTab[index].botRow2 ) & 0b100 ) ) << 1);
  }
}


int main(void) {
  DDRB = 0xFF;   // set all PortB pins as outputs
  DDRD = 0x7F;   // set all PortD pins as outputs
  PORTB = 0x00;  // all PORTB output pins Off
  PORTD = 0b00000111;  // PORTD3 output pin Off, PORTD2 and PORTD1 and PORTD0 on (grounds)


  // loop through entier Image Table a bunch of times
  for (int i=0; i<30; i++) {
    // loop through entire Image Table of Image Elements
    //   each Image Element consists of a 3 planes of 3x3 LED (each LED on or off) data and a Duration
    int j = 0;
    do {
      displayImage(j);
      j++;
    } while (pgm_read_byte(&imageTab[j].imageDuration) != 0);  // 0 signifies end of table
  }


  // Shut down everything and put the CPU to sleep
  MCUCR |= 0b00100000;   // SE=1 (bit 5)
  MCUCR |= 0b00010000;   // SM1:0=01 to enable Power Down Sleep Mode (bits 6, 4)
  delay_one_tenth_ms(10000);  // wait 1 second
  PORTB = 0x00;          // turn off all PORTB outputs
  PORTD = 0x00;          // turn off all PORTD outputs
  DDRB = 0x00;           // make PORTB all inputs
  DDRD = 0x00;           // make PORTD all inputs
  sleep_cpu();           // put CPU into Power Down Sleep Mode
}

