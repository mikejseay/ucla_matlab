function a_out = collapse_dims(a_in, combine_dims)

in_dim_sizes = size(a_in);

% n_in_dims = length(in_dim_sizes);

% all_dims = 1:n_in_dims;
% keep_dims = setdiff(all_dims, 
% c

reshaper = [in_dim_sizes(1:(combine_dims(1) - 1)) ...
    prod(in_dim_sizes(combine_dims)) ...
    in_dim_sizes((combine_dims(end) + 1):end)];
a_out = reshape(a_in, reshaper);

end