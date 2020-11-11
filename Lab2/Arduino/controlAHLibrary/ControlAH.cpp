/*
 ControlAH.cpp - Library for different functions used to control the air heater
 unit at USN.
 It contains three functions, a PI controller, a lowpass filter and a signal converter
 to get "analog" 0-5V out through the PWM.
 Created by Edvard Nordvk
 Free to use
 */
 #include "ControlAH.h"
 
 //Initialize the PI settings(Kp & Ti) and timestep(Ts)[s]
 //and filter time constant Tf
 ControlAH::ControlAH(float Kp, float Ti, float Ts,float Tf)
 {
  this->Kp = Kp;
  this->Ti = Ti;
  this->Ts = Ts;
  this->Tf = Tf;
 }

// Get new control signal from PI controller
float ControlAH::GetControlSignal(float setPoint, float y_prev)
{
  float u_delta;
  float u;
  float e;
  
  e= setPoint-y_prev;
  u_delta =Kp*(e-e_prev)+((Kp*Ts)/Ti)*e;
  u = u_prev+u_delta;
  
  //anti windup
  if(u>5)
  {
    u=5;   
  }
  if(u<0)
  {
    u = 0;
  }
  e_prev = e;
  u_prev = u;
  return u;
}
// Lowpass filter, takes inn vo
float ControlAH::GetFilteredSignal(float u_signal, float y_prev)
{
  
  float alfa;
  float y_filtered;
  alfa = Ts/(Tf+Ts);
  y_filtered = (1-alfa)*y_prev+alfa*u_signal;
  return y_filtered;
}

//Converts the given voltage signal (0-5V) to a pwm signal value (0-255)
int ControlAH::GetPWMSignal(float u_signal)
{
  return u_signal*51;
}

//Converts the (204-1023) analog read signal
//to a Temperature value (20-50 degrees Celsius)
float ControlAH::GetTemperature(int analogReadSignal)
{
  //return ((50/(1023-204.6))*(analogReadSignal-204.6));
  return(20+(30/(1023-204.6))*(analogReadSignal-204.6));
}

// Set Kp and Ti
void ControlAH::UpdatePIparams(float Kp, float Ti)
{
  this->Kp = Kp;
  this->Ti = Ti;
}

 
