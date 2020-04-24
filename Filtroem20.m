%Se trata de disenar un filtro en frecuencia 
%Emplea la funcion Matlab fir1(n,Wn) nth order Wn window
%fc es el centro de la banda a filtrar con +/- rango (bwx)
%L es la longitud de la senal a filtrar
L=1000;
fc=200; %Hz 
bwx=10;
c1=(fc-bwx)/(L/2); %rango inferior
c2=(fc+bwx)/(L/2); %rango superior
b=fir1(L,[c1 c2]); %esto crea un sin(xt)/xt (especie FIR)
figure
plot(1:L+1,b) %queda centrada en L/2
axis([0 L -0.08 +0.08])
Z=fft(b); %Tranformada fourier de b (complex a+ib)
P2Z=abs(Z); % real =(a^2 + b^2)^0.5
figure
%length(P2Z)
plot(1:L+1,P2Z) %espectro two-sided del filtro 
axis([0 L 0 1.5])

%Prueba con una senal compuesta (suma frecs)
Fs=1000; %sampling frequency (mejor igual a L por coherencia de graficas)
T=1/Fs; %sampling period
t=(0:L-1)*T; %Time vector
S=0.7*sin(2*pi*200*t)+sin(2*pi*300*t); %senal
%Su espectro es
Y=fft(S);
P2=abs(Y/L);
P1=P2(1:L/2+1);
P1(2:end-1)=2*P1(2:end-1);
f1=Fs*(0:(L/2))/L;
figure 
plot(f1,P1) %single sided spectrum de la senal

Xn=filter(b,1,S); %aplicando el filtro creado
Yn=fft(Xn);
P2n=abs(Yn/L);
P1n=P2n(1:L/2+1);
P1n(2:end-1)=2*P1n(2:end-1);
f1n=Fs*(0:(L/2))/L;
figure 
plot(f1n,P1n) %single sided spectrum aplicado el filtro









