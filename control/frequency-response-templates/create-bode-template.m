close all
clear all
clc

% Crear la función de transferencia
H = tf(1, 1);

% Configuración de la frecuencia
w = logspace(-3, 3, 100); % Rango de frecuencia de 0.1 a 1000

% Graficar Bode
figure;
[mag, phase, wout] = bode(H, w);
mag = squeeze(20*log10(mag)); % Convertir magnitud a dB
phase = squeeze(phase); % Convertir la fase a un vector

% Crear el subplot para la magnitud
subplot(2, 1, 1);
semilogx(wout, mag, 'black', 'LineWidth', 1.5);
grid on; grid minor;
xlim([0.001, 100]);
ylim([-120, 80]);
xlabel('Frecuencia (rad/s)');
ylabel('Magnitud (dB)');
title('Bode - Magnitud');

% Personalización de las propiedades del grid
ax = gca; % Obtener el objeto de ejes
ax.GridColor = [0 0 0]; % Color del grid principal (negro)
ax.MinorGridColor = [0 0 0]; % Color del grid menor (negro)
ax.GridAlpha = 1; % Transparencia del grid principal
ax.MinorGridAlpha = 1; % Transparencia del grid menor

ax.XMinorGrid = 'on';
ax.YMinorGrid = 'on';


% Crear el subplot para la fase
subplot(2, 1, 2);
semilogx(wout, phase, 'black', 'LineWidth', 1.5);
grid on; grid minor;
xlim([0.001, 100]);
ylim([-300, -90]);
xlabel('Frecuencia (rad/s)');
ylabel('Fase (°)');
title('Bode - Fase');

% Personalización de las propiedades del grid
ax = gca; % Obtener el objeto de ejes
ax.GridColor = [0 0 0]; % Color del grid principal (negro)
ax.MinorGridColor = [0 0 0]; % Color del grid menor (negro)
ax.GridAlpha = 1; % Transparencia del grid principal
ax.MinorGridAlpha = 1; % Transparencia del grid menor

ax.XMinorGrid = 'on';
ax.YMinorGrid = 'on';
