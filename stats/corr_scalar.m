function corr_out = corr_scalar(a, b)

assert(length(a)==length(b), 'input vectors must be same length')

n_vals = length(a);
cov_out = dot(a - mean(a), b - mean(b)) / (n_vals - 1);
corr_out = cov_out / (std(a) * std(b));

end