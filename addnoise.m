function [signal] = addnoise(signal,RSB)

SNR = 10.^-(RSB/10)

Puissance_signal = mean(signal.^2)

bb = randn(1,length(signal))
Puissance_bb = mean(bb.^2)

sigma2 = (Puissance_signal/Puissance_bb)*SNR 

signal = signal + (sigma2).^0.5*bb;

%sigma2 = Puissance_signal/SNR 

%signal = signal + sigmaN2*randn(1,length(signal));

end

