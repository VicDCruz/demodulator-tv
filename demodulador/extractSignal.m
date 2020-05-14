function [t1, xi1] = extractSignal(fp, t, tdtTxf_filt_dem, ampMin, ampMax)
%extractSignal - Description
sp2=exp(1i*2*pi*fp.*t);
x2=real(tdtTxf_filt_dem./sp2);
if abs(ampMin)> ampMax
    x2=ampMin/min(x2)*x2;
else
   x2=ampMax/max(x2)*x2; 
end
    
end