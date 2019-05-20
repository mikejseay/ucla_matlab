function [ons, off] = find_square_pulses3(s)
% given 1d signal, returns indices of on-sets and off-sets of square pulses
sd = [0 diff(s)];
sd_std = std(sd);

ons = find(sd > max(sd) / 2);
off = find(sd < min(sd) * .4);

% if there's any issue, remove consecutive ons / offs (i.e. only take the first in each set)
if length(ons) ~= length(off)

    ons_d = [0 diff(ons)];
    ons_d_big = ons_d > 1;
    ons_d_big(1) = true;
    ons = ons(ons_d_big);

    off_d = [0 diff(off)];
    off_d_big = off_d > 1;
    off_d_big(1) = true;
    off = off(off_d_big);

end

assert(length(ons) == length(off), 'Number of detected onsets and offsets are different.')

end