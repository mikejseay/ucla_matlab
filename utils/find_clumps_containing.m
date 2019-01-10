function [start_inds, end_inds, consec_counts, n_clumps] = ...
    find_clumps_containing(sorted_up_inds, must_contain_ind)

% find the largest set of consecutive up_inds that contains the peak FR

% (whose ind is mNAllPosti)
[start_inds, consec_counts] = count_consecutive_elements(sorted_up_inds);
end_inds = start_inds + consec_counts - 1;
n_clumps = length(start_inds);

% if a clump does not contain the overall max post-stimulus FR, remove it from consideration
for clumpInd = n_clumps:-1:1
    if start_inds(clumpInd) > must_contain_ind || end_inds(clumpInd) < must_contain_ind
        start_inds(clumpInd) = [];
        end_inds(clumpInd) = [];
        consec_counts(clumpInd) = [];
        n_clumps = n_clumps - 1;
    end
end
        