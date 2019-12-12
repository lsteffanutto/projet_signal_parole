function [daniell] = PDaniell(sig)

%DANIELL
%On estime la DSP de chaque segment de m points pour lisser la courbe

N = length(sig);
powerspectre = (fftshift(abs(fft(sig))).^2)/N;
ws = 100;

tmp = [];
daniell=[];
len=length(powerspectre);

for i = 1:1:length(powerspectre)
    
    if (i-ws/2 < 1)
        diff = 1-(i-ws/2);
        tmp = [ powerspectre(len:-1:len-diff) powerspectre(1:ws/2+i)];
        daniell = [daniell sum(tmp)/ws];
        
        
    elseif (i+ws/2 > len)
        diff = (i+ws/2) - len;
        tmp = [ powerspectre(i-ws/2:1:end) powerspectre(1:diff)];
        daniell = [daniell sum(tmp)/ws];

    else
        daniell = [daniell sum(powerspectre(i-ws/2:i+ws/2))/ws]; 
    end
    
end

end

