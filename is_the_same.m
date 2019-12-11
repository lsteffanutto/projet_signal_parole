function [nb_erreurs] = is_the_same(sig1,signal_final, len_trame)

len = length(sig1);
nb_erreurs = 0;
decal = len_trame/2;

indices = [];
for i = 1:len
    
    if floor(signal_final(1,i)) ~= floor(sig1(1,i))

        nb_erreurs = nb_erreurs +1;

    end         
            
    
end


end

