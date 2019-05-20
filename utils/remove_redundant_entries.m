function a_out = remove_redundant_entries(a_in)

n_elements = length(a_in);
a_out = [];

for elementInd = 1:n_elements
    
    currentElement = a_in(elementInd);
    if ~ismember(currentElement, a_out)
        a_out = [a_out, currentElement];
    end
end

end