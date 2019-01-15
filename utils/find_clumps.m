function [start_inds, end_inds, consec_counts, n_clumps] = find_clumps(sorted_up_inds)

% find the largest set of consecutive up_inds that contains the peak FR

% (whose ind is mNAllPosti)
[start_inds, consec_counts] = count_consecutive_elements(sorted_up_inds);
end_inds = start_inds + consec_counts - 1;
n_clumps = length(start_inds);
