function [maxdev, onset, offset, CoM] = analyze_PSTH_deviation(psth, time, std_thresh)

test = 0;

% find max
[~, max_ind] = max(psth);
maxdev = time(max_ind);

% find clumps of supra-STD-thresh inds containing the max
supra_inds = find(psth > std_thresh);

% if no supra indices, return NaNs and such
if isempty(supra_inds)
    onset = NaN;
    offset = NaN;
    CoM = NaN;
    return
end

% analyze clumps
[start_inds, end_inds, consec_counts, n_clumps] =  ...
    find_clumps_containing(supra_inds, max_ind);

% if no clumps, return NaNs and such
if n_clumps == 0
    onset = NaN;
    offset = NaN;
    CoM = NaN;
    return
end
    
% otherwise take the max duration clump
% and  find its onset, offset, and CoM
[~, biggestClumpInd] = max(consec_counts);
onset_ind = start_inds(biggestClumpInd);
offset_ind = end_inds(biggestClumpInd);
onset = time(onset_ind);
offset = time(offset_ind);
CoM = time(onset_ind:offset_ind) * psth(onset_ind:offset_ind)' / ...
    sum(psth(onset_ind:offset_ind));

end