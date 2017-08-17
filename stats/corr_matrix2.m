function c_out = corr_matrix2(a, b)

assert(length(a)==length(b), 'input vectors must be same length')

c_out = zeros(2, 2);
c_out(1, 1) = 1;
c_out(2, 2) = 1;

c = corr_scalar(a, b);
c_out(1, 2) = c;
c_out(2, 1) = c;

end