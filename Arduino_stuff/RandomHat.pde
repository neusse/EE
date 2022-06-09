/* RandomHat
 Paul Badger 2007
 choose one from a hat of n choices each time through loop
 Choose each number exactly once before reseting and choosing again
 */

#define randomHatStartNum 0
#define randomHatEndNum 10
#define NumberInHat abs(randomHatEndNum - randomHatStartNum) + 1

int i, x;

void setup()
{
  Serial.begin(9600);
  Serial.println("start ");
}

void loop()
{        // randomHat test
  for (i=1; i<=NumberInHat; i++){
    x = randomHat();
   Serial.print(x);
    Serial.print(" ");
    delay(100);
  }
   Serial.println(" ");
}



int randomHat(){
  static int  totalNumInHat = abs(randomHatEndNum - randomHatStartNum) + 1;
  static int currentNumInHat = 0; 
  abs(randomHatEndNum - randomHatStartNum) + 1;
  static int randArray[abs(randomHatEndNum - randomHatStartNum) + 1];
  int i;		//as long as they can be changed without harming other code
  int thePick;		//this is the return variable with the random number from the pool		
  int theIndex;

  if  (currentNumInHat == 0){                   // hat is emply - all have been choosen - fill up array again
    for (i = 0 ; i<=(totalNumInHat - 1); i++){  // Put 1 TO numberInHat in array - starting at address 0.
      if (randomHatStartNum < randomHatEndNum){
      randArray[i] = randomHatStartNum + i; }	
      else if (randomHatStartNum > randomHatEndNum){  // defensive programming in case startNum is greater than endNum
       randArray[i] = randomHatEndNum + i; }
       else{ 
       return randomHatStartNum; }	        // startNum and endNum must be same number - return one - and bail out 
     }					
    currentNumInHat = abs(randomHatEndNum - randomHatStartNum) + 1;   // reset current Number in Hat
    //if something should happen when the hat is empty do it here
  }

  theIndex = random(currentNumInHat);	        //choose a random index	
  thePick = randArray[theIndex];

  for (i = theIndex; i<= (currentNumInHat - 1); i++){
    randArray[i] =  randArray[i + 1];           // bump all the higher array contents down one,  erasing the last number chosen
  }
  currentNumInHat--;                            // decrement counter
  return thePick;
}
