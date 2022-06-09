 int incomingByte = 0;	// for incoming serial data
int transistorPin = 2;
int ultraSoundSignal = 7; // Ultrasound signal pin
int val = 0;
int ultrasoundValue = 0;
int timecount = 0; // Echo counter
int ledPin = 13; // LED connected to digital pin 13
int waitTime;

void setup() {
	//Serial.begin(9600);	// opens serial port, sets data rate to 9600 bps
        pinMode(transistorPin, OUTPUT);
        pinMode(ledPin, OUTPUT);
}

void loop() {
 timecount = 0;
 val = 0;
 waitTime = 0;
 pinMode(ultraSoundSignal, OUTPUT); // Switch signalpin to output

// Send low-high-low pulse to activate the trigger pulse of the sensor

digitalWrite(ultraSoundSignal, LOW); // Send low pulse
delayMicroseconds(2); // Wait for 2 microseconds
digitalWrite(ultraSoundSignal, HIGH); // Send high pulse
delayMicroseconds(5); // Wait for 5 microseconds
digitalWrite(ultraSoundSignal, LOW); // Holdoff

// Listening for echo pulse

pinMode(ultraSoundSignal, INPUT); // Switch signalpin to input
val = digitalRead(ultraSoundSignal); // Append signal value to val
while(val == LOW) { // Loop until pin reads a high value
  val = digitalRead(ultraSoundSignal);
}
    
while(val == HIGH) { // Loop until pin reads a high value
  val = digitalRead(ultraSoundSignal);
  timecount = timecount +1;            // Count echo pulse time
}

//Writing out values to the serial port:

ultrasoundValue = timecount; // Append echo pulse time to ultrasoundValue
/*
serialWrite('A'); // Example identifier for the sensor
printInteger(ultrasoundValue);
serialWrite(10);
serialWrite(13);
*/

// ***** Motor Stuff *****

//digitalWrite(transistorPin, LOW); // turn motor off.
//digitalWrite(ledPin, LOW);

if (ultrasoundValue < 2600) { // Set activation threshold
  
  /* for loop adds a "tail" to the motors activation, so that movement continues
     for a short time after it has been activated.
     remove for loop to have direct maping of ultrasoundValue onto motor speed. */
     
      for (int i=0; i < random(60, 140); i++) {
          digitalWrite(transistorPin, LOW); // turn motor off.
          digitalWrite(ledPin, LOW); 
          delay(random(5, 25));
          digitalWrite(transistorPin, HIGH); // turn motor on;
          digitalWrite(ledPin, HIGH);
          delay(10);
      }
}

  else {
      digitalWrite(transistorPin, LOW); // turn motor off.
      digitalWrite(ledPin, LOW); 
      delay(100);
    }
}
