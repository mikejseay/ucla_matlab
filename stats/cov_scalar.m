function c_out = cov_scalar(a, b)

assert(length(a)==length(b), 'input vectors must be same length')

n_vals = length(a);
c_out = dot(a - mean(a), b - mean(b)) / (n_vals - 1);

end