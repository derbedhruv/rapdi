/*************************************************************
 *  ARDUINO CODE FOR RAPDeye v3.1 
 *  
 *  AUTHORS: Dhruv Joshi
 *  
 *  This code shall be changed soon, but the steps at present are:
 *  1. Wait for interrupt sending 's' command from MATLAB over serial, if so, start the loop
 *  2. use intensity 100 (PWM value, 8-bit) and ON time 3s, OFF time 0.5s
 *  3. Keep polling for character 'x' which is a STOPNOW function
 *  4. On finishing or STOPNOW, send character 'o' over serial to signal the test is over.
 */
// define the LEDs we are using
#define WLU 9
#define WLD 10
#define WRU 11
#define WRD 13

// DEFINE THE INTENSITY (IN 8-BIT PWM) WE ARE USING
#define intensity 100

// define the variables which will be used in our watchdog
// timer and putting the LEDs on
byte counter = 10;
unsigned long currentMillis, previousMillis = 0;  // must be of the same datatype as millis()
#define ONtime 3000
#define OFFtime 500

void setup() {
  // set pinModes
  pinMode(WLU,OUTPUT);
  pinMode(WLD,OUTPUT);
  pinMode(WRU,OUTPUT);
  pinMode(WRD,OUTPUT);

  // setup serial communication
  Serial.begin(9600);
}

void loop() {
  // FIRST: update the counter
  currentMillis = millis();
  
  // serialEvent is not compatible with micro so using in loop
  if (Serial.available()) {
    char inChar = (char)Serial.read(); 
    if (inChar == 's') {
      // start, and put out a char 'o' at the end
      counter = 0;
      previousMillis = millis();   // initiatlize counter
      Serial.println("Starting...");
      
    } else if (inChar == 'x') {
      // stop immedietely
      turnThemOff();
      counter = 10;  // this is out of bounds, hence put everything OFF
    }
  }
  
  // turn ON and OFF LEDs in sequence
  if (counter < 9) {
    // this means we still need to light up the LEDs
    // ODD nos - left side
    // EVEN nos - right side
    if (counter%2 == 0) {
      // left side
      if (currentMillis - previousMillis < ONtime + OFFtime) {
        // either in ON phase or OFF phase of current step
        if (currentMillis - previousMillis < ONtime) {
          // i.e. we need to put the LEDs ON
          analogWrite(WLU, intensity);
          analogWrite(WLD, intensity);
        } else {
          // we need to put them OFF because this is OFF time
          turnThemOff();
        }
       } else {
          // time to increase counter and put ON next step
          counter++;
          previousMillis = millis();
       }
     } else {
      // right side
      if (currentMillis - previousMillis < ONtime + OFFtime) {
        // either in ON phase or OFF phase of current step
        if (currentMillis - previousMillis < ONtime) {
          // i.e. we need to put the LEDs ON
          analogWrite(WRU, intensity);
          analogWrite(WRD, intensity);
        } else {
          // we need to put them OFF because this is OFF time
          turnThemOff();
        }
       } else {
          // time to increase counter and put ON next step
          counter++;
          previousMillis = millis();
       }
     }
  } else {
    // put all LEDs OFF
    turnThemOff();
    if (counter == 9) {
      Serial.print('o');
      counter = 10;  // since we only want 'o' to be printed once
    }
  }
}

void turnThemOff() {
  // function to turn everything OFF
  analogWrite(WLU, 0);
  analogWrite(WLD, 0);
  analogWrite(WRU, 0);
  analogWrite(WRD, 0);
}

