function [signal_final] = fenetrage_signal(signal_reshape_imp, signal_reshape_pair,len_trame,nb_trames, recouvrement)

decal = len_trame*(1-recouvrement/100); %recouvrement = 50

win_hann = hann(len_trame); % fenre de Hann sur la durée du trame

win_hann_deb = win_hann(1:len_trame/2,1);   %debut d'une fenetre de hamming (1ere moitié)
win_hann_fin = win_hann((len_trame/2)+1:len_trame,1);   %fin d'une fenetre de hamming (2nd moitié)

% On va fenetrer et moyenner le signal partout sauf 1ere partie 1ere trame
% 2nd partie derniere tram (par rapport à un signal en trame sans
% recouvrement

signal_windowed=[];

for i = 1:nb_trames-1
    
    x1 = signal_reshape_imp(decal+1:len_trame,i).*win_hann_fin;         %On multiplie la fin trame impaire par fin fen_hann
    x2 = signal_reshape_pair(1:decal,i).*win_hann_deb;                  %On multiplie debut trame pair par debut fen_hann
    win_hann_fin + win_hann_deb
    X = (x1 + x2 )./(win_hann_fin + win_hann_deb);                     %On moyenne la 1ère section étudié
    
    signal_windowed = [ signal_windowed ; X ];
    
    y1 = signal_reshape_imp(1:decal,i+1).*win_hann_deb;                 %On multiplie debut TRAME+1 impaire par debut fen_hann
    y2 = signal_reshape_pair(decal+1:len_trame,i).*win_hann_fin;        %On multiplie fin trame pair par fin fen_hann
    
    Y = (y1 + y2 )./(win_hann_fin + win_hann_deb);                     %On moyenne la 2nd section étudié
    
    signal_windowed = [ signal_windowed ; Y ];
    
end

%On reconstruit alors le signal fenetre/moyenne (sauf debut et fin)

signal_windowed

decalage = zeros(1,128);

signal_final = [ decalage signal_windowed' decalage ];

end

% DIVISION PAR ./(win_hann_fin + win_hann_deb) BOF JE PENSE



