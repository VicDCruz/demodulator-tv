function [f2, P1_filtro, tdtTxf_filt_dem] = passBand(fif, fm, tdtTx_dem)
    c1_dem = (fif - 1E7) / (fm / 2);
    c2_dem = (fif + 1E7) / (fm / 2);
    filtro = fir1(100, [c1_dem c2_dem]);
    tdtTxf_filt_dem = filter(filtro, 1, tdtTx_dem);
    Y_filtro = fft(tdtTxf_filt_dem);
    Ltx = length(tdtTxf_filt_dem);

    P2_filtro = abs(Y_filtro/Ltx);
    P1_filtro = P2_filtro(1:Ltx/2+1);
    P1_filtro(2:end-1) = 2 * P1_filtro(2:end-1);
    f2 = fm*(0:(n/2)) / n;
end