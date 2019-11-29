function [sig1_reshape_imp , sig1_reshape_pair , sig_decomp] = decoup_trame(sig1,len_trame,nb_trames,recouvrement)

% On prend le signal découpé en trames sans recouvrement
sig1_trame_rec0 = reshape(sig1, [ len_trame, nb_trames]); % SIG1 découpé en 416 trames (colonnes) de 128 éléments

%Les trames impaires = le signal découpé en trames sans recouvrement, déjà fait
sig1_reshape_imp =sig1_trame_rec0;

%Les trames paires = même chose mais en décalant le signal de départ de len_trame*(1-recouvrement/100) 
decal = len_trame*(1-recouvrement/100);

sig1_reshape_pair = sig1(decal+1:length(sig1)-decal);
sig1_reshape_pair = reshape(sig1_reshape_pair, [ len_trame, nb_trames-1 ]);

sig_decomp =[]; %on concatene à tour de role une trame impaire et une trame paire

for j = 1 : nb_trames-1 
    
    sig_decomp = [ sig_decomp  sig1_reshape_imp(:,j)' ]; %on prend toute la j-eme trame, donc toute la j-eme colonne
    sig_decomp = [ sig_decomp  sig1_reshape_pair(:,j)' ];
    
end

%Puis on ajoute la dernière trame impaire mais pas la dernière trame paire
%qui n'existe pas

sig_decomp = [ sig_decomp   sig1_reshape_imp(:,nb_trames)' ];

%% BROUILLON
% sig1_trame_rec0 = reshape(sig1, [ len_trame, nb_trames]); % SIG1 découpé en 416 trames (colonnes) de 128 éléments
% sig1_reshape_imp = reshape(sig1, [ 128, 416]);
% sig1_reshape_pair = sig1(65:53184); %Même signal sans prendre debut 1ere trame sur 2 et fin last trame sur 2
% sig1_reshape_pair = reshape(sig1_reshape_pair, [ 128, 415]);

end

