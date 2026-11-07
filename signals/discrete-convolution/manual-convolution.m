function resultado = convol(x, h)
    % Asumimos que bufferRX[1] es la longitud de x y bufferRX[2] es la longitud de h
    len_x = length(x);  % bufferRX[1] en C
    len_h = length(h);  % bufferRX[2] en C
    
    % Inicializar el vector resultado con ceros
    resultado = zeros(1, len_x + len_h - 1);
    
    
    % Bucle para calcular la convolución
    for n = 1:(len_x + len_h - 1)
        resultado(n) = 0;
        for k = 1:n
            % Verificar si k y n está dentro de los límites de los vectores
            if k > len_x || (n-k+1) > len_h || (n-k+1) <= 0
                continue;
            end
            % Acumulación del valor de la convolución dada la verifcacion
            resultado(n) = resultado(n) +x(k) * h(n-k+1);
        end
    end
end
