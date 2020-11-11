#include <ControlAH.h>
//Arduino pins
int controlPin = 6;
int setpointPin = A1;
int tempPin = A0;

//PI paramters
double Kp = 1.5;//1.46;
double Ti =  15;   //8.85;
double Ts = 0.1;
double Tf = 2.0;

//simulation variables
double setpoint=21.50;
double test_temp = 21.00;
double temp_meas = 0;
double temp_filtered;
double temp_filtered_prev = 21;
double temp_out;
double u_control = 0;


ControlAH ControlAH( Kp, Ti,Ts,Tf);
void setup() {
  Serial.begin(9600);
  pinMode(controlPin, OUTPUT);

}

void loop() {
  //u_control =ControlAH.GetControlSignal(setpoint,test_temp);
  //u_control = ControlAH.GetPWMSignal(2.37);
  //analogWrite(controlPin,ControlAH.GetPWMSignal(2.37));
  //Serial.println(u_control);
  //Serial.println(ControlAH.
  RunSimulation();
  delay(100);

}

void RunSimulation()
{
  //Read SetPoint
  setpoint = ControlAH.GetTemperature(analogRead(setpointPin));
  
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

}


  
