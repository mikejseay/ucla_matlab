function [ons, off] = find_square_pulses(s, lower_diff_thresh, upper_diff_thresh)
% given 1d signal, returns indices of on-sets and off-sets of square pulses
sd = [0 diff(s)];

ons = find(sd > upper_diff_thresh);
off = find(sd < lower_diff_thresh);

assert(length(ons) == length(off), 'Number of detected onsets and offsets are different.')

end