function out = array_slice(A, ix, dim)
% see subsref, subsasgn, subsindex, and builtin for more ninja shit

subses = repmat({':'}, [1 ndims(A)]);
subses{dim} = ix;
out = A(subses{:});

end