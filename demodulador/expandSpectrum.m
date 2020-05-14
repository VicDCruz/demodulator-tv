function [famp, P1_amp] = expandSpectrum(nmin, nmax, P1_filtro, fm)
    P1_amp = P1_filtro(nmin:nmax);
    Vamp = (fm/2)/length(P1_filtro);
    famp = (nmin*Vamp):(Vamp):((nmin*Vamp)+((nmax-nmin)*Vamp));
end