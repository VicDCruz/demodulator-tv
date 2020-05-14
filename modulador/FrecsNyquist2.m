%Desarolla la respuesta en frecuencia del 
%Filtro de Nyquist (igual que FrecsNyquist) pero
%utilizando la Transformada de Fourier fft 

%Primera Parte
%Se genera un filtro de Nyquist
%fsim es la frecuencia de aparicion de los simbolos
%fnm es el factor de la frecuencia de muestreo,es decir que tantas
%    veces es mas grande la frecuencia de muestreo que la frecuencia 
%    de aparicion de los simbolos.
%fif es la frecuencia intermedia o la frecuencia de la portadora
%tcanal es el ancho de banda del canal
%n numero de coeficientes ( n tiene que ser par)
n=418;
fsim=10.762237E6;
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
hold on
%se generan los puntos de muestreo.(periodo muestreo pm)
%el muestreo se refiere al original sin expansion de simbolos (zeros)
pm=1/fsim; %periodo de muestreo
x=0;y=0;
plot(x,y,'o')
for k=1:5
    x=x+pm;
    y=0;
    plot(x,y,'o')
end
hold off
%En todos los periodos la senal es zero excepto uno t=0

%Ahora en frecuencia.
Y=fft(Filtro);
P2=1-(1/0.084)*abs(Y/length(Filtro));
Va=(2*6E6/n);
f=-6.1E6:Va:-6.1E6+(n*Va);
figure
plot(f,P2)
axis([-6.5E6 6.5E6 -0.1 1.5])

