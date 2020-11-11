%% Airheater frequency response analysis

% Parameters
K = 2.2;
T_d = 2.95;
T_k = 19;
T_env = 0;

%transfer function
num1 = [K];
den1 = [T_k 1];



H1 = tf(num1, den1, 'InputDelay', T_d)
%[RE, IM] = nyquist(H1);
H = H1;

step(H)

bode(H)
w = 10;
H_t = K/(1i*T_k*w+1)

H_t_r = real(H_t)
H_t_i = imag(H_t)

pfi = atan(H_t_i/H_t_r)-3*w
%a = a .* (a >= 0) + (a + 2 * pi) .* (a < 0);
pfi_ang = pfi*(180/pi)

