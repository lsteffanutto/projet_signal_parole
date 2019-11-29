clear all;
close all;
clc;

%% VAR
sig1 = load('fcno03fz.mat');
sig1 =sig1.fcno03fz;
sig1=sig1';

len_sig1=length(sig1);

sig2 = load('fcno04fz.mat');
sig2 =sig2.fcno04fz;
sig2=sig2';
N2=length(sig2);
%signal de parole durée d'un echantillon 30ms
fech = 8000;
Tech=1/fech;
t = 0:Tech:length(sig1)*Tech-Tech;


%% TRAITEMENT
sig1 = addnoise(sig1,5);

len_trame = 256;
nb_trames = len_sig1/len_trame;

recouvrement = 50;

%Signal en trames sans recouvrement
sig1_trame_rec0 = reshape(sig1, [ len_trame, nb_trames]); % SIG1 découpé en 416 trames (colonnes) de 128 éléments

%La fonction retourne le signal decomposé sig_decomp ( Signal 2x + long)
[sig1_reshape_imp , sig1_reshape_pair , sig1_decomp] = decoup_trame(sig1,len_trame,nb_trames,recouvrement);

%Differentes fenêtres possibles (HANNINIG c'est la mieux)
% wvtool(rectwin(len_trame),hamming(len_trame),hann(len_trame)); %2eme orange
% wvtool(gausswin(len_trame),flattopwin(len_trame),blackman(len_trame));
%PAS OUBLIER
%fenetrage de hamming window = hamming(L);


%% FIGURES

%UNE TRAME
t_trame = 0:Tech:len_trame*Tech-Tech;
trame = sig1_decomp(1,1:len_trame);
figure,
subplot(2,1,1);
plot(t_trame,trame);
title('1st trame');

%FENETREE
subplot(2,1,2);
win_hann = hann(len_trame)'; %symetric par defaut
trame_hann = trame.*win_hann;
plot(t_trame,trame_hann);
title('1st trame fenetred');

figure,
subplot(2,1,1)
plot(t,sig1);
title('signal 1');

%signal_windowed=fenetrage_signal(sig1_decomp,len_trame,nb_trames);
%t_signal_windowed = 0:Tech:length(signal_windowed)*Tech-Tech;

[signal_final] = fenetrage_signal(sig1_reshape_imp, sig1_reshape_pair,len_trame,nb_trames, recouvrement);

subplot(2,1,2)
plot(t,signal_final);
title('signal decompose en trames windowed');

%SIGNAL + SPECTRO
figure,
subplot(2,1,1)
plot(t,sig1);
title('signal 1');
subplot(2,1,2);
fs = 10000;
win  = 8;
spectro_noverlap = 0.5*win; 
spectrogram(sig1,win,spectro_noverlap,[],fech,'yaxis')
title('signal 1');
% 
% %SIGNAL DECOMP TRAMES
% 
figure,
subplot(2,1,1)
plot(t,sig1);
title('signal 1');
t_decomp = 0:Tech:length(sig1_decomp)*Tech-Tech;
% figure, 
subplot(2,1,2)
plot(t_decomp,sig1_decomp);
title('signal decompose en trames qui se suivent');
% 
% % audiowrite('musique.wav',sig1,8000) %ECRIT LE SIGNAL DANS FICHIER AUDIO
% % audiowrite('musiquedecomp.wav',sig1_decomp,8000) 
