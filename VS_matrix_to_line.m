function [ line_vs ] = VS_matrix_to_line( matrix_val_sing, nb_vs)

line_vs = [];
for i = 1:nb_vs
    
    line_vs = [ line_vs matrix_val_sing(i,i) ];

end

