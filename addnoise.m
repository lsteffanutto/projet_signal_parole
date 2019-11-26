function [signal] = addnoise(signal,RSB)

SNR = 10.^(RSB/10)

Puissance_signal = mean(signal.^2)

sigmaN2 = Puissance_signal/SNR 

signal = signal + sigmaN2*randn(1,length(signal));

end

