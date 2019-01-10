function [start_inds, consec_counts] = count_consecutive_elements(a)

start_inds = [];
consec_counts = [];

n_numbers = length(a);
consec_bool = diff(a) == 1;
in_consec = false;
consec_count = 0;
for numberInd = 1:n_numbers - 1
    if in_consec
        if consec_bool(numberInd)
            consec_count = consec_count + 1;
        else
            in_consec = false;
            start_inds = [start_inds, start_ind];
            consec_counts = [consec_counts, consec_count + 2];
            consec_count = 0;
        end
    else
        if consec_bool(numberInd)
            start_ind = a(numberInd);
            in_consec = true;
        end
    end
end

if in_consec
    start_inds = [start_inds, start_ind];
    consec_counts = [consec_counts, consec_count + 2];
end

end