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
%stable skogestad 1.46  critical 4.1654  unstable 10
Kp_s = 1.46
Kp_m = 4.16561
Kp_us = 10
% 4.1654  %1.46+2.7054341

Ti = 8.85; 
num_c_s = [Kp_s*Ti Kp_s];
num_c_m = [Kp_m*Ti Kp_m];
num_c_us = [Kp_us*Ti Kp_us];
den_c = [Ti 0];
Hc_s = tf(num_c_s, den_c)
Hc_m =tf(num_c_m, den_c)
Hc_us = tf(num_c_us, den_c)

Tf = 2;
num_f = 1;
den_f = [Tf 1];
Hm = tf(num_f, den_f)
L_s = series(Hc_s, Hp)
L_m = series(Hc_m, Hp)
L_us= series(Hc_us, Hp)

T_s = feedback(L_s,1);
T_m = feedback(L_m,1);
T_us = feedback(L_us,1);
T_pade_s = pade(T_s,4);
T_pade_m = pade(T_m,4);
T_pade_us = pade(T_us,4);

S_s = 1-T_pade_s;
S_m = 1-T_pade_m;
S_us = 1-T_pade_us;

[gm_s, pm_s] = margin(L_s)
[gm_m, pm_m] = margin(L_m)
[gm_us, pm_us] = margin(L_us)

 figure(1)
margin(L_s)
% 
% figure(2)
% margin(L_m)
% 
% figure(3)
% margin(L_us)

%bode(T)

%bode(S)

% 
% figure
% subplot(3,1,1)
% step(T_pade_s)
% legend('stable system')
% subplot(3,1,2)
% step(T_pade_m,400)
% legend('marginally stable system')
% subplot(3,1,3)
% step(T_pade_us)
% legend('unstable system')
% %sysr= minreal(T);
figure
pzmap(T_pade_s)
hold on
pzmap(T_pade_m)
hold on
pzmap(T_pade_us)
legend('stable', 'marginally stable', 'unstable')
