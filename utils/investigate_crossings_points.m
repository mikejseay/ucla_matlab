function [ups, downs, dists, durs] = investigate_crossings_points(v, v_thresh)
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

% no upstates?
if isempty(ups)
    dists = [];
    durs = [];
    return
end

% attempt to lengthen edges forward and backward
% i.e. for lengthening a long upstate's onset to a prior short upstate's offset
dists = ups(2:end) - downs(1:end - 1);
durs = downs - ups;

end