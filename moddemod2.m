%Programa sencillito de modulacion demodulacion
%para el dominio del tiempo
%DATOS
Fs=300E3; %Frecuencia de muestreo Hz
T=1/Fs;
L=50E3; %Longitud maxima de la senal
fpor=40E3; %portadora (IF) Hz
ff1=60E3; %frecuencia de operacion Hz
t=(0:L-1)*T; %vector de tiempo normalizado

%Generacion de una senal 
x0=1*cos(2*pi*1.0E3.*t)+1*sin(2*pi*1.2E3.*t)+1*cos(2*pi*1.4E3.*t);
figure
plot(t(1:10000),x0(1:10000)) %unidades de tiempo normalizadas
grid on
title('senal original')

%MODULACION
sp=2*cos(2*pi*fpor.*t); %portadora en 40E3 Hz (IF)
xm=(1+x0).*sp; %Modulacion
figure
plot(t(1:10000),xm(1:10000))
title('modulado original en fi 40E3 Hz')

%Traslacion de 40E3 a 60E3 Hz 
faux=abs(ff1-fpor); % 60E3-40E3 =20E3 Hz 
y=cos(2*pi*faux.*t);
xmt=xm.*y; %Quedan 2 componentes 40E3+/-20E3 o sean 60E3 y 20E3 Hz 
figure
plot(t(19000:30000),2*xmt(19000:30000))
title('trasladado pero sin filtrar')
grid on

%Filtro en 60E3 para tener un solo componente
c1=(ff1-1.5E3)/(Fs/2);
c2=(ff1+1.5E3)/(Fs/2);
b=fir1(29999,[c1 c2]);
xmtf=filter(b,1,xmt); %Esta es la senal que va al aire
figure
plot(t(19000:30000),2*xmtf(19000:30000))
title('trasladado y filtrado a 60E3: va al aire')
grid on


%RECEPTOR
%Pasa de frecuencia de operacion a FI
faux2=abs(ff1-fpor); %60K-40K = 20K Hz
y2=cos(2*pi*faux2.*t);
xmtd=xmtf.*y2; %tiene un componente en 80 y otro en 40 (60+/-20)
figure
plot(t(19000:30000),2*xmtd(19000:30000))
title('Trasladado a 40E3 Hz (IF) sin filtrar')
grid on

%Filtro en 40E3 Hz para eliminar el componente en 80E3 Hz 
c1=(fpor-1.5E3)/(Fs/2);
c2=(fpor+1.5E3)/(Fs/2);
b=fir1(29999,[c1 c2]);
xmd=filter(b,1,xmtd);

%DEMODULACION
x0d=xmd./sp; %Division entre la portadora
%requiere otro filtro al principio
%Filtro en 1.5E3
c1=(0.5E3)/(Fs/2);
c2=(1.5E3)/(Fs/2);
b=fir1(29999,[c1 c2]);
x0dd=filter(b,1,x0d);
figure
plot(t(39000:50000),5*x0dd(39000:50000))
title('Demodulando la senal original')
grid on


%espectro (solo de prueba)
Y=fft(x0dd);
P2=abs(Y/L);
P1=P2(1:L/2+1);
P1(2:end-1)=2*P1(2:end-1);
f=Fs*(0:(L/2))/L;
figure
plot(f,P1)
axis([-0.5*10^4 0.5*10^4 0 0.015])
title('espectro de prueba')


%EL PROCESO DE MODULADO y DEMODULADO OK

