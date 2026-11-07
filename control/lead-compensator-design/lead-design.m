close all
clear all
clc

% Definición de la función de transferencia
k = 2376; % Ganancia
Gp = tf([3], [1, 14, 60, 72]); % Gp(s)
H = tf(1, 1); % H(s)

e = [5, 50, 10, 40, 15, 30, 20]; % Valores para ajuste de fase adicional

% Inicializar figuras
figure(1);
grid on;
hold on;
title('Diagramas de Margen de Ganancia y Fase');
xlabel('Frecuencia (rad/s)');
ylabel('Magnitud (dB) / Fase (grados)');

figure(2);
grid on;
hold on;
title('Respuestas Escalón');
xlabel('Tiempo (s)');
ylabel('Salida');

legend_margin = {}; % Inicializar celdas para la leyenda del margen
legend_step = {}; % Inicializar celdas para la leyenda de la respuesta escalón

figure;
asymptotic_bode(k*H*Gp);

for i = 1:length(e)
    ad = 40 + e(i); % Ajuste de fase
    phid = (pi * ad) / 180; % Fase deseada en radianes
    a = (sin(phid) + 1) / (1 - sin(phid)); % Factor 'a'
    disp(['-10log(a) = ' num2str(-10*log10(a))]);

    wm = input('Ingrese la frecuencia a la que se tiene esa atenuacion: '); % Frecuencia de cruce
    T = 1 / (sqrt(a) * wm); % Constante de tiempo T
    aT = a * T; % Producto a*T
    Gc = (1/a) * tf([aT, 1], [T, 1]); % Compensador
    
    % Ganancias en lazo abierto
    G = a*k * Gc * Gp; % Sistema compensado
    GH = G * H; % Ganancia en lazo abierto compensado

    % Sistema en lazo cerrado
    M = G/(1+GH); % Sistema compensado en lazo cerrado

    % Dibujar márgenes en figura 1
    figure(1);
    if(i~=length(e))
        bode(GH);
    else
        
        hold on;
        margin(GH);
    end
    legend_margin{end + 1} = ['e = ', num2str(e(i))]; % Añadir etiqueta a la leyenda

    % Dibujar respuesta escalón en figura 2
    figure(2);
    step(M);
    legend_step{end + 1} = ['e = ', num2str(e(i))]; % Añadir etiqueta a la leyenda
end

% Añadir leyendas a las figuras
figure(1);
legend(legend_margin, 'Location', 'Best');
figure(2);
legend(legend_step, 'Location', 'Best');

% Gráficos adicionales
figure;
asymptotic_bode(GH); % Diagrama de Bode
title('Diagrama de Bode del Sistema Compensado');

figure;
grid on;
nichols(GH); % Diagrama de Nichols
title('Diagrama de Nichols del Sistema Compensado');
