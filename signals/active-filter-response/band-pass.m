close all;
clear all;

% Definir parámetros
w0 = 0.3 * pi; % Frecuencia central
Q = 4; % Factor de calidad
BW = w0/Q; % Ancho de banda

% Coeficiente b
b = cos(w0);

% Resolver la ecuación cuadrática para a
A = cos(BW);
B_coef = -2;
C = cos(BW);

a1 = (-B_coef + sqrt(B_coef^2 - 4*A*C)) / (2*A);
a2 = (-B_coef - sqrt(B_coef^2 - 4*A*C)) / (2*A);

K1 = (1 - a1) / 2;
K2 = (1 - a2) / 2;

% Definir los coeficientes del filtro H_BP(z) para a1 y a2
r1 = sqrt(a1); % Para la primera solución de a
r2 = sqrt(a2); % Para la segunda solución de a

theta1 = acos(b * (1 + a1) / (2 * sqrt(a1))); % ángulo theta para a1
theta2 = acos(b * (1 + a2) / (2 * sqrt(a2))); % ángulo theta para a2

% Polinomios en Z para a1 y a2
z = tf('z', -1);
H_BP_a1 = (1 - a1) / 2 * (1 - z^-2) / (1 - 2 * r1 * cos(theta1) * z^-1 + r1^2 * z^-2);
H_BP_a2 = (1 - a2) / 2 * (1 - z^-2) / (1 - 2 * r2 * cos(theta2) * z^-1 + r2^2 * z^-2);

% Crear subplots

% Gráfico 1: Magnitud de la respuesta en frecuencia para a1 y a2
figure;
subplot(2, 2, 1);
[H1, w1] = freqz(H_BP_a1.Numerator{1}, H_BP_a1.Denominator{1}, 1024);
plot(w1/pi, abs(H1));
title('Respuesta en Frecuencia (a1)');
xlabel('Frecuencia Normalizada (\omega/\pi)');
ylabel('Magnitud (dB)');

subplot(2, 2, 2);
[H2, w2] = freqz(H_BP_a2.Numerator{1}, H_BP_a2.Denominator{1}, 1024);
plot(w2/pi, abs(H2));
title('Respuesta en Frecuencia (a2)');
xlabel('Frecuencia Normalizada (\omega/\pi)');
ylabel('Magnitud (dB)');

% Gráfico 2: Respuesta en fase para a1 y a2
subplot(2, 2, 3);
plot(w1/pi, angle(H1));
title('Respuesta en Fase (a1)');
xlabel('Frecuencia Normalizada (\omega/\pi)');
ylabel('Fase (radianes)');

subplot(2, 2, 4);
plot(w2/pi, angle(H2));
title('Respuesta en Fase (a2)');
xlabel('Frecuencia Normalizada (\omega/\pi)');
ylabel('Fase (radianes)');

% Segundo conjunto de subplots para el plano Z y la respuesta al impulso
figure;

% Obtener polos y ceros para H_BP_a1 y H_BP_a2
zeros_a1 = roots(H_BP_a1.Numerator{1});
poles_a1 = roots(H_BP_a1.Denominator{1});

zeros_a2 = roots(H_BP_a2.Numerator{1});
poles_a2 = roots(H_BP_a2.Denominator{1});

% Graficar polos y ceros con círculo unitario
theta = linspace(0, 2*pi, 100); % Para el círculo unitario

subplot(2, 2, 1);
plot(cos(theta), sin(theta), '--'); % Círculo unitario
hold on;
plot(real(zeros_a1), imag(zeros_a1), 'bo'); % Ceros en azul
plot(real(poles_a1), imag(poles_a1), 'rx'); % Polos en rojo
title('Plano Z (a1)');
xlabel('Real');
ylabel('Imaginario');
axis equal;
grid on;
hold off;

subplot(2, 2, 2);
plot(cos(theta), sin(theta), '--'); % Círculo unitario
hold on;
plot(real(zeros_a2), imag(zeros_a2), 'bo'); % Ceros en azul
plot(real(poles_a2), imag(poles_a2), 'rx'); % Polos en rojo
title('Plano Z (a2)');
xlabel('Real');
ylabel('Imaginario');
axis equal;
grid on;
hold off;

% Respuesta al impulso para a1 y a2
n = 0:50;
imp = (n == 0); % Entrada delta

h_a1 = filter(H_BP_a1.Numerator{1}, H_BP_a1.Denominator{1}, imp);
h_a2 = filter(H_BP_a2.Numerator{1}, H_BP_a2.Denominator{1}, imp);

subplot(2, 2, 3);
stem(n, h_a1);
title('Respuesta al Impulso (a1)');
xlabel('n (muestras)');
ylabel('Amplitud');

subplot(2, 2, 4);
stem(n, h_a2);
title('Respuesta al Impulso (a2)');
xlabel('n (muestras)');
ylabel('Amplitud');

% Mostrar los valores de H1 y H2
H_BP_a1
H_BP_a2
Coeficientes_n = H_BP_a2.Numerator{1,1};
Coeficientes_d = H_BP_a2.Denominator{1,1};