function histogram_b2b(a, b, bin_edges, norm_to_max, remove_zeros)

if nargin < 4
    norm_to_max = true;
end

if nargin < 5
    remove_zeros = false;
end

if remove_zeros
    a(a == 0) = NaN;
    b(b == 0) = NaN;
end

bin_centers = (bin_edges(1:end - 1) + bin_edges(2:end)) / 2;

a_counts = histcounts(a, bin_edges);
b_counts = histcounts(b, bin_edges);

if norm_to_max
    a_counts = a_counts ./ max(a_counts);
    b_counts = b_counts ./ max(b_counts);
end

bar(bin_centers, a_counts, 1, 'FaceColor', 'r');
hold on;
bar(bin_centers, -b_counts, 1, 'FaceColor', 'c');
hold off;

end