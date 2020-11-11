#include "ThingSpeak.h"
#include <WiFi.h>
#include "secrets.h"
#include <ControlAH.h>
//Arduino pins
int controlPin = 6;
int setpointPin = A1;
int tempPin = A0;

//PI paramters
float Kp = 1.5;//1.46;
float Ti =  15;   //8.85;
float Ts = 0.1;
float Tf = 2.0;

//simulation variables
float setpoint=21.50;
float test_temp = 21.00;
float temp_meas = 0;
float temp_filtered;
float temp_filtered_prev = 21;
float temp_out;
float u_control = 0;

ControlAH ControlAH( Kp, Ti,Ts,Tf);
// WIFI Shield variables
char ssid[] = SECRET_SSID;   // your network SSID (name) 
char pass[] = SECRET_PASS;   // your network password
int keyIndex = 0;            // your network key Index number (needed only for WEP)
WiFiClient  client;

// Thingspeak channel variables
unsigned long myChannelNumber = SECRET_CH_ID;
const char * myWriteAPIKey = SECRET_WRITE_APIKEY;
const char * myReadAPIKey = SECRET_READ_APIKEY;
// Thingspeak fields
int temperature_field = 1;
int setpoint_field = 2;
int kp_field = 3;
int ti_field = 4;


// Timer variables
unsigned long prev_PID;
unsigned long prev_write;
unsigned long prev_read;
int write_interval = 20000; // 20 seconds between each write
int PID_interval = 100; // 100ms between each pid calc
int read_interval = 15000;
void setup() {
  //Initialize serial and wait for port to open:
  Serial.begin(115200);
  pinMode(controlPin, OUTPUT);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo native USB port only
  }

  // check for the presence of the shield:
  if (WiFi.status() == WL_NO_SHIELD) {
    Serial.println("WiFi shield not present");
    // don't continue:
    while (true);
  }

  String fv = WiFi.firmwareVersion();
  if (fv != "1.1.0") {
    Serial.println("Please upgrade the firmware");
  }
    
  ThingSpeak.begin(client);  // Initialize ThingSpeak
  prev_write = millis();
  prev_PID = millis();
  prev_read = millis();
}

void loop() {

 ConnectThingspeak();
 GetPIsettings();
 RunSimulation();
 WriteThingSpeak(temp_filtered); 
}

// Connect or reconnect to WiFi
void ConnectThingspeak() {
  if(WiFi.status() != WL_CONNECTED){
    Serial.print("Attempting to connect to SSID: ");
    Serial.println(SECRET_SSID);
    while(WiFi.status() != WL_CONNECTED){
      WiFi.begin(ssid, pass);
      Serial.print(".");
      delay(5000);     
    } 
    Serial.println("\nConnected.");
  }
}
// Write temperature to thingspeak
void WriteThingSpeak( float temperature)
{
   if (millis()- prev_write > write_interval)
   { 
      //ThingSpeak.setField(1, temperature);
       // Write to ThingSpeak. There are up to 8 fields in a channel, allowing you to store up to 8 different
      // pieces of information in a channel.  Here, we write to field 1.
      //int x = ThingSpeak.setField(myChannelNumber, myWriteAPIKey);
      int x = ThingSpeak.writeField(myChannelNumber, temperature_field, temperature, myWriteAPIKey);
      if(x == 200){
        Serial.println("Channel update successful.");
      }
      else{
        Serial.println("Problem updating channel. HTTP error code " + String(x));
      }
      prev_write = millis();
   }
  
}
void RunSimulation()
{
  if (millis()- prev_PID > PID_interval)
  {
    //Read SetPoint
    //setpoint = ControlAH.GetTemperature(analogRead(setpointPin));
    
    temp_meas = ControlAH.GetTemperature(analogRead(tempPin));
   
    temp_filtered = ControlAH.GetFilteredSignal(temp_meas, temp_filtered_prev);
    u_control = ControlAH.GetControlSignal(setpoint, temp_filtered);
    /*
    Serial.print("setpoint:");
    Serial.print(setpoint);
    Serial.print("\t measured temp");
    Serial.print(temp_meas);
    Serial.print("\t control_signal");
    Serial.print(u_control); 
    Serial.print("\t filtered temp");
    Serial.println(temp_filtered);
    */
    temp_filtered_prev = temp_filtered;
    analogWrite(controlPin,ControlAH.GetPWMSignal(u_control));
    prev_PID = millis();
   }

}
void GetPIsettings()
{
  int statusCode;
  if (millis()- prev_read > read_interval)
  {
    // Read in field 4 of the public channel recording the temperature
    setpoint = ThingSpeak.readFloatField(myChannelNumber, setpoint_field,myReadAPIKey); 
  
    // Check the status of the read operation to see if it was successful
    statusCode = ThingSpeak.getLastReadStatus();
    if(statusCode == 200){
      Serial.println("New setpoint is: " + String(setpoint) + " deg C");
    }
    else{
      Serial.println("Problem reading channel. HTTP error code " + String(statusCode)); 
    }
   
    Kp = ThingSpeak.readFloatField(myChannelNumber, kp_field,myReadAPIKey); 
  
    // Check the status of the read operation to see if it was successful
    statusCode = ThingSpeak.getLastReadStatus();
    if(statusCode == 200){
      Serial.println("New Kp is: " + String(Kp));
    }
    else{
      Serial.println("Problem reading channel. HTTP error code " + String(statusCode)); 
    }
    Ti = ThingSpeak.readFloatField(myChannelNumber, ti_field,myReadAPIKey); 
  
    // Check the status of the read operation to see if it was successful
    statusCode = ThingSpeak.getLastReadStatus();
    if(statusCode == 200){
      Serial.println("New Ti is: " + String(Ti));
    }
    else{
      Serial.println("Problem reading channel. HTTP error code " + String(statusCode)); 
    }
    
    ControlAH.UpdatePIparams(Kp, Ti);
    prev_read = millis();
  }


}
