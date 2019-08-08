function counts = histcounts_arbitrary(x, bin_edges)
% bin_edges should be n_bins x 2
% each row should specify edges of bins to count within
% inclusive on both sides

n_bins = size(bin_edges, 1);
counts = zeros(1, n_bins);

for binInd = 1:n_bins
    
    counts(binInd) = sum(...
        (x >= bin_edges(binInd, 1)) & ...
        (x <= bin_edges(binInd, 2))...
        );
    
end

end