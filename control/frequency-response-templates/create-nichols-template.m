clear all
close all
clc

% Crear la función de transferencia
H = tf(1, 1);

% Configuración de la frecuencia
w = logspace(-1, 3, 100); % Rango de frecuencia de 0.1 a 1000

% Graficar Nichols
figure;
nichols(H, w);

% Configuración del gráfico
grid on; 
grid minor;
xlim([-360, 0]);  % Rango de fase en grados
ylim([-40, 40]);  % Rango de magnitud en dB
xlabel('Fase (°)');
ylabel('Magnitud (dB)');
title('Carta de Nichols');

% Personalización de las propiedades del grid
ax = gca; % Obtener el objeto de ejes
ax.GridColor = [0 0 0]; % Color del grid principal (negro)
ax.MinorGridColor = [0 0 0]; % Color del grid menor (negro)
ax.GridAlpha = 1; % Transparencia del grid principal
ax.MinorGridAlpha = 1; % Transparencia del grid menor

ax.XMinorGrid = 'on';
ax.YMinorGrid = 'on';
