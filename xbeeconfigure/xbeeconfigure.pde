

import processing.serial.*;

import guicomponents.*;

GCombo cboSerialPort;

GButton btnProgramAsTx;
GButton btnProgramAsRx;

GButton btnProgramDefault;

void setup(){
  size(435, 300);
  
  String[] availablePorts = Serial.list();
  
  
  btnProgramAsTx = new GButton(this, "Configure as Transmitter", 10, 40, 200, 20);

  btnProgramAsRx = new GButton(this, "Configure as Receiver", 220, 40, 200, 20);
  
  btnProgramDefault = new GButton(this, "Reset to Defaults", 105, 80, 200, 20);

  cboSerialPort = new GCombo(this, availablePorts, availablePorts.length, 10, 10, 200);  

}


public void handleComboEvents(GCombo combo){
  if (combo == cboSerialPort) {
    
  }
}

void handleButtonEvents(GButton button) {

  if (button.eventType == GButton.CLICKED) {
    if (button == btnProgramAsTx) {
      configureDevice(cboSerialPort.selectedText(), MODE_TRANSMITTER);
    } else if (button == btnProgramAsRx) {
      configureDevice(cboSerialPort.selectedText(), MODE_RECEIVER);
    } else if (button == btnProgramDefault) {
      configureDevice(cboSerialPort.selectedText(), MODE_DEFAULTS);
    }
  }   
}	

void handleOptionEvents(GOption option1, GOption option2) {
  /* To stop messages about this appearing in the console */
}

void handleSliderEvents(GSlider slider) {
  /* To stop messages about this appearing in the console */
}

void draw(){
  background(200);
}


final int MATCHED = 1;
final int NO_MATCH = 0;
final int TIME_OUT = -1;

int matchResponse(Serial theSerialPort, String matchString) {
  /*
   */

  int TIME_OUT_MS = 2000;
  
  int startTime = millis();

  while (theSerialPort.available() < matchString.length()) {
    /* Wait */ // TODO: Make event driven?
    if (millis() - startTime > TIME_OUT_MS) {
      return TIME_OUT;
    } 
    delay(100);
  }

  if (theSerialPort.readString().equals(matchString)) {
    return MATCHED;
  } 
  
  return NO_MATCH;
} 

final int MODE_BAUD_RATE = -2;
final int MODE_DEFAULTS = -1;
final int MODE_BOTH = 0;
final int MODE_TRANSMITTER = 1;
final int MODE_RECEIVER = 2;


String[] getConfiguration(int modeRequired) {
  /*
   */
   
  if (modeRequired == MODE_DEFAULTS) {
    // This assumes we reset to the defaults before uploading.
    return new String[0];
  }
   
  String[] configuration = loadStrings("configure.txt");
 
  int currentMode = MODE_BOTH;

  for (int idx = 0; idx < configuration.length; idx++) {
    String line = configuration[idx];

    // Skip blank lines
    if (line.length() == 0) {
      continue;  
    }

    switch(line.charAt(0)) {
      case '#':
        // Skip comments
        configuration[idx] = "";
        break;
        
      case '[':
        if (line.equals("[Common]")) {
          currentMode = MODE_BOTH;
        } else if (line.equals("[Transmitter]")) {
          currentMode = MODE_TRANSMITTER;
        } else if (line.equals("[Receiver]")) {
          currentMode = MODE_RECEIVER;
        } else {
          // Ignore everything else
        }
        configuration[idx] = "";
        break;
      
      default:
        if (!(currentMode == MODE_BOTH || currentMode == modeRequired)) {
          configuration[idx] = "";
        }
        break;
    }
  }
  
  // TODO: Return array with (now) blank lines removed?
  return configuration;
}


boolean sendCommand(Serial theSerialPort, String theCommand) {
  /*

     theCommand -- this is the command without the "AT" prefix. 
  
   */
  String commandToSend = "AT" + theCommand + "\r";
  
  theSerialPort.write(commandToSend);
  println(commandToSend);
    
  return (matchResponse(theSerialPort, "OK\r") == MATCHED);
}


boolean uploadConfiguration(Serial theSerialPort, String[] theConfiguration) {
  /*
   */
  
  for (int idx = 0; idx < theConfiguration.length; idx++) {
    String line = theConfiguration[idx];

    // Skip blank lines
    if (line.length() == 0) {
      continue;
    }
    
    if (!sendCommand(theSerialPort, line)) {
      return false;
    }
  }
  
  return true;
}


void exitCommandMode(Serial theSerialPort) {
  /*
   */
  
  // We ignore the response
  // TODO: Reboot instead if baud rate change doesn't stick?
  sendCommand(theSerialPort, "CN"); // Exit command mode.    
}


boolean enterCommandMode(Serial theSerialPort) {
  /*
   */
  
  theSerialPort.write("+++");

  return (matchResponse(theSerialPort, "OK\r") == MATCHED);
}


Serial openWithBaudRateDetect(String theSerialPortName) {
  /*
   */
  
  int[] baudRatesToDetect = {9600, 19200, 57600, 38400, 115200, 4800, 2400, 1200};

  for (int idx = 0; idx < baudRatesToDetect.length; idx++) {
    int baudRate = baudRatesToDetect[idx];
    
    Serial serialPort = new Serial(this, theSerialPortName, baudRate);
    
    if (enterCommandMode(serialPort)) {
      exitCommandMode(serialPort);
      delay(2000); // Guard delay
      return serialPort;
    } else {
      serialPort.stop();
    }
  }

  return null;  
}


void configureDevice(String serialPortName, int functionalityMode) {
  Serial serialPort;

  println(serialPortName);

  String[] configuration = getConfiguration(functionalityMode);

  
  serialPort = openWithBaudRateDetect(serialPortName);
  
  if (serialPort == null) {
    println("Could not enter command mode. (Incorrect response or no response.)");
    return;
  }

  // TODO: Detect when serial port doesn't exist.
  
  if (enterCommandMode(serialPort)) {

    if (sendCommand(serialPort, "RE")) { // Reset to defaults

      if (uploadConfiguration(serialPort, configuration)) {

        if (!sendCommand(serialPort, "WR")) { // Write changes to storage
          println("Saving configuration failed. (Incorrect response or no response.)");
        }
        
      } else {
        println("Configuration failed. (Incorrect response or no response.)");
        // TODO: Do something else here?
      }
      
    } else {
      println("Reset to defaults failed. (Incorrect response or no response.)");
    }
    
  } else {
    println("Could not enter command mode. (Incorrect response or no response.)");    
  }
  
  // TODO: Make sure we always exit command mode?
  exitCommandMode(serialPort);    
  
  serialPort.stop();
  
  println("Done.");
}

