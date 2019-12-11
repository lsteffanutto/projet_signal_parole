clear all;
close all;

%% VAR

nfft = 256;
N = 8*nfft;
%fs = 400
sigma=1;
var = sigma*sigma;

%t_bb=-(N)/2:1:(N)/2-1;
t_bb=-N:1:N-2;

fech=1;
f=-(fech/2):1/N:(fech/2) -1/N;
nfft = 1024;
noverlap = nfft/2;
noverlapnul=0;
% fft_abscisse =-(nfft/2):1/2*N:(nfft/2) -1;
fft_abscisse =-(fech/2):2/N:(fech/2) -1/N;

%% TRAITEMENT

%BBGC
bb = randn(1,N);
bb = bb * var;



%AUTOCORR

y = double(t_bb == 1); %xcorr théorique
%y(N/2+1) == var;
% stem(t,y);
Rbb = xcorr(bb,bb); % Théorique on doit prendre sur un nombre infini d'échantillons ( de largeur 2N normal car convolution)

%Rbb = dirac(bb); % Théorique on doit prendre sur un nombre infini d'échantillons ( de largeur 2N normal car convolution)
Rbb_b = xcorr(bb,bb,'biased'); %Nombre fini d'échantillon => Auto-corr théorique et auto-corr biasé sont les mêmes avec un facteur 1/N près
Rbb_unb = xcorr(bb,bb,'unbiased'); %Prend en compte le fait qu'il y est un nb fini d'echanillon

%PUISSANCE
%spectre de puissance = norme au carré de la transformée de fourrier, divisé par N
%spectre de puissance dépendant de réalisation du signal y(n) mais pas dsp
powerspectre = (fftshift(abs(fft(bb))).^2)/N; % Spectre de puissance
dsp = (fftshift(abs(fft(bb)).^2))*var; %DSP

%PERIODOGRAMMES
%WELCH
periodogramW = pwelch(bb,nfft,noverlap, 'centered');

%DANIELL
%On estime la DSP de chaque segment de m points pour lisser la courbe
ws = 100;
test = powerspectre;
tmp = [];
res=[];

for i = 1:1:length(powerspectre)
    
    if (i-ws/2 < 1)
        diff = 1-(i-ws/2);
        tmp = [ test(length(test):-1:length(test)-diff) test(1:ws/2+i)];
        res = [res sum(tmp)/ws];
        
        
    elseif (i+ws/2 > length(test))
        diff = (i+ws/2) - length(test);
        tmp = [ test(i-ws/2:1:end) test(1:diff)];
        res = [res sum(tmp)/ws];

    else
        res = [res sum(test(i-ws/2:i+ws/2))/ws]; 
    end
    
end

%BARTLETT

periodogramB = pwelch(bb,nfft,noverlapnul,'centered');

%Correlogramme 1 et 2

%correlo1= xcorr(bb-mean(bb)) / var;
correlo1=abs(fft(Rbb_b));
correlo2=abs(fft(Rbb_unb));



%% FIGURES
%BBGC
figure;
plot(bb);
title('BBGC');
xlabel('échantillons');
ylabel('Amplitude');
xlim([0 N])
% ylim([-1.3 1.3])

%AUTOCORR
figure;

subplot(3,1,1);
stem(t_bb,y);
% plot(t,Rbb);
title('Rbb Théorique');
xlabel('échantillons');
ylabel('Amplitude');
xlim([-N-150 N+150])
ylim([-0.2 1.3])


subplot(3,1,2);
plot(t_bb,Rbb_b);
title('Rbb-Biased');
xlabel('échantillons');
ylabel('Amplitude');
xlim([-N-150 N+150])
ylim([-0.2 1.3])

subplot(3,1,3);
plot(t_bb,Rbb_unb);
title('Rbb-Unbiased');
xlabel('échantillons');
ylabel('Amplitude');
xlim([-N-150 N+150])
ylim([-1.3 1.3])
% 
%DSP/SPECTRE DE PUISSANCE

figure
subplot(2,1,1);
plot(f,powerspectre);
title('Spectre de puissance du BBGC')
xlabel('Fréquence normalisée')
ylabel('Puissance') % en puissance

subplot(2,1,2);
plot(f, dsp);
title('DSP du BBCG')
xlabel('Fréquence normalisée')
ylabel('Puissance') % en puissance

%PERIODOGRAMME
figure,
subplot(3,1,1);
plot(fft_abscisse,periodogramW);
title('Pwelch');
xlabel('Fréquence normalisée')
ylabel('Puissance') % en puissance

subplot(3,1,2);
plot(f,res);
title('PDaniell');
xlabel('Fréquence normalisée')
ylabel('Puissance') % en puissance

subplot(3,1,3);
plot(fft_abscisse,periodogramB');
title('PBarlett');
xlabel('Fréquence normalisée')
ylabel('Puissance') % en puissance

% %CORRELOGRAMME
figure,
subplot(2,1,1);
fcorr = -(fech/2):(1/N)/2:(fech/2) -1/N;
plot(fcorr,correlo1);
title('correlogram de Rbb_b');
xlabel('échantillons');
ylabel('Amplitude');

subplot(2,1,2);
fcorr = -(fech/2):(1/N)/2:(fech/2) -1/N;
plot(fcorr,correlo2);
title('correlogram de Rbb_unb');
xlabel('échantillons');
ylabel('Amplitude');
