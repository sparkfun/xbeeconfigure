/*

  XBeeSerialEcho -- Simple sketch for demonstrating two-way XBee communication

  Requires:
  
    (These items are found in the SparkFun XBee Wireless Kit Retail product
     or can be obtained individually.)
  
       * 1 x SparkFun XBee Explorer USB
    
       * 1 x SparkFun XBee Wireless Shield
    
       * 2 x "Series 1" Digi XBee communication modules
    

  Instructions:
  
    * Upload this sketch as normal to your Arduino without the XBee Wireless
      Shield connected.
      
    * Disconnect the Arduino from your computer.
  
    * Both XBee modules should be configured to use their default 
      configuration and communicate at 9600 baud.
      
    * One XBee module should be connected to the XBee Explorer board.
      Ensure the orientation of the XBee module is correct with the
      beveled end of the module pointing away from the USB connector
      so the module outline matches the diagonal white lines
      silkscreened on the board.
      
    * The other XBee module should be connected to the XBee Wireless
      Shield for the Arduino. Again, ensure the orientation of the
      XBee module is correct with the beveled end pointing over the
      edge of the shield away from the USB connector on the Arduino
      board. The outline of the module should match the the diagonal
      white lines silkscreened on the shield.
      
    * The small switch located near the TX/RX pins on the shield
      should be set to the "UART" position so the XBee module is
      connected to the hardware serial port on the Arduino.
    
    * Connect the XBee Wireless Shield to your Arduino.
  
    * Connect the XBee Explorer USB to your computer with a mini-USB cable.
  
    * Select the correct serial port for your XBee Explorer USB from the
      Tools > Serial Port menu in the Arduino IDE.
  
    * Connect your Arduino with the XBee Wireless Shield on it to a
      power source--either a battery, a "wall wart" power adapter or
      another USB port.
      
    * Open the Serial Monitor window of the Arduino IDE and make sure
      the correct communication speed of "9600 baud" is selected from
      the pop-up menu in the lower right corner of the Serial Monitor
      window.
      
    * Start typing and whenever you press the button labeled "Send" or
      press the "Enter" or "Return" key what you type should be echoed
      back to you. (If only "garbage" is returned you probably have
      the XBee modules configured for the wrong speed.  Reconfigure
      them to operate at 9600 baud and try again.)
     
    * The text you type is sent from your computer, over the USB cable
      to the XBee Explorer USB board. From there it is directed to the
      XBee module on the board which sends it wirelessly to the second
      XBee module on the shield. The second XBee module then directs
      the text to the hardware serial port of the Arduino. Your
      Arduino reads each character of the text from the serial port
      and then sends it back (that is, "echos" it) through the serial
      port to the second XBee module. The second XBee module then
      sends the echoed text wirelessly to the first XBee module which
      directs it to the Explorer USB board which sends it back up the
      USB cable to the Arduino IDE serial monitor window. *Phew*.
      
      
  Enhancements:
  
    * You can change the configuration of the XBee wireless modules to
      communicate at a faster speed (try 19200 baud and then 57600
      baud) if you also change the communication speed of the
      "Serial.begin()" line below and in the Serial Monitor window of
      the Arduino IDE to match.


   For more details and help read the XBee Shield and Explorer USB
   Quickstart Guide:
   
      <http://sparkfun.com/tutorials/192>

 */

void setup() {
  Serial.begin(9600); // See "Enhancements" above to learn when to change this.
}

void loop() {
  if (Serial.available()) {
    Serial.print((char) Serial.read());
    delay(10);
  }
}
