%programa que genera un filtro de Nyquist
%fsim es la frecuencia de aparicion de los simbolos
%fnm es el factor de la frecuencia de muestreo,es decir que tantas
%    veces es mas grande la frecuencia de muestreo que la frecuencia 
%    de aparicion de los simbolos.
%fif es la frecuencia intermedia o la frecuencia de la portadora
%tcanal es el ancho de banda del canal

%n numero de coeficientes ( n tiene que ser par)
n=2000;
fsim=10.7622E6;
fnm=35;
tcanal=6E6;

fm=fsim*fnm;
fnyq=fsim/2; %frecuencia de corte
r=(tcanal-fnyq)/fnyq;  %roll off

t=(-n/2:n/2)/fm;
Filtro=sinc(2*fnyq.*t)...
    .*(cos(2*pi*r*fnyq.*t))...
    ./(1-(4*r*fnyq.*t).^2);
Filtro=Filtro/max(Filtro);
plot(t,Filtro)
grid on
%Ahora en frecuencia ver programa FrecsNyquist





