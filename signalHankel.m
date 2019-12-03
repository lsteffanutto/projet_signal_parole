function [matrice] = signalHankel(signoise,M)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

L = N-M+1;

matrice = zeros(L,M);
for i=1:L
    matrice(:,i) = signoise(i:i+M-1); 
end

end

