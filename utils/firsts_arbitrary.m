function firsts = firsts_arbitrary(x, bin_edges)
% bin_edges should be n_bins x 2
% each row should specify edges of bins to count within
% inclusive on both sides

n_bins = size(bin_edges, 1);
firsts = nan(1, n_bins);

for binInd = 1:n_bins
    
    first_in_bin = find((x >= bin_edges(binInd, 1)) & (x <= bin_edges(binInd, 2)), 1);
    if ~isempty(first_in_bin)
        firsts(binInd) = x(first_in_bin);
    end
    
end

end