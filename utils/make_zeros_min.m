function x_out = make_zeros_min(x_in)

x_out = x_in;
x_min_nonzero = min(x_in(x_in ~= 0));
x_out(x_out == 0) = x_min_nonzero;

end