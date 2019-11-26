clear all;
close all;
clc;

%% VAR
sig1 = load('fcno03fz.mat');
sig1 =sig1.fcno03fz;
sig1=sig1';

N1=length(sig1);

sig2 = load('fcno04fz.mat');
sig2 =sig2.fcno04fz;
sig2=sig2';
N2=length(sig2);
%signal de parole durée d'un echantillon 30ms
fech = 8000;
Tech=1/fech;
t = 0:Tech:length(sig1)*Tech-Tech;

%audiowrite('musique.wav',sig1,8000) %ECRIT LE SIGNAL DANS FICHIER AUDIO



%% TRAITEMENT
sig1 = addnoise(sig1,50);


%fenetrage de hamming window = hamming(L);
%% FIGURES


figure,
subplot(2,1,1)
plot(t,sig1);
title('signal 1');
subplot(2,1,2)
fs = 10000
win  = 8;
spectro_noverlap = 0.5*win; 
spectrogram(sig1,win,spectro_noverlap,[],fech,'yaxis')
title('signal 1');

% figure,plot(sig2);
% title('signal 2');

%audiowrite('musique.wav',sig1,8000) %ECRIT LE SIGNAL DANS FICHIER AUDIO
