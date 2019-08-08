function eqMatrix = compare_all_cell_entries(c)

nEntries = length(c);

pairs = nchoosek(1:nEntries, 2);
nPairs = size(pairs, 1);

eqMatrix = false(nEntries);
for pairInd = nPairs
    pairElements = pairs(pairInd, :);
    if size(c{pairElements(1)}) == size(c{pairElements(2)})
        eqMatrix(pairElements(1), pairElements(2)) = all(eq(c{pairElements(1)}, c{pairElements(2)}));
    end
end

end