close all
clear all
clc

% ----------- PARÁMETROS GENERALES -----------
T = 2*pi;
w0 = 2*pi/T;
n_list = 1:11;  % Armónicas de 1 a 11 para THD

% ----------- DOMINIO NUMÉRICO -----------
tt = linspace(0, 2*pi, 10000);

% ----------- DEFINICIÓN DE LA FUNCIÓN -----------

% Numérica para graficar
f_vals = zeros(size(tt));
f_vals((tt > 0)        & (tt <= pi/3))     = 1/3;
f_vals((tt > pi/3)     & (tt <= 2*pi/3))   = 2/3;
f_vals((tt > 2*pi/3)   & (tt <= pi))       = 1/3;
f_vals((tt > pi)       & (tt <= 4*pi/3))   = -1/3;
f_vals((tt > 4*pi/3)   & (tt <= 5*pi/3))   = -2/3;
f_vals((tt > 5*pi/3)   & (tt <= 2*pi))     = -1/3;

% Simbólica para Fourier
syms t n
f_sym = piecewise(...
    (0 < t)        & (t <= pi/3),     1/3, ...
    (pi/3 < t)     & (t <= 2*pi/3),   2/3, ...
    (2*pi/3 < t)   & (t <= pi),       1/3, ...
    (pi < t)       & (t <= 4*pi/3),  -1/3, ...
    (4*pi/3 < t)   & (t <= 5*pi/3),  -2/3, ...
    (5*pi/3 < t)   & (t <= 2*pi),    -1/3, ...
    0);

% ----------- CÁLCULO DE LAS ARMÓNICAS -----------
fN_vals = zeros(size(tt));
A1 = NaN;
An_list = zeros(1, length(n_list));  % para THD

fprintf('\n%-5s %-15s %-20s %-20s %-10s\n', 'n', 'Amplitud A_n', 'Fase (rad)', 'Fase (°)', 'DF(n) %');
fprintf('------------------------------------------------------------------------------------\n');

for idx = 1:length(n_list)
    n_val = n_list(idx);
    cn = fourier_coeff(f_sym, n_val, T);  % valor numérico
    An =  abs(cn);
    phi_n = angle(cn);
    phi_deg = rad2deg(phi_n);
    An_list(idx) = An;

    % Calcular A1 para DF
    if n_val == 1
        A1 = An;
    end

    if ~isnan(A1)
        DF = (An / (A1 * n_val^2)) * 100;
    else
        DF = NaN;
    end
    % Comparar con tu fórmula analítica
    c_teorico = ((1 - (-1)^n_val) * ...
             (2 + cos(n_val*pi/3) - cos(2*n_val*pi/3) + ...
              1j*(sin(2*n_val*pi/3) - sin(n_val*pi/3)))) ...
             / (6*pi*1j*n_val);


    A_teorico = abs(c_teorico);
    phi_teorico = angle(c_teorico);
    phi_teorico_deg = rad2deg(phi_teorico);

    err_abs = abs(cn - c_teorico);
    err_rel = err_abs / abs(cn);

    % Mostrar resultados
    fprintf('%-5d %-15.6f %-20.6f %-20.2f %-9.6f%%\n', ...
        n_val, double(An), double(phi_n), double(phi_deg), double(DF));
    
    fprintf('      c_n teórico    = %.6e + %.6ei\n', real(c_teorico), imag(c_teorico));
    fprintf('      |c_n| teorico  = %.6f\n', abs(c_teorico));
    fprintf('      ∠c_n teórico   = %.6f rad (%.2f°)\n', phi_teorico, phi_teorico_deg);
    fprintf('      -> Error abs: %.2e   Rel: %.2e\n\n', double(err_abs), double(err_rel));

    % Suma de armónicas
    fN_vals = fN_vals + 2*An * cos(n_val*w0*tt + phi_n);
end

% ----------- CÁLCULO THD -----------
if ~isnan(A1)
    THD = sqrt(sum(An_list(2:end).^2)) / A1;
    fprintf('\nTHD (hasta la armónica 11) = %.4f (%.2f%%)\n', THD, 100*THD);
end

% ----------- GRÁFICO -----------
figure;
plot(tt, f_vals, 'b', 'LineWidth', 2); hold on;
plot(tt, fN_vals, 'r--', 'LineWidth', 2);
legend('Función original', 'Aproximación (n = 1 a 11)', 'Interpreter', 'latex');
xlabel('t'); ylabel('f(t)');
title('Serie de Fourier vs señal original (n = 1 a 11)');
grid on;
