function [outputArg1,outputArg2] = decomposesignal(signal,recouvrement,nbsegment)

L = length(signal)/nbsegment;

reshape(signal, [1,L]);


end

