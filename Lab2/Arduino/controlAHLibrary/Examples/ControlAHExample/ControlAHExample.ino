#include <ControlAH.h>
// This example shows how the different functions in the controlAH library works
//PI paramters
float Kp = 1.5; //proportional gain
float Ti =  15; // integral time constant  
float Ts = 0.1; // discrete timestep[s]
float Tf = 2.0; // lowpass filter timeconstant

//simulation variables
float setpoint=28.50;
float voltage_measured = 2.2;
float temp_measured = 0;
float temp_filtered = 0;;
float temp_filtered_prev = 21;
float pwm_signal = 0;
float u_control = 0;

// initialise settings for PI controller and lowpass filter
ControlAH ControlAH( Kp, Ti,Ts,Tf);
void setup() {
  Serial.begin(9600);


}

void loop() {
  // Transfer read voltage(0-1024) to a temperature
  temp_measured = ControlAH.GetTemperature(voltage_measured);
  Serial.println("temperature measured is: "+ String(temp_measured) + "from the read voltage: "+String(voltage_measured));
  
  // Get filtered temperature  
  temp_filtered = ControlAH.GetFilteredSignal(temp_measured, temp_filtered_prev);
  temp_filtered_prev = temp_filtered;
  Serial.println("Filtered temperature is: "+String(temp_filtered));
  
  // get control signal from PI controller
  u_control =ControlAH.GetControlSignal(setpoint,temp_filtered);
  Serial.println("New control signal from PI controller is:"+ String(u_control));

  // Get pwm signal corresponding to the given  voltage(0-255):
  pwm_signal = ControlAH.GetPWMSignal(u_control);
  Serial.println("New PWM signal is"+ String(pwm_signal));
 
  delay(10000);

}
