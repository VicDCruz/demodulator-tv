function main(ff, fif, tdtTx, t, tdtTxf, fm, P11, fp, figmin, figmax)
fa_dem = abs(ff - fif);
n = length(tdtTx);

y2_dem = -cos(2 * pi * fa_dem .* t);
tdtTx_dem = tdtTxf .* y2_dem;
Y1 = fft(tdtTx_dem);
P21 = abs(Y1 / n);
P11 = P21(1:n/2+1);
P11(2:end-1) = P11(2:end-1) / 2;
f1 = fm * (0:(n/2)) / n;
displaySpectrum(f1, P11, 'Trasladado a FI')

% Filtro pasa banda
f2, P1_filtro, tdtTxf_filt_dem = passBand(fif, fm, tdtTx_dem)
displaySpectrum(f2, P1_filtro, 'Espectro filtrado en 41 MHz')

% Ampliar espectro
nmin=2900;
nmax=3900;
famp, P1_amp = expandSpectrum(nmin, nmax, P1_filtro, fm)
displaySpectrum(famp ,P1_amp, 'Espectro ampliado en 41 MHz')

% Extraer señal
t1, xi1 = extractSignal(fp, t, tdtTxf_filt_dem, ampMin, ampMax)

Imin = figmin;
Imax = figmax;

figure()
offset = 0.025E-5;
plot(t1 - offset, x2(Imin:Imax))
hold on
plot(t1, xi1, 'r')
legend('Recuperada', 'Original')
grid on

% Obtener impulsos
tsam, sampling = getImpulse()

figure()
tsam = t1(1:Imax-Imin);
stem(tsam, sampling)
title('Datos recuperados')
grid on

end