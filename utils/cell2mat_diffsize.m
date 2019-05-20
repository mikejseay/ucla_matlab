function mat = cell2mat_diffsize(cell_in)

cell_long = cell_in(:);
n_elements = length(cell_long);

mat = [];

for elemInd = 1:n_elements
    
    mat = [mat; cell_long{elemInd}(:)];
    
end

end
