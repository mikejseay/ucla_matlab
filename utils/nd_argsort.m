function inds_mat = nd_argsort(M)


inds_mat = zeros(numel(M), length(size(M)));

[~, I] = sort(M(:));

d = 0;
for ind = I'
    d = d + 1;
    inds_mat(d, :) = ind2sub_me(size(M), ind);
end

end