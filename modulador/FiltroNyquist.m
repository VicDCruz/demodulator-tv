function [Filtro] = FiltroNyquist(fnyq,n,r,fm,tipo )
%Genera un filtro de Nyquist normalizado.
%fnyq es la frecuencia de corte
%r    factor de roll-off
%n   numero de coeficientes (n debe ser par)
%fm  frecuencia de muestreo
%tipo filtro Raised Cosine 'rc' 
     %filtro Root Raised Cosine 'rrc'

 t=(-n/2:n/2)/fm;
 switch tipo 
     case 'rc'
         Filtro=sinc(2*fnyq.*t)...
             .*(cos(2*pi*r*fnyq.*t))...
             ./(1-(4*r*fnyq.*t).^2);
     case 'rrc'
         Filtro=(sin(pi*2*fnyq*(1-r).*t)...
             +(8*r*fnyq.*cos(pi*2*fnyq*(1+r).*t).*t))...
             ./(2*fnyq*pi.*(1-(8*r*fnyq.*t).^2).*t);
         %Singularidad de t=0
         Filtro((n/2)+1)=(2*fnyq*pi*(1-r)+8*r*fnyq)/(2*pi*fnyq);
 end
 %normalizacion del filtro
 Filtro=Filtro/max(Filtro);


end

