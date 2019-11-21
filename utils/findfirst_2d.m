function inds = findfirst_2d(a, direction)

if nargin < 2
    direction = 'first';
end

n_rows = size(a, 1);
inds = zeros(1, n_rows);

for row_ind = 1:n_rows
     tmp_ind = find(a(row_ind, :), 1, direction);
     if ~isscalar(tmp_ind)
         inds(row_ind) = NaN;
     else
         inds(row_ind) = tmp_ind;
     end
end

end