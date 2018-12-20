function [uniq_vals, counts] = count_unique_elements(v)
% given 1d vector, returns unique values and their counts

uniq_vals = unique(v);
n_uniq_vals = length(uniq_vals);

counts = zeros(1, n_uniq_vals);
for uvi=1:n_uniq_vals
    counts(uvi) = sum(v==uniq_vals(uvi));
end

end