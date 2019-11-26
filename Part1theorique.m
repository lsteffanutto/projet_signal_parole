clear all;
close all;

%% VAR
nfft = 1024;
N = 8*nfft;
%fs = 400
sigma=1;
var = sigma*sigma;
t=-N+1:1:N-1;
fech=1;
f=-(fech/2):1/N:(fech/2) -1/N;
nfft = 1024;
noverlap = nfft/2;
fft_abscisse =-(nfft/2):1:(nfft/2) -1;

bb = randn(1,N);
bb = bb * sigma;




%% TRAITEMENT
%BBGC

%AUTOCORR
Rbb = xcorr(bb,bb); % Théorique on doit prendre sur un nombre infini d'échantillons ( de largeur 2N normal car convolution)
Rbb_b = xcorr(bb,bb,'biased'); %Nombre fini d'échantillon => Auto-corr théorique et auto-corr biasé sont les mêmes avec un facteur 1/N près
Rbb_unb = xcorr(bb,bb,'unbiased'); %Prend en compte le fait qu'il y est un nb fini d'echanillon

%PUISSANCE
powerspectre = (fftshift(abs(fft(bb))).^2)/N; % Spectre de puissance
dsp = (fftshift(abs(fft(bb)).^2))*var; %DSP

%PERIODOGRAMMES
%WELCH
periodogramW = pwelch(bb,nfft,noverlap, 'centered');

%DANIELL
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

noverlapnul=0;
periodogramB = pwelch(bb,nfft,noverlapnul,'centered');

%Correlogramme 1 et 2

%correlo1= xcorr(bb-mean(bb)) / var;
correlo2=abs(fft(Rbb));



%% FIGURES
%BBGC
figure;
plot(bb);
title('BBGC');
xlabel('échantillons');
ylabel('amplitude');

%AUTOCORR
figure;

subplot(3,1,1);
plot(t,Rbb);
title('Rbb');
xlabel('échantillons');
ylabel('amplitude');

subplot(3,1,2);
plot(t,Rbb_b);
title('Rbb-Biased');
xlabel('échantillons');
ylabel('amplitude');

subplot(3,1,3);
plot(t,Rbb_unb);
title('Rbb-Unbiased');
xlabel('échantillons');
ylabel('amplitude');

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

subplot(3,1,2);
plot(f,res);
title('PDaniell');

subplot(3,1,3);
plot(fft_abscisse,periodogramB');
title('PBarlett');

%CORRELOGRAMME
figure,plot(t,correlo2);
title('correlogram');