function Xf = dft(x)
    N = length(x);            % Longitud de la señal
    Xf = zeros(1, N);          % Inicialización del vector de salida
    
    for k = 1:N
        for n = 0:N-1
            %debemos desplazar n con 1 para empezar en el primer termino
            %del vector, y para que k = 1 sea igual a 0, debemos restarle 1
            Xf(k) = Xf(k) + x(n+1) * exp(-1i * 2 * pi * (k-1) * n / N);  % Acumulación de la DFT
        end
    end
end
