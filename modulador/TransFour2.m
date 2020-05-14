%Ejemplo de espectro single sided and two sided
Fs=1000; %sampling frequency
T=1/Fs; %sampling period
L=1000; %length of the signal
t=(0:L-1)*T; %time vector
S=0.7*sin(2*pi*50*t)+sin(2*pi*120*t); %signal
X=S+2*randn(size(t)); %signal+noise (matriz 1 x 1000)
figure
plot(1000*t(1:100),X(1:100))
%Espectro en frecuencias
Y=fft(X); %Obtiene numeros complex Real+imaginario
P2=abs(Y/L); %convierte a reales two sided spectrum
P1=P2(1:L/2+1); %solo interesa la mitad single sided
P1(2:end-1)=2*P1(2:end-1); %se multiplican por 2 menos el 1o y el ultimo
f=Fs*(0:(L/2))/L; %va de 0 a 500 Fs=L en este caso
figure
plot(f,P1) %grafica single-sided

%grafica two sided spectrum
P2(2:end-1)=2*P2(2:end-1);
%length(P2); %para checar
f2=Fs*(0:L-1)/L;
%length(f2); %para checar
figure
plot(f2,P2)