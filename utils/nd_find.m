function inds_mat = nd_find(M)

I = find(M(:));

d = 0;
for ind = I'
    d = d + 1;
    inds_mat(d, :) = ind2sub_me(size(M), ind);
end

end