function [uniq_vals, counts] = count_unique_elements_cell(v)
% given 1d vector, returns unique values and their counts

uniq_vals = unique(v);
n_uniq_vals = length(uniq_vals);

counts = zeros(n_uniq_vals, 1);
for uvi=1:n_uniq_vals
    counts(uvi) = sum(strcmpi(v, uniq_vals(uvi)));
end

end