function inds = nd_argmax(M)

[m, n] = max(M(:));
inds = ind2sub_me(size(M), n);

end