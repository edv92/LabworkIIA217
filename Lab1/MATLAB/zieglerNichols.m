%% Ziegler Nichols 
%% Stability analysis
clc
clear
close all


K= 2.2;
Td = 2.95;
Tk = 19;
T_env = 24;

num_p = K;
den_p = [Tk 1];
Hp = tf(num_p,den_p,'InputDelay', Td)

%num_p = [(-K*(Td)^(3)/6) (K*(Td)^(2))/2 -K*Td K+1]
%den_p = [Tk 1];
%Hp = tf(num_p,den_p)
%stable 1.46  critical 4.1654  unstable 10
Kp = 4.892  % 4.1654  %1.46+2.7054341

Ti = 8.85;
num_c = [Kp*Ti Kp];
den_c = [Ti 0];
Hc = tf(num_c, den_c)

Tf = 2;
num_f = 1;
den_f = [Tf 1];
Hm = tf(num_f, den_f)
L = series(Kp, Hp)

T = feedback(L,1)
T_pade = pade(T,4);
S = 1-T

[gm, pm] = margin(L)
figure
margin(L)
hold on
bode(T)
hold on
bode(S)
hold off
figure(2)

step(T)
