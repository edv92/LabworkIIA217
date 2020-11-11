/*
 ControlAH.h - Library for different functions used to control the air heater
 unit at USN.
 It contains three functions, a PI controller, a lowpass filter and a signal converter
 to get "analog" 0-5V out through the PWM.
 Created by Edvard Nordvk
 Free to use
 */

 #ifndef CONTROLAH_H
 #define CONTROLAH_H

#include <Arduino.h>

class ControlAH {

  private:

  //PI controller private variables
  float Kp;
  float Ti;
  float Ts;
  float Tf;
  public:
  //PI controller public variables
  float e_prev =0;
  float u_prev = 0;
  // initialization function
  ControlAH(float Kp, float Ti, float Ts, float Tf);

  //PI controller function, takes setpoint and previous signal
  float GetControlSignal(float setPoint, float y_prev);
  
  // Lowpass filter function
  float GetFilteredSignal(float u_signal, float y_prev);

  //transform voltage out signal
  //Get the arduino analogwrite pwm signal from given voltage signal
  int GetPWMSignal(float u_signal);

  //Converts the (204-1023) analog read signal
  //to a Temperature value (20-50 degrees Celsius)
  float GetTemperature(int analogReadSignal);

  void UpdatePIparams(float Kp, float Ti);
  
};

 #endif
