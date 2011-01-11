// LED leads connected to PWM pins
const int RED_LED_PIN = 9;
const int GREEN_LED_PIN = 10;
const int BLUE_LED_PIN = 11;


const int WAIT_TIME_MS = 500;

void setup() {
  Serial.begin(9600);
  Serial.println("Send the characters 'r', 'g' or 'b' to change LED colour:");
}


void setLedColour(int redIntensity, int greenIntensity, int blueIntensity) {
   analogWrite(RED_LED_PIN, redIntensity);
   analogWrite(GREEN_LED_PIN, greenIntensity);
   analogWrite(BLUE_LED_PIN, blueIntensity);
}

void loop() {

  if (Serial.available()) {
    int characterRead = Serial.read();
    
    switch(characterRead) {
       case 'r':
         setLedColour(255, 0, 0);
         break;
       
       case 'g':
         setLedColour(0, 255, 0);       
         break;
        
       case 'b':
         setLedColour(0, 0, 255);       
         break;
      
       default:
         setLedColour(0, 0, 0);
         break;
    }
    
    delay(WAIT_TIME_MS);
  }

}
