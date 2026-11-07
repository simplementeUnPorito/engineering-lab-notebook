close all;
clear all;

% Definir parámetros
w0 = 0.3 * pi; % Frecuencia central
Q = 1/sqrt(2); % Factor de calidad
BW =  w0/Q; % Ancho de banda

% Coeficiente b
b = cos(w0);

% Resolver la ecuación cuadrática para a
A = cos(BW);
B_coef = -2;
C = cos(BW);

a1 = (-B_coef + sqrt(B_coef^2 - 4 * A * C)) / (2 * A);
a2 = (-B_coef - sqrt(B_coef^2 - 4 * A * C)) / (2 * A);

% Definir los coeficientes del filtro H_HP(z) para a1 y a2
r1 = sqrt(a1); % Para la primera solución de a
r2 = sqrt(a2); % Para la segunda solución de a

theta1 = acos(b * (1 + a1) / (2 * sqrt(a1))); % ángulo theta para a1
theta2 = acos(b * (1 + a2) / (2 * sqrt(a2))); % ángulo theta para a2

% Calcular K1 y K2 para normalizar la ganancia a 1
K1 = abs(-2 + 2 * cos(pi)) / sqrt((-2 * r1 * cos(theta1) + (1 + r1^2) * cos(pi))^2 + ((1 - r1^2) * sin(pi))^2);
K1 = 1 / K1;
K2 = abs(-2 + 2 * cos(pi)) / sqrt((-2 * r2 * cos(theta2) + (1 + r2^2) * cos(pi))^2 + ((1 - r2^2) * sin(pi))^2);
K2 = 1 / K2;

% Polinomios en Z para a1 y a2 (filtro pasa alto)
z = tf('z', -1);
H_HP_a1 = K1 * (1 - z^-1)^2 / (1 - 2 * r1 * cos(theta1) * z^-1 + r1^2 * z^-2);
H_HP_a2 = K2 * (1 - z^-1)^2 / (1 - 2 * r2 * cos(theta2) * z^-1 + r2^2 * z^-2);

% Crear subplots

% Gráfico 1: Magnitud de la respuesta en frecuencia para a1 y a2
figure;
subplot(2, 2, 1);
[H1, w1] = freqz(cell2mat(H_HP_a1.Numerator), cell2mat(H_HP_a1.Denominator), 1024);
plot(w1/pi, abs(H1));
title('Respuesta en Frecuencia (a1)');
xlabel('Frecuencia Normalizada (\omega/\pi)');
ylabel('Magnitud (dB)');

subplot(2, 2, 2);
[H2, w2] = freqz(cell2mat(H_HP_a2.Numerator), cell2mat(H_HP_a2.Denominator), 1024);
plot(w2/pi,abs(abs(H2)));
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

% Obtener polos y ceros para H_HP_a1 y H_HP_a2
zeros_a1 = roots(H_HP_a1.Numerator{1});
poles_a1 = roots(H_HP_a1.Denominator{1});

zeros_a2 = roots(H_HP_a2.Numerator{1});
poles_a2 = roots(H_HP_a2.Denominator{1});

% Graficar polos y ceros con círculo unitario
subplot(2, 2, 1);
theta = linspace(0, 2*pi, 100);
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

h_a1 = filter(cell2mat(H_HP_a1.Numerator), cell2mat(H_HP_a1.Denominator), imp);
h_a2 = filter(cell2mat(H_HP_a2.Numerator), cell2mat(H_HP_a2.Denominator), imp);

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

% Mostrar los valores de K1 y K2
disp(['Valor de K1: ', num2str(K1)]);
disp(['Valor de K2: ', num2str(K2)]);
H_HP_a1
H_HP_a2
Coeficientes_n = H_HP_a2.Numerator{1,1}./H_HP_a2.Numerator{1,1}(1);
Coeficientes_d = H_HP_a2.Denominator{1,1}./H_HP_a2.Numerator{1,1}(1);
