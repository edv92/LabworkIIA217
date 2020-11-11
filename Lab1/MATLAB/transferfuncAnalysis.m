%% Air heater system analysis
clc
clear
close all
K= 2.2;
Td = 2.95;
Tk = 19;
T_env = 24;
w = [0.001 0.01 0.1 1 3 5 10];

num = K;
den = [Tk 1];
S= tf(num,den,'InputDelay', Td)

A = @(x) K/(sqrt(1+(Tk*x)^(2)));
pfi =@(x) -atan(Tk*x)-Td*x;

amp = zeros(1,7);
ang_rad = zeros(1,7)
ang_deg = zeros(1,7)
for i=1:7
amp(i) = 20*log10(A(w(i)))
ang_rad(i) = pfi(w(i))
ang_deg(i) = ang_rad(i)*180/pi
end

[mag, fas, wout] = bode(S, logspace(-3 ,1,100))
magv = []
fasv = []

for i=1:100
magv= [magv 20*log10(mag(1,1,i))];
fasv = [fasv fas(1,1,i)];

end
magv= magv';
fasv = fasv';

figure(2)
title('bode plot')
subplot(2,1,1)

semilogx(wout,magv)
hold on
semilogx(w',amp','*');
legend( 'bode-function', 'calculated points');
ylabel('Magnitude[dB]');
xlabel('Frequency[rad/s]');

subplot(2,1,2)
semilogx(wout,fasv);
hold on
semilogx(w',ang_deg','*');
legend( 'bode-function', 'calculated points');
ylabel('Phase angle[rad]');
xlabel('Frequency[rad/s]');
figure(3)
step(S)
