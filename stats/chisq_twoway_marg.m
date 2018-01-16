% script to calculate chi squared marginal sums
% and expected frequencies

data = [16 6 12; 9 6 9; 6 7 29];

[n_rows, n_cols] = size(data);

col_marg = squeeze(sum(data, 1));
row_marg = squeeze(sum(data, 2));
total = sum(sum(data));

exp_freqs = zeros(n_rows, n_cols);
for r=1:n_rows
    for c=1:n_cols
        exp_freqs(r, c) = row_marg(r) * col_marg(c) / total;
    end
end