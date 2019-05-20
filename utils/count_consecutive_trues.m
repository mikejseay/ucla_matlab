function counts = count_consecutive_trues(bool_array)

n_elements = length(bool_array);
counts = zeros(1, n_elements);

d = 0;
for e = 1:n_elements
    if bool_array(e)
        d = d + 1;
    else
        d = 0;
    end
    counts(e) = d;
end

end