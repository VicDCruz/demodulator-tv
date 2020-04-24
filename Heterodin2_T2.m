%Programa de demostracion del proceso
%Heterodino.Se basa en la formula:
%cos(a)*cos(b)=1/2(cos(a+b))+1/2(cos(a-b))
%si fp es la frecuencia de portadora original
%fa es una frecuencia auxiliar
%ff frecuencia final ff=fp+fa  fa=ff-fp
%Ejemplo
Fs=1000;%Sampling frequency
T=1/Fs; %Sampling Period
L=1000; %length of the signal
t=(0:L-1)*T; %time vector
fp=150;
ff=350;
fa=abs(ff-fp);
x1=cos(2*pi*fp.*t);
x2=cos(2*pi*fa.*t);
X=x1.*x2; %heterodinacion

Y1=fft(x1);
P21=abs(Y1/L);
P11=P21(1:L/2+1);
P11(2:end-1)=2*P11(2:end-1);
f1=Fs*(0:(L/2))/L;
plot(f1,P11)%frecuencia portadora original
axis([0 500 0 1]);
title('Espectro frecuencia original 150')

Y2=fft(x2);
P22=abs(Y2/L);
P12=P22(1:L/2+1);
P12(2:end-1)=2*P12(2:end-1);
f1=Fs*(0:(L/2))/L;
figure
plot(f1,P12)%frecuencia auxiliar
axis([0 500 0 1])
title('Espectro frecuencia auxiliar 350-150=200')

Y3=fft(X);
P23=abs(Y3/L);
P13=P23(1:L/2+1);
P13(2:end-1)=2*P13(2:end-1);
f1=Fs*(0:(L/2))/L;
figure
plot(f1,P13)%frecuencias fa+fp y fa-fp
axis([0 500 0 1])
title('Espectro de componentes 200+150 200-150')

%efecto del filtro para eliminar (fa-fp)
bwx1=5;  %ancho de banda senal con portadora original -5 +5
c1=(ff-bwx1)/(L/2);
c2=(ff+bwx1)/(L/2);
b=fir1(1000,[c1 c2]);
Xn=filter(b,1,X);

Y4=fft(Xn);
P24=abs(Y4/L);
P14=P24(1:L/2+1);
P14(2:end-1)=2*P14(2:end-1);
f1=Fs*(0:(L/2))/L;
figure
plot(f1,P14) %senal trasladada
axis([0 500 0 0.4])
title('Espectro de la senal trasladada a 350')

figure
subplot(4,1,1)
plot(f1,P11) %portadora original
axis([0 500 0 1])
subplot(4,1,2)
plot(f1,P12) %frecuencia auxiliar
subplot(4,1,3)
plot(f1,P13) %frecuencias fa+fp y fa-fp
subplot(4,1,4)
plot(f1,P14) %frecuencia trasladada








