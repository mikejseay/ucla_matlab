function [u_ons, u_off] = find_upstates(v, dt, v_thresh, init_dur_thresh, extension_thresh)
% given 1d signal, returns indices of on-sets and off-sets of "upstates"

above_bool = v > v_thresh;
below_bool = v < v_thresh;

upward_crossings = [false below_bool(1:end - 1) & above_bool(2:end)];
downward_crossings = [false above_bool(1:end - 1) & below_bool(2:end)];

ups = find(upward_crossings);
downs = find(downward_crossings);
if length(ups) > length(downs)
    ups = ups(1:end-1);
elseif length(ups) < length(downs)
    downs = downs(1:end-1);
end
assert(length(ups)==length(downs));

% attempt to lengthen edges forward and backward
dists = ups(2:end) - downs(1:end - 1); % i.e. for lengthening a long upstate's onset to a prior short upstate's offset

% no upstates?
if isempty(ups)
    u_ons = [];
    u_off = [];
    return
end

remove = dists < extension_thresh / dt;
ups = ups([true ~remove]);
downs = downs([~remove true]);
assert(length(ups)== length(downs));

durs = downs - ups;
long_durs = durs > init_dur_thresh / dt;
u_ons = ups(long_durs);
u_off = downs(long_durs);

assert(length(u_ons) == length(u_off), 'Number of detected onsets and offsets are different.')

end