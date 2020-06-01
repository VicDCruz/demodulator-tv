
%Este programa tiene al final una traslacion por heterodinacion de la if al
%canal asignado para transmision (60-66MHz)canal 3
%El limite es 1/2 de la frec. de fm=376.678295 MHz

%Este programa integra todo el proceso a partir de un flujo random de 832
%valores simulando la salida del codificador Trellis(-7 -5 -3 -1 1 3 5 7).
%Usa el fitro Nyquist para crear la envovente continua que modulara en
%amplitud a la portadora IF a 41 MHz. Se presenta una parte de la
%envolvente y el resultado en espectro usando fft.

close all; clear all; clc;

%Parte 1: creacion del flujo random
L0=832; %atencion: si se cambia este valor,requiere ajustes
a=-8;
b=8;
F=round(((b-a)*rand(1,L0)+a));
L0=length(F);

for i=1:L0
    if F(i)==-8;F(i)=-7;end
    if F(i)==-7;F(i)=-7;end
    if F(i)==-6;F(i)=-5;end
    if F(i)==-5;F(i)=-5;end
    if F(i)==-4;F(i)=-3;end
    if F(i)==-3;F(i)=-3;end
    if F(i)==-2;F(i)=-1;end
    if F(i)==-1;F(i)=-1;end
    if F(i)==0;F(i)=1;end
    if F(i)==1;F(i)=1;end
    if F(i)==2;F(i)=3;end
    if F(i)==3;F(i)=3;end
    if F(i)==4;F(i)=5;end
    if F(i)==5;F(i)=5;end
    if F(i)==6;F(i)=7;end
    if F(i)==7;F(i)=7;end
    if F(i)==8;F(i)=7;end
end

%Grafica de los impulsos
F1=F(250:350); %solo 100 muestras
q=1:length(F1);
figure
stem(q,F1)
xlabel('Simbolos de 100 Bytes de Muestra')
ylabel('Voltaje a 8 niveles')

%Aqui comienza el programa de modulacion
%datos
fsim=10.762237E6; % es Rs en otros programas
Ts=1/fsim;
t0=(1:32)/fsim; %t0=(0:length(flujo)-1)/fsim
fnm=35;
tcanal=6.0E6;
fif=41.3094E6;
flujo=F;

%Programa
fm=fsim*fnm;
fnyq=fsim/2;
r=(tcanal-fnyq)/fnyq;
fp=fif-((tcanal-fnyq)/2);
impulsos=upsample(flujo,fnm);
impulsosp=upsample(flujo+1.25,fnm);
t=(0:length(impulsos)-1)/fm;
b=FiltroNyquist(fnyq,1119,r,fm,'rc');
bi=b;
bq=imag(hilbert(b));
xi=filter(bi,1,impulsosp);
xq=filter(bq,1,impulsos);
x=xi+(1i*xq);

%truco para dibujar solo parte de la figura
figmax=11300;
figmin=7534;
xi1=xi(figmin:figmax);
impulsosp1=impulsosp(figmin:figmax);
t1=2E-5:(7.7305E-5/29120):2E-5+((7.7305E-5/29120)*(figmax-figmin));
figure
stem(t1+0.148E-5,impulsosp1,'*') %0.148E-5 es el retardo
hold on
plot(t1,xi1,'r')
xlabel('Parte de la Senal Continua generada sobre los Impulsos')
title('Efecto del Filtro de Nyquist')

%Segunda Parte Espectro
%La portadora
sp=exp(1i*2*pi*fp.*t);

%se modula la portadora
tdtIF=x.*sp;
L=length(impulsosp);
Y=fft(tdtIF);
P2=abs(Y/L);
P1=P2(1:L/2+1);
P1(2:end-1)=2*P1(2:end-1);
%f=376.6E6*(0:(L/2))/L;
%figure
%plot(f,P1)

%Otra vez el truco para abrir la grafica
nmin=3000;
nmax=4000;
P1a=P1(nmin:nmax);
Va=188.3E6/14561;
fa=(nmin*Va):(Va):((nmin*Va)+((nmax-nmin)*Va));
figure
plot(fa,P1a)
title('Espectro de la senal modulada en IF')
xlabel('Espectro del Bloque de 832 Bytes')

