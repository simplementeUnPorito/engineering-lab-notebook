close all
clear all
clc

% Definición de la función de transferencia
k = 2376; % Ganancia
Gp = tf([3], [1, 14, 60, 72]); % Gp(s)
H = tf(1, 1); % H(s)
GHp = Gp * H;

% Cálculo de Mp
Mp = k*Gp / (1 + k*GHp);

% Diagrama de Bode asintótico
figure;
% Bode para el lazo cerrado, se hace con M, pero por problemas de redondeo hacemos el calculo a
% mano para que asymptotic_bode se porte bien
Mp1 = tf([3*k],[1,14,60,72+3*k]);
asymptotic_bode(Mp1);
figure;
bode(Mp1);
% Lugar de raíces
figure;
%Hacemos con GH sin k puesto que este varia K
rlocus(GHp,-50:0.01:300);
title('Lugar de Raíces');
xlabel('Eje Real');
ylabel('Eje Imaginario');
grid on;

% Diagrama de Nyquist
figure;
% Nyquist se hace con GH, sin multiplicar por k, ya que buscamos el valor
% de k que cumpla ciertas condiciones
nyqlog(GHp);
title('Diagrama de Nyquist');
xlabel('Eje Real');
ylabel('Eje Imaginario');
grid on;

% Diagrama de Nichols
figure;
% Nichols se calcula para kG, y para el calculo a mano, se calcula mediante
% el bode de kG
asymptotic_bode(k*Gp);
figure;
nichols(k*Gp);
title('Diagrama de Nichols');
ylabel('Magnitud (dB)');
xlabel('Fase (grados)');
grid on; % Activa la grilla

% Respuesta al escalón
figure;
step(Mp);
title('Respuesta al Escalón');
xlabel('Tiempo');
ylabel('Amplitud');
grid on;
figure;
step(Mp,2);
title('Respuesta al Escalón');
xlabel('Tiempo');
ylabel('Amplitud');
grid on;