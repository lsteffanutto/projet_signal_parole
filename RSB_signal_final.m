function [ gain_RSB_signal_rehausse ] = RSB_signal_final( signal_depart , signal_rehausse )

gain_bruit = signal_rehausse - signal_depart;

Puissance_bruit = sum(gain_bruit.^2)/length(gain_bruit);
Puissance_signal_depart = sum(signal_depart.^2)/length(signal_depart);

gain_RSB_signal_rehausse = 10*log10(Puissance_signal_depart/Puissance_bruit);

end

