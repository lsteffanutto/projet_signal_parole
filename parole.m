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
%signal de parole durée d'un echantillon de 30ms
%correspond à une trame de 240 valeurs, donc on en prend 256
fech = 8000;
Tech=1/fech;
t = 0:Tech:length(sig1)*Tech-Tech;

sig1_sans_bruit = sig1;
trame_sans_bruit = sig1(35578 : 35578+512);

sig1_parle = sig1 > 1000;

len_trame = 1024; %plus on augmente mieux c
nb_trames = len_sig1/len_trame;
recouvrement = 50;

K=8;
M=256;
seuil = 0.35*10e4;

%% TRAITEMENT

%Bruitage
sig1 = addnoise(sig1,5);

%Signal en trames sans recouvrement
sig1_trame_rec0 = reshape(sig1, [ len_trame, nb_trames]); % SIG1 découpé en 416 trames (colonnes) de 128 éléments

%La fonction retourne le signal decomposé sig_decomp ( Signal 2x + long)
[sig1_reshape_imp , sig1_reshape_pair , sig1_decomp] = decoup_trame(sig1,len_trame,nb_trames,recouvrement);

%on applique la méthode d'addition/recouvrement fenetre
%pour se mettre dans des conditions de quasi-stationnarité
%Et reconstituer EXACTEMENT le signal de départ 
%(sauf le début et la i.e. len_trames/2
[signal_final_sans_debruite, signal_final_sans_debut_fin_sans_debruite] = fenetrage_signal_sans_debruite(sig1_reshape_imp, sig1_reshape_pair,len_trame,nb_trames, recouvrement);
[signal_final, signal_final_sans_debut_fin, val_sing_total] = fenetrage_signal(sig1_reshape_imp, sig1_reshape_pair,len_trame,nb_trames, recouvrement, K, M,seuil);

[nb_erreurs_reconstruct] = is_the_same(sig1,signal_final_sans_debruite , len_trame);

%Test de fenetrage d'une trame
trame = sig1(11040:11040+len_trame-1);
[trame_debruite, matrix_val_sing] = debruitage_trame(trame, M/2, K, seuil);

val_sing_ligne = VS_matrix_to_line(matrix_val_sing, M/2);

%% TESTS VS
%On plot les VS d'une trame
figure,
plot(val_sing_ligne);

%On plot les VS de toutes les trames du signal et on def un seuil
figure, plot(val_sing_total);
len_vs_tot = [1:14000];
const = ones(1,14000)*seuil;
hold on, plot(len_vs_tot,const,'r-');
title('toutes les VS des trames du signal');

%% RSB AVANT/APRES
[ gain_RSB_signal_rehausse ] = RSB_signal_final( sig1_sans_bruit , signal_final )

stop = 1;
%% FIGURES  

%% SIGNAL 1 + SIGNAL BRUITE

% figure,
% subplot(2,1,1)
% plot(t,sig1_sans_bruit);
% title('signal 1');
% xlabel('Temps en secondes');
% ylabel('Amplitude');
% xlim([0 6.65]);
% 
% subplot(2,1,2);
% plot(t,sig1);
% title('signal 1 noised');
% xlabel('Temps en secondes');
% ylabel('Amplitude');
% xlim([0 6.65]);

%% SPECTRO SIGNAL 1 + SPECTRO SIGNAL 1 NOISED

% figure,
% subplot(2,1,1)
% plot(t,sig1_sans_bruit);
% title('sig 1');
% xlabel('Temps en secondes');
% ylabel('Amplitude');
% 
% subplot(2,1,2);
% win  = 8;
% spectro_noverlap = 0.5*win; 
% spectrogram(sig1_sans_bruit,win,spectro_noverlap,[],fech,'yaxis')
% title('spectrogram signal 1');
% xlabel('Temps en secondes');
% ylabel('Amplitude');

% figure,
% subplot(2,1,1)
% plot(t,sig1);
% title('sig 1');
% xlabel('Temps en secondes');
% ylabel('Amplitude');
% 
% subplot(2,1,2);
% spectrogram(sig1,win,spectro_noverlap,[],fech,'yaxis')
% title('spectro signal 1 noised');
% xlabel('Temps en secondes');
% ylabel('Amplitude');

%% DIFFERENTES FENETRES POSSIBLES (HANNING c'est la mieux)

% wvtool(hamming(len_trame),hann(len_trame)); %2eme orange 3eme jaune
% wvtool(gausswin(len_trame),flattopwin(len_trame),blackman(len_trame));

%% SIGNAL DECOMP TRAMES

% figure,
% subplot(2,1,1)
% plot(t,sig1);
% title('signal 1');
% xlabel('Temps en secondes');
% ylabel('Amplitude');
% xlim([0 6.65]);
% 
% t_decomp = 0:Tech:length(sig1_decomp)*Tech-Tech; 
% subplot(2,1,2)
% plot(t_decomp,sig1_decomp);
% title('signal decompose en trames qui se suivent');
% xlabel('Temps en secondes');
% ylabel('Amplitude');
% xlim([0 13.3]);

%% SIGNAL FENETRE RECONSTITUE EXACTEMENT

figure,
subplot(2,1,1)
plot(t,sig1);
title('signal de depart');
xlabel('Temps en secondes');
ylabel('Amplitude');
xlim([0 6.65]);

subplot(2,1,2)
plot(t,signal_final_sans_debruite);
title('signal final reconstitue sans debruitage');
xlabel('Temps en secondes');
ylabel('Amplitude');
xlim([0 6.65]);

%% TEST SPECTRO SIGNAL DE BASE / SIGNAL RECONSTRUIT

% figure,
% subplot(3,1,1);
% win  = 8;
% spectro_noverlap = 0.5*win; 
% spectrogram(sig1,win,spectro_noverlap,[],fech,'yaxis')
% title('spectro signal 1 noised');
% xlabel('Temps en secondes');
% ylabel('Amplitude');
% 
% subplot(3,1,2);
% spectrogram(signal_final_sans_debut_fin_sans_debruite,win,spectro_noverlap,[],fech,'yaxis')
% title('spectro signal 1 noised reconstructed sans debruitage sans deb/fin');
% xlabel('Temps en secondes');
% ylabel('Amplitude');
% 
% subplot(3,1,3);
% spectrogram(signal_final_sans_debruite,win,spectro_noverlap,[],fech,'yaxis')
% title('spectro signal 1 noised reconstructed sans debruitage avec deb/fin de depart');
% xlabel('Temps en secondes');
% ylabel('Amplitude');


%% UNE TRAME / UNE TRAME FENETRE

% t_trame = 0:Tech:len_trame*Tech-Tech;
% figure,
% subplot(3,1,1);
% plot(t_trame,trame);
% title('Trame');
% xlabel('Temps en secondes');
% ylabel('Amplitude');
% xlim([0 Tech*len_trame]);
% 
% subplot(3,1,2);
% win_hann = hann(len_trame)'; %symetric par defaut
% trame_hann = trame.*win_hann;
% plot(t_trame,trame_hann);
% title('Trame fenetree Hann');
% xlabel('Temps en secondes');
% ylabel('Amplitude');
% xlim([0 Tech*len_trame]);
% 
% subplot(3,1,3);
% win_hamming = hamming(len_trame)'; %symetric par defaut
% trame_hamming = trame.*win_hamming;
% plot(t_trame,trame_hamming);
% title('Trame fenetree Hamming');
% xlabel('Temps en secondes');
% ylabel('Amplitude');
% xlim([0 Tech*len_trame]);

%% PREMIERE TRAME BRUITE / DEBRUITE

trame = sig1(35578 : 35578+512);

trame_debruite = signal_final(35578 : 35578+512);

t_trame = 0:Tech:len_trame*Tech-Tech;
figure,
plot(trame_sans_bruit);

hold on;
plot(trame);

hold on;
% win_hann = hann(len_trame)'; %symetric par defaut
% trame_hann = trame.*win_hann;
plot(trame_debruite, 'g');

title('trame sans bruit , trame , trame debruite');

legend('trame sans bruit','trame',' trame debruitee');

%% Comparaison signal de depart / signal bruite / signal debruite

% figure,
% subplot(2,1,1)
% plot(t,sig1_sans_bruit);
% title('signal de départ');
% xlabel('Temps en secondes');
% ylabel('Amplitude');
% subplot(2,1,2);
% fs = 10000;
% win  = 8;
% spectro_noverlap = 0.5*win; 
% spectrogram(sig1_sans_bruit,win,spectro_noverlap,[],fech,'yaxis')
% title('spectro signal de départ');
% 
% figure,
% subplot(2,1,1)
% plot(t,sig1);
% title('signal de départ bruite');
% xlabel('Temps en secondes');
% ylabel('Amplitude');
% subplot(2,1,2);
% fs = 10000;
% win  = 8;
% spectro_noverlap = 0.5*win; 
% spectrogram(sig1,win,spectro_noverlap,[],fech,'yaxis')
% title('spectro signal de départ bruite');
% 
% figure,
% subplot(2,1,1)
% plot(t,signal_final);
% title('signal final');
% xlabel('Temps en secondes');
% ylabel('Amplitude');
% subplot(2,1,2);
% fs = 10000;
% win  = 8;
% spectro_noverlap = 0.5*win; 
% spectrogram(signal_final,win,spectro_noverlap,[],fech,'yaxis')
% title('spectro signal final');

%% MEGA PLOT

figure,
subplot(2,3,1)
plot(t,sig1_sans_bruit);
title('signal de départ');
xlabel('Temps en secondes');
ylabel('Amplitude');
subplot(2,3,4);
fs = 10000;
win  = 8;
spectro_noverlap = 0.5*win; 
spectrogram(sig1_sans_bruit,win,spectro_noverlap,[],fech,'yaxis')
title('spectro signal de départ');

subplot(2,3,2)
plot(t,sig1);
title('signal de départ bruite');
xlabel('Temps en secondes');
ylabel('Amplitude');
subplot(2,3,5);
fs = 10000;
win  = 8;
spectro_noverlap = 0.5*win; 
spectrogram(sig1,win,spectro_noverlap,[],fech,'yaxis')
title('spectro signal de départ bruite');

subplot(2,3,3)
plot(t,signal_final);
title('signal final');
xlabel('Temps en secondes');
ylabel('Amplitude');
subplot(2,3,6);
fs = 10000;
win  = 8;
spectro_noverlap = 0.5*win; 
spectrogram(signal_final,win,spectro_noverlap,[],fech,'yaxis')
title('spectro signal final');

%% AUDIOS (Même en arrangeant fréquentiellement toujours les bruits aigus)
% audiowrite('signal1.wav',sig1_sans_bruit,8000) %ECRIT LE SIGNAL DANS FICHIER AUDIO
% audiowrite('signal1bruit.wav',sig1,8000) %ECRIT LE SIGNAL DANS FICHIER AUDIO
% audiowrite('signal1debruite.wav',signal_final,8000) %ECRIT LE SIGNAL DANS FICHIER AUDIO
%audiowrite('signal1decomp.wav',sig1_decomp,8000) SIGNAL AUDIO x2

% audiowrite('samarche.wav',samarche,8000) %ECRIT LE SIGNAL DANS FICHIER AUDIO
% audiowrite('signal1bruit.wav',sig1,8000) %ECRIT LE SIGNAL DANS FICHIER AUDIO


%% TESTS
%Matrice de Hankel sur une trame

% for i=1:nb_trames
%     trame = sig1_decomp( (i-1)*(len_trame)+1 : i*len_trame );
%     
%     [trame_debruite, nb_valeurs] = debruitage_trame(trame, 128, 8);
%     
%     sig1_decomp( (i-1)*(len_trame)+1 : i*len_trame ) = trame_debruite;
% 
% end

%%%LA RECONSTRUCTION BRUIT LE SIGNAL
% ON TEST UN DEBRUITAGE DIRECT SANS RECONSTRUCTION
% samarche = []
% 
% for i=1:nb_trames
%     trame = sig1( (i-1)*(len_trame)+1 : i*len_trame );
%     
%     [trame_debruite, nb_valeurs] = debruitage_trame(trame, 128, 8);
%     
%     samarche( (i-1)*(len_trame)+1 : i*len_trame ) = trame_debruite;
% 
% end
% 
% figure,
% subplot(2,1,1)
% plot(t,samarche);
% title('sig 1 DEBRUIT SANS RECONSTRUCT');
% xlabel('Temps en secondes');
% ylabel('Amplitude');
% 
% subplot(2,1,2);
% win  = 8;
% spectro_noverlap = 0.5*win; 
% spectrogram(samarche,win,spectro_noverlap,[],fech,'yaxis')
% title('spectrogram signal 1 DEBRUIT SANS RECONSTRUCT');
% xlabel('Temps en secondes');
% ylabel('Amplitude');

%[signal_final] = fenetrage_signal(sig1_reshape_imp, sig1_reshape_pair,len_trame,nb_trames, recouvrement);

%On vérifie que les 2 signaux sont bien les mêmes au finale
%nb_erreurs = 256 = longueur d'une trame, c'est normal, ce sont les 0
%de fin

%% Estimation de la variance du bruit additif

% Rsig1 = xcorr(sig1_sans_bruit,sig1_sans_bruit);
% Rsig1_reconstruct = xcorr(signal_final_sans_debruite,signal_final_sans_debruite);

% periodogramD_sig1_sans_bruit = PDaniell(sig1_sans_bruit);
% periodogramD_sig1_reconstruct = PDaniell(signal_final_sans_debruite);
% 
% t_R=-len_sig1:1:len_sig1-2;
% 
% figure,
% subplot(2,1,1);
% plot(t_R,Rsig1);
% title('Rsig1');
% xlabel('échantillons');
% ylabel('Amplitude');
% 
% subplot(2,1,2);
% plot(t_R,Rsig1_reconstruct);
% title('Rsig1_reconstruct');
% xlabel('échantillons');
% ylabel('Amplitude');
% 
% figure,
% subplot(2,1,1);
% plot(len_sig1,periodogramD_sig1_sans_bruit);
% title('periodogramD_sig1_sans_bruit');
% xlabel('Fréquence normalisée')
% ylabel('Puissance') % en puissance
% 
% subplot(2,1,2);
% plot(len_sig1,periodogramD_sig1_reconstruct);
% title('periodogramD_sig1_reconstruct');
% xlabel('Fréquence normalisée')
% ylabel('Puissance') % en puissance
