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

len_trame = 512; %plus on augmente mieux c
nb_trames = len_sig1/len_trame;
recouvrement = 50;

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
[signal_final_sans_debruite] = fenetrage_signal_sans_debruite(sig1_reshape_imp, sig1_reshape_pair,len_trame,nb_trames, recouvrement);
[nb_erreurs] = is_the_same(sig1,signal_final_sans_debruite , len_trame);

%Test de fenetrage d'une trame
trame = sig1(11040:11040+len_trame-1);
[trame_debruite, nb_valeurs] = debruitage_trame(trame, 128, 8);

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
%


%% FIGURES  (AJOUTER AXIS)

%SIGNAL 1

% %SIGNAL 1 + SIGNAL BRUITE

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

% SPECTRO SIGNAL 1 + SPECTRO SIGNAL 1 NOISED

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
% 
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

%DIFFERENTES FENETRES POSSIBLES (HANNING c'est la mieux)

% wvtool(rectwin(len_trame),hamming(len_trame),hann(len_trame)); %2eme orange 3eme jaune
% wvtool(gausswin(len_trame),flattopwin(len_trame),blackman(len_trame));

% %SIGNAL DECOMP TRAMES

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

%SIGNAL FENETRE RECONSTITUE EXACTEMENT

% figure,
% subplot(2,1,1)
% plot(t,sig1);
% title('signal de depart');
% xlabel('Temps en secondes');
% ylabel('Amplitude');
% xlim([0 6.65]);
% 
% subplot(2,1,2)
% plot(t,signal_final_sans_debruite);
% title('signal final reconstitue sans debruitage');
% xlabel('Temps en secondes');
% ylabel('Amplitude');
% xlim([0 6.65]);

%TEST SPECTRO SIGNAL DE BASE / SIGNAL RECONSTRUIT
% figure,
% subplot(2,1,1);
% win  = 8;
% spectro_noverlap = 0.5*win; 
% spectrogram(sig1,win,spectro_noverlap,[],fech,'yaxis')
% title('spectro signal 1 noised');
% xlabel('Temps en secondes');
% ylabel('Amplitude');
% 
% subplot(2,1,2);
% spectrogram(signal_final_sans_debruite,win,spectro_noverlap,[],fech,'yaxis')
% title('spectro signal 1 noised reconstructed sans debruitage');
% xlabel('Temps en secondes');
% ylabel('Amplitude');


% %UNE TRAME / UNE TRAME FENETRE

% t_trame = 0:Tech:len_trame*Tech-Tech;
% figure,
% subplot(2,1,1);
% plot(t_trame,trame);
% title('Trame');
% xlabel('Temps en secondes');
% ylabel('Amplitude');
% xlim([0 Tech*len_trame]);
% 
% subplot(2,1,2);
% win_hann = hann(len_trame)'; %symetric par defaut
% trame_hann = trame.*win_hann;
% plot(t_trame,trame_hann);
% title('Trame fenetree');
% xlabel('Temps en secondes');
% ylabel('Amplitude');
% xlim([0 Tech*len_trame]);

%PREMIERE TRAME BRUITE / DEBRUITE

% trame = sig1(35578 : 35578+512);
% 
% trame_debruite = signal_final(35578 : 35578+512);
% 
% t_trame = 0:Tech:len_trame*Tech-Tech;
% figure,
% plot(trame_sans_bruit);

% hold on;
% plot(trame);

% hold on;
% % win_hann = hann(len_trame)'; %symetric par defaut
% % trame_hann = trame.*win_hann;
% plot(trame_debruite, 'g');
% 
% title('trame sans bruit , trame , trame debruite');
% 
% legend('trame sans bruit','trame',' trame debruitee');

% figure,
% subplot(2,1,1)
% plot(t,signal_final);
% title('signal final');
% subplot(2,1,2);
% fs = 10000;
% win  = 8;
% spectro_noverlap = 0.5*win; 
% spectrogram(signal_final,win,spectro_noverlap,[],fech,'yaxis')
% title('spectro signal final');

% figure,
% subplot(2,1,1)
% fs = 10000;
% win  = 8;
% spectro_noverlap = 0.5*win; 
% spectrogram(sig1_sans_bruit,win,spectro_noverlap,[],fech,'yaxis')
% title('spectro signal 1');
% subplot(2,1,2);
% fs = 10000;
% win  = 8;
% spectro_noverlap = 0.5*win; 
% spectrogram(signal_final,win,spectro_noverlap,[],fech,'yaxis')
% title('spectro signal final');

% audiowrite('signal1.wav',sig1_sans_bruit,8000) %ECRIT LE SIGNAL DANS FICHIER AUDIO
% audiowrite('signal1bruit.wav',sig1,8000) %ECRIT LE SIGNAL DANS FICHIER AUDIO
%audiowrite('signal1debruite.wav',signal_final,8000) %ECRIT LE SIGNAL DANS FICHIER AUDIO
%audiowrite('signal1decomp.wav',sig1_decomp,8000) SIGNAL AUDIO x2

% audiowrite('samarche.wav',samarche,8000) %ECRIT LE SIGNAL DANS FICHIER AUDIO
% audiowrite('signal1bruit.wav',sig1,8000) %ECRIT LE SIGNAL DANS FICHIER AUDIO
