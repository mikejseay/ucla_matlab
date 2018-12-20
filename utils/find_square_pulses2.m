function [ons, off] = find_square_pulses2(s)
% given 1d signal, returns indices of on-sets and off-sets of square pulses
sd = [0 diff(s)];
sd_std = std(sd);

ons = find(sd > 10 * sd_std);
off = find(sd < 10 * -sd_std);

ons_d = [0 diff(ons)];
ons_d_big = ons_d > mean(ons_d);
ons_d_big(1) = true;
ons = ons(ons_d_big);

off_d = [0 diff(off)];
off_d_big = off_d > mean(off_d);
off_d_big(1) = true;
off = off(off_d_big);

% remove consecutive ons / offs (i.e. only take the first in each set)

assert(length(ons) == length(off), 'Number of detected onsets and offsets are different.')

end