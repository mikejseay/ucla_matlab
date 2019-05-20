function inds = nd_argmin(M)

[m, n] = min(M(:));
inds = ind2sub_me(size(M), n);

end