%Traslacion de frecuencias al canal 3 (61 MHz)
%a partir de la IF que esta en 41.3094 MHz
%fa=61*10^6-41.3094*10^6= 19.6906*10^6
ff=61E6;
fax=ff-fif;
n=length(tdtIF);
tt=(0:n-1)/fm;
y=cos(2*pi*fax.*t);
tdtTx=y.*tdtIF;
Y1=fft(tdtTx);
P21=abs(Y1/n);
P11=P21(1:n/2+1);
P11(2:end-1)=2*P11(2:end-1);
f1=fm*(0:(n/2))/n;
figure
plot(f1,P11)
title('Efecto de Heterodinacion')

%Construccion del filtro pasa banda
c1=(ff-1E6)/(fm/2);
c2=(ff+6E6)/(fm/2);
b=fir1(29119,[c1 c2]);
tdtTxf=filter(b,1,tdtTx);
Yf=fft(tdtTxf);
Ltx=length(tdtTxf);
P2b=abs(Yf/Ltx);
P1b=P2b(1:Ltx/2+1);
P1b(2:end-1)=2*P1b(2:end-1);
f2=fm*(0:(n/2))/n;
figure
plot(f2,P1b)
title('Espectro filtrado en 60 MHz')

%abrir la grafica
nmin=4484;
nmax=5566;
P1c=P1b(nmin:nmax);
Va=(fm/2)/length(P1b);
fa=(nmin*Va):(Va):((nmin*Va)+((nmax-nmin)*Va));
figure
plot(fa,P1c)
title('Espectro ampliado en 60 MHz')

%====== DEMODULACIÓN ======

faxDemod=abs(ff-fif); % Rango para ver los 41Mhz y 60Mhz
tdtTxDemod = ifft(Yf); % Inverso de Yf
yDemod = cos(2*pi*faxDemod.*t);
spDemod = exp(-1i*2*pi*fp.*t);
n = length(tdtTxDemod);

Y1Demod = ifft(Y1);

tdtTxDemod = Y1Demod ./ yDemod;
xDemod = tdtTxDemod .* spDemod;
xDemodSample = xDemod(figmin:figmax);

% Filtro pasa banda - 41 MHz
c1Dem = (fif-1E6)/(fm/2);
c2Dem = (fif+6E6)/(fm/2);
filtro = fir1(29119,[c1Dem c2Dem]);
tdtTxfDemod = filter(filtro,1,tdtTxDemod);
YFiltro = fft(tdtTxfDemod);
Ltx = length(tdtTxfDemod);

P2Filtro = abs(YFiltro/Ltx);
P1Filtro = P2Filtro(1:Ltx/2+1);
P1Filtro(2:end-1) = 2*P1Filtro(2:end-1);
f2 = fm*(0:(n/2))/n;

figure()
plot(f2,P1Filtro)
title('Espectro filtrado en 41 MHz')

% Ampliar espectro - 41 MHz
nmin=2900;
nmax=3900;
P1Amp = P1Filtro(nmin:nmax);
Vamp = (fm/2)/length(P1Filtro);
famp = (nmin*Vamp):(Vamp):((nmin*Vamp)+((nmax-nmin)*Vamp));
figure()
plot(famp,P1Amp)
title('Espectro ampliado en 41 MHz')

% Filtro pasa banda - 60 MHz
c1=(ff-1E6)/(fm/2);
c2=(ff+6E6)/(fm/2);
filtro=fir1(29119,[c1 c2]);
tdtTxf=filter(filtro,1,tdtTxDemod);
YFiltro=fft(tdtTxf);
Ltx=length(tdtTxf);

P2Filtro=abs(YFiltro/Ltx);
P1Filtro=P2Filtro(1:Ltx/2+1);
P1Filtro(2:end-1)=2*P1Filtro(2:end-1);
f2=fm*(0:(n/2))/n;
figure
plot(f2,P1Filtro)
title('Espectro filtrado en 60 MHz')

%Ampliar espectro - 60 MHz
nmin=4484;
nmax=5566;
P1c=P1Filtro(nmin:nmax);
Va=(fm/2)/length(P1Filtro);
fa=(nmin*Va):(Va):((nmin*Va)+((nmax-nmin)*Va));
figure
plot(fa,P1c)
title('Espectro ampliado en 60 MHz')

% Resultados
figure();
plot(t1, real(xDemodSample));
title('Demodulación sobre una muestra');

pulsosDemod = zeros(1, 3767);
for i=552:fnm:3767
    pulsosDemod(i) = xDemodSample(i);
end

figure();
plot(t1, real(xDemodSample), 'r'); hold on;
stem(t1, real(pulsosDemod), 'b*');
title('Resultados finales');