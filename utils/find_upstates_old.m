function [u_ons, u_off] = find_upstates(v, dt, v_thresh, dur_thresh, extension_thresh)
% given 1d signal, returns indices of on-sets and off-sets of "upstates"

% input arguments:
% v: voltage time series
% dt: 1 / sampling rate of v
% v_thresh: voltage threshold above which v must go to be "up"
% dur_thresh: minimum upstate duration
% extension_thresh: minimum downstate duration

% returns:
% u_ons: indices of upstate onsets
% u_off: indices of upstate offsets

% ensure voltage vector is oriented correctly (we use a row vector)
if size(v, 1) ~= 1
    v = v';
end

% define logical vectors indicating where signal is above and below the threshold
above_bool = v > v_thresh;
below_bool = v < v_thresh;

% define logical vectors indicating points of upward / downward crossings
upward_crossings = [false below_bool(1:end - 1) & above_bool(2:end)];
downward_crossings = [false above_bool(1:end - 1) & below_bool(2:end)];

% find crossing locations: these are the putative up and down transitions
ups = find(upward_crossings);
downs = find(downward_crossings);

% recording could have started and ended during different states
% (e.g. start during upstate & end during downstate or v.v.)
% in which case one putative up or down transition will not be paired with its buddy
% we choose the convention that the first putative event should be an up transition
% and all up transitions should be paired with a subsequent down transition
if length(ups) ~= length(downs)
    if downs(1) < ups(1)
        downs(1) = [];
    else
        ups(end) = [];
    end
end
% if length(ups) > length(downs)
%     ups = ups(1:end-1);
% elseif length(ups) < length(downs)
%     downs = downs(1:end-1);
% end
assert(length(ups)==length(downs));

% no upstates?
if isempty(ups)
    u_ons = [];
    u_off = [];
    return
end

% attempt to lengthen edges forward and backward
% i.e. for lengthening a long upstate's onset to a prior short upstate's offset
dists = ups(2:end) - downs(1:end - 1);

remove = dists < extension_thresh / dt;
ups = ups([true ~remove]);
downs = downs([~remove true]);
assert(length(ups)== length(downs));

durs = downs - ups;
long_durs = durs > dur_thresh / dt;
u_ons = ups(long_durs);
u_off = downs(long_durs);

assert(length(u_ons) == length(u_off), 'Number of detected onsets and offsets are different.')

end