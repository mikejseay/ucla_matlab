function inds = find_along_dim(a, n, direction, dimension)

n_elements_along_dim = size(a, n);

inds = zeros(1, n_elements_along_dim);
for dim_level = 1:n_elements_along_dim
    inds(dim_level) = find(array_slice(
end

end