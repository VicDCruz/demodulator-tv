function F = getRandom(L0, a, b)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%Parte 1: creacion del flujo random
  F = round(((b - a) * rand(1, L0) + a));

  for i = 1:length(F)
    if F(i) == -8; F(i) = -7; end
    if F(i) == -7; F(i) = -7; end
    if F(i) == -6; F(i) = -5; end
    if F(i) == -5; F(i) = -5; end
    if F(i) == -4; F(i) = -3; end
    if F(i) == -3; F(i) = -3; end
    if F(i) == -2; F(i) = -1; end
    if F(i) == -1; F(i) = -1; end
    if F(i) == 0;  F (i) = 1; end
    if F(i) == 1;  F (i) = 1; end
    if F(i) == 2;  F (i) = 3; end
    if F(i) == 3;  F (i) = 3; end
    if F(i) == 4;  F (i) = 5; end
    if F(i) == 5;  F (i) = 5; end
    if F(i) == 6;  F (i) = 7; end
    if F(i) == 7;  F (i) = 7; end
    if F(i) == 8;  F (i) = 7; end
  end
end