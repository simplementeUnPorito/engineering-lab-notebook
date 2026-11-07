close all
clear all
clc

% ----------- PARÁMETROS GENERALES -----------
T = 2*pi;
w0 = 2*pi/T;
n_list = [1,2,5,7,9];  % lista arbitraria de armónicas deseadas

% ----------- DOMINIO NUMÉRICO -----------
tt = linspace(0, 2*pi, 10000);

% ----------- DEFINICIÓN DE LA FUNCIÓN -----------

% Función numérica (para graficar)
f_vals = zeros(size(tt));
f_vals((tt >= 0) & (tt <= 2*pi/3)) = 1;
f_vals((tt >= pi) & (tt <= 5*pi/3)) = -1;

% Función simbólica (para Fourier)
syms t
f_sym = piecewise((0 <= t) & (t <= 2*pi/3), 1, ...
                  (pi <= t) & (t <= 5*pi/3), -1, ...
                  0);

% ----------- CÁLCULO DE LAS ARMÓNICAS -----------

% ----------- CÁLCULO DE LAS ARMÓNICAS -----------

fN_vals = zeros(size(tt));
A1 = NaN;  % amplitud fundamental

fprintf('\n%-10s %-15s %-20s %-20s %-10s\n', 'n', 'Amplitud A_n', 'Fase (rad)', 'Fase (°)', 'DF(n) %');
fprintf('------------------------------------------------------------------------------------\n');

for idx = 1:length(n_list)
    n = n_list(idx);
    cn = fourier_coeff(f_sym, n, T);
    An = 2 * abs(cn);
    phi_n = angle(cn);
    phi_deg = rad2deg(phi_n);

    if n == 1
        A1 = An;
    end

    if ~isnan(A1)
        DF = (An / (A1 * n^2)) * 100;  % en porcentaje
    else
        DF = NaN;
    end

    fprintf('%-10d %-15.6f %-20.6f %-20.2f %-9.8f%%\n', n, double(An), double(phi_n), double(phi_deg), double(DF));
    
    fN_vals = fN_vals + An * cos(n*w0*tt + phi_n);
end


% ----------- GRÁFICO -----------

figure;
plot(tt, f_vals, 'b', 'LineWidth', 2); hold on;
plot(tt, fN_vals, 'r--', 'LineWidth', 2);
legend('Función original', sprintf('Suma de armónicas: [%s]', num2str(n_list)), 'Interpreter', 'latex');
xlabel('t'); ylabel('f(t)');
title(sprintf('Serie de Fourier con armónicas n = [%s]', num2str(n_list)));
grid on;
