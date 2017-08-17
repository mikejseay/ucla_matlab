function c_out = cov_matrix2(a, b)

assert(length(a)==length(b), 'input vectors must be same length')

c_out = zeros(2, 2);
c_out(1, 1) = var(a);
c_out(2, 2) = var(b);

c = cov_scalar(a, b);
c_out(1, 2) = c;
c_out(2, 1) = c;

end