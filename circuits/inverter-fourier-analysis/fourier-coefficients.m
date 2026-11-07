function cn = fourier_coeff(f, n, T)
    % f: función simbólica en t
    % n: orden de la componente (puede ser negativo)
    % T: período de la función
    syms t
    w0 = 2*pi/T;
    cn = (1/T) * int(f * exp(-1i*n*w0*t), t, 0, T);
end
