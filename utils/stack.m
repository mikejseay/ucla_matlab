function a_out = stack(a1, a2, axis)
% stack a1 and a2 along a new dimension, either at the beginning (1) or end (-1)

assert(all(size(a1) == size(a2)))

dims = size(a1);
dims(dims == 1) = [];
colons = repmat({':'}, 1, length(dims));

if axis == 1
    new_dims = [2, dims];
    a_out = zeros(new_dims);
    a_out(1, colons{:}) = a1;
    a_out(2, colons{:}) = a2;
elseif axis == -1
    new_dims = [dims, 2];
    a_out = zeros(new_dims);
    a_out(colons{:}, 1) = a1;
    a_out(colons{:}, 2) = a2;
else
    error('axis argument misspecified')
end

end