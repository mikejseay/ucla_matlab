function a_out = array_stack(a1, a2, dim)
% stack a1 and a2 along a new dimension
% dim of -1 indicates the end

assert(all(size(a1) == size(a2)))

in_dims = size(a1);
in_dims(in_dims == 1) = [];

if dim == -1
    dim = ndims(a1) + 1;
end

new_dims = vector_insert(in_dims, 2, dim);
pre_colons = repmat({':'}, 1, dim - 1);
post_colons = repmat({':'}, 1, ndims(a1) - dim + 1);

a_out = zeros(new_dims);
a_out(pre_colons{:}, 1, post_colons{:}) = a1;
a_out(pre_colons{:}, 2, post_colons{:}) = a2;

end