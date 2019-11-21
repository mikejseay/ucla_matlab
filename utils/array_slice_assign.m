function A = slice_assign(A, ix, dim, B)
%SLICE_ASSIGN Assign new values to a "slice" of A

subses = repmat({':'}, [1 ndims(A)]);
subses{dim} = ix;
A(subses{:}) = B;

end