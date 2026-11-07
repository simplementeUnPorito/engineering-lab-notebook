function entrada_salida_psoc_sennales(fs, SerialPort, longitud, barrido)
    % Configuración del puerto serial y parámetros
    Ts = 1 / fs;
    fincad = 'CR/LF';
    baudios = 115200;

    % Configurar y abrir el puerto serial una sola vez
    delete(instrfind);
    s = serial(SerialPort);
    set(s, 'BaudRate', baudios, 'DataBits', 8, 'Parity', 'none', 'StopBits', 1, ...
        'FlowControl', 'none', 'Timeout', 3, 'Terminator', fincad);

    fopen(s);

    %% Adquirir la señal original
    flushinput(s);
    pause(0.5);  % Reducimos el tiempo de espera para optimización
    fwrite(s, 'I');  % Solicitar al PSoC que tome una medida de la señal
    pause(1.5);      % Espera mínima antes de solicitar la señal
    fwrite(s, 'P');  % Solicitar al PSoC que envíe la señal original

    senal_original = leer_datos(s, longitud);

    % Graficar señal original
    figure;
    plot(senal_original);
    title('Señal Original');

    %% Adquirir la señal filtrada
    flushinput(s);
    pause(0.5);  % Tiempo de espera optimizado
    fwrite(s, 'F');  % Solicitar al PSoC que envíe la señal filtrada

    senal_filtrada = leer_datos(s, longitud);

    % Graficar señal filtrada
    figure;
    plot(senal_filtrada);
    title('Señal Filtrada');

    %% Analizar barridos si el parámetro barrido es 1
    if barrido == 1
        % Llamar a la función de análisis de barridos
        [ganancia] = analizar_barridos(senal_original, senal_filtrada);

        % Graficar el resultado de ganancia
        figure;
        plot(1:length(ganancia), ganancia, '-o', 'MarkerFaceColor', 'b', 'Color', [0, 0.4470, 0.7410], 'LineWidth', 1.5);
        title('Ganancia entre Señales en función de los Picos', 'FontSize', 14, 'FontWeight', 'bold');
        xlabel('Picos');
        ylabel('Ganancia (Amplitud Filtrada / Amplitud Original)');
        grid on;
        ax = gca;
        ax.GridAlpha = 0.5;  % Transparencia de la rejilla
        ax.GridLineStyle = '-';
        ax.MinorGridLineStyle = ':';
        ax.XMinorGrid = 'on';
        ax.YMinorGrid = 'on';

        % Ajuste general del gráfico
        set(gcf, 'Color', 'w'); % Cambia el fondo a blanco
    end

    %% Cerrar el puerto serial
    flushinput(s);
    fclose(s);
    delete(s);
    clear s;
    disp("Puerto serial cerrado");
end

function datos = leer_datos(s, longitud)
    % leer_datos Lee un bloque de datos del puerto serial
    %
    % Argumentos:
    %   s - objeto serial
    %   longitud - número de datos a leer
    %
    % Retorna:
    %   datos - vector de datos leídos

    datos = zeros(1, longitud);
    for count = 1:longitud
        datos(count) = str2double(fscanf(s));  % Leer cada valor como número
    end
end

function [ganancia] = analizar_barridos(senal_original, senal_filtrada)
    % analizar_barridos Calcula la ganancia entre los picos de dos señales
    %
    % Argumentos de entrada:
    %   senal_original - Señal original adquirida
    %   senal_filtrada - Señal filtrada adquirida
    %
    % Salidas:
    %   ganancia - Ganancia entre los picos de la señal filtrada y original

    % Detectar los picos en ambas señales
    [pks_original, locs_original] = findpeaks(senal_original, 'MinPeakHeight', 0.5 * max(senal_original));
    [pks_filtrada, locs_filtrada] = findpeaks(senal_filtrada, 'MinPeakHeight', 0.5 * max(senal_filtrada));

    % Asegurarse de que ambas señales tengan el mismo número de picos para comparar
    num_picos = min(length(pks_original), length(pks_filtrada));
    pks_original = pks_original(1:num_picos);
    pks_filtrada = pks_filtrada(1:num_picos);

    % Calcular la ganancia entre los picos de la señal filtrada y original
    ganancia = pks_filtrada ./ pks_original;
end
