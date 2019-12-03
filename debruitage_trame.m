function [trame_debruite, nb_valeurs] = debruitage_trame(trame,M,K)

% M : ?
% K : nombre de valeurs singulières à retenir pour caractériser le signal

len_trame=length(trame);

L=len_trame+1-M;

sigHankel = hankel(trame(1:L),trame(L:L+M-1));

[U,S,V]=svd(sigHankel); % Dans S on veut les K valeurs singulière les plus importantes sur les 129

S=[S(:,1:K) zeros(size(S(:,K+1:end)))]; %Laisse les vs importante (skill incroyable)

H_LS = U*S*V'; %On retrouve bien Hankel

trame_debruite = zeros(1,len_trame);
for i=1:len_trame-M
    trame_debruite(i:i+M-1) = trame_debruite(i:i+M-1) + H_LS(i,:);
end

nb_valeurs_gauche = 1:1:M;
nb_valeurs_droite = M:-1:1;
nb_valeurs_centre = M*ones(1,len_trame-length(nb_valeurs_gauche)-length(nb_valeurs_droite));

nb_valeurs = [nb_valeurs_gauche nb_valeurs_centre nb_valeurs_droite];

trame_debruite = trame_debruite./nb_valeurs;



end

