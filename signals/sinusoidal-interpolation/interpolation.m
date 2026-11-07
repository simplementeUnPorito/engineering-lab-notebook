% Datos iniciales
x = linspace(0, 2*pi, 50);         % Puntos en el eje x
y = 3*sin(2*x + pi/4) + 0.5;       % Generar datos senoidales con ruido
y = y + 0.3*randn(size(y));        % Añadir ruido

% Definir funlist con coseno y seno que incluyen desfases
funlist = {
    1, ...                                % Término constante (desplazamiento)
    @(coef, xdata) cos(coef(1) * xdata + coef(2)), ... % Coseno con desfase
    @(coef, xdata) sin(coef(1) * xdata + coef(3))      % Seno con desfase
};

% Valores iniciales para parámetros [frecuencia angular, desfase coseno, desfase seno]
Bstart = [2, 0, 0]; % [frecuencia angular, desfase coseno, desfase seno]

% Llamada a fminspleas
[INLP, ILP] = fminspleas(funlist, Bstart, x, y);

% Extraer parámetros ajustados
D = ILP(1);                        % Desplazamiento
C_cos = INLP(2);                   % Desfase del coseno
C_sin = INLP(3);                   % Desfase del seno
A_cos = ILP(2);                    % Amplitud del coseno
A_sin = ILP(3);                    % Amplitud del seno

% Calcular parámetros equivalentes de la función senoidal general
A = sqrt(A_cos^2 + A_sin^2);       % Amplitud combinada
C = atan2(A_sin, A_cos);           % Fase combinada
B = INLP(1);                       % Frecuencia angular

% Curva ajustada
x_fit = linspace(min(x), max(x), 1000);
y_fit = D + A * sin(B * x_fit + C);

% Ploteo de resultados
figure;
plot(x, y, 'ro', 'MarkerSize', 8, 'DisplayName', 'Datos originales'); % Puntos originales
hold on;
plot(x_fit, y_fit, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Ajuste senoidal'); % Ajuste
title('Ajuste senoidal con desfases usando fminspleas');
xlabel('X');
ylabel('Y');
legend('show');
grid on;
hold off;

% Mostrar parámetros ajustados
fprintf('Resultados del ajuste:\n');
fprintf('Amplitud combinada (A): %.4f\n', A);
fprintf('Frecuencia angular (B): %.4f\n', B);
fprintf('Fase combinada (C): %.4f rad (%.4f grados)\n', C, rad2deg(C));
fprintf('Desplazamiento (D): %.4f\n', D);
fprintf('Amplitud coseno (A_cos): %.4f\n', A
