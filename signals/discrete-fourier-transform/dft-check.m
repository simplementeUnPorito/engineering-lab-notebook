clear all
close all

N = 100;                    % Número de puntos
t = linspace(0, 2*pi, N);    % Genera 100 puntos desde 0 hasta 2*pi
x = sin(t);                  % Calcula el seno de esos puntos

Xf = dft(x);

figure;

% Primer gráfico: parte real de Xf
subplot(4, 2, 1);
stem(real(Xf),'r');
title('Parte real de Xf (miFuncion)');

% Segundo gráfico: parte imaginaria de Xf
subplot(4, 2, 2);
stem(imag(Xf),'r');
title('Parte imaginaria de Xf (miFuncion)');

% Tercer gráfico: parte real de Xfm (FFT)
subplot(4, 2, 3);
Xfm = fft(x);
stem(real(Xfm));
title('Parte real de Xfm (FFT)');

% Cuarto gráfico: parte imaginaria de Xfm (FFT)
subplot(4, 2, 4);
stem(imag(Xfm));
title('Parte imaginaria de Xfm (FFT)');




