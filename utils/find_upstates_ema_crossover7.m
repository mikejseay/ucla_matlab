function [ups, downs, up_areas, down_areas] = find_upstates_ema_crossover7(v, dt, slow_width, fast_width, ...
    up_area_thresh, down_area_thresh, dur_thresh, extension_thresh)
% given 1d signal, returns indices of on-sets and off-sets of "upstates"

% input arguments:
% v: voltage time series

% returns:
% u_ons: indices of upstate onsets
% u_off: indices of upstate offsets

% ensure voltage vector is oriented correctly (we use a row vector)
if size(v, 1) ~= 1
    v = v';
end

slow_width_pts = round(slow_width / dt);
fast_width_pts = round(fast_width / dt);

v_fast_fwd = movmean_exp(v, round(fast_width_pts / 2));
v_slow_fwd = movmean_exp(v, round(slow_width_pts / 2));

v_fast_bwd = fliplr(movmean_exp(fliplr(v), round(fast_width_pts / 2)));
v_slow_bwd = fliplr(movmean_exp(fliplr(v), round(slow_width_pts / 2)));

v_slow = 0.5 * v_slow_fwd + 0.5 * v_slow_bwd;
v_fast = 0.5 * v_fast_fwd + 0.5 * v_fast_bwd;

fast_over_slow = v_fast >= v_slow;
slow_over_fast = v_slow > v_fast;

upward_crossings = [false, slow_over_fast(1:end - 1) & fast_over_slow(2:end)];
downward_crossings = [false, fast_over_slow(1:end - 1) & slow_over_fast(2:end)];

% find crossing locations: these are the putative up and down transitions
ups = find(upward_crossings);
downs = find(downward_crossings);

% recording could have started and ended during different states
% (e.g. start during upstate & end during downstate or vice versa)
% in which case one putative up or down transition will not be paired with its buddy
% we choose the convention that the first putative event should be an up transition
% and all up transitions should be paired with a subsequent down transition
if downs(1) < ups(1)
    downs(1) = [];
end
if ups(end) > downs(end)
    ups(end) = [];
end

% no upstates? return empty vectors
if isempty(ups)
    return
end

% assess the area of each up and down region
v_fast_over_slow = v_fast - v_slow;
v_slow_over_fast = v_slow - v_fast;

% assess down regions first
% delete down regions that are too small in area
% delete current down and subsequent up indices
n_regions = length(ups);
down_areas = zeros(1, length(n_regions));
for region_ind = 1:n_regions - 1
    down_areas(region_ind) = sum(v_slow_over_fast(downs(region_ind):ups(region_ind + 1) - 1));
end
down_areas(n_regions) = sum(v_slow_over_fast(downs(end):length(v)));

small_downs = down_areas * dt < down_area_thresh;

downs([small_downs(1:end-1) false]) = [];
ups([false small_downs(1:end - 1)]) = [];

% assess remaining up regions
% delete up regions that are too small in area
% delete current up an down indices

n_regions = length(ups);
up_areas = zeros(1, length(n_regions));
for region_ind = 1:n_regions
    up_areas(region_ind) = sum(v_fast_over_slow(ups(region_ind):downs(region_ind) - 1));
end
up_areas(n_regions) = sum(v_fast_over_slow(ups(end):downs(end) - 1));

small_ups = up_areas * dt < up_area_thresh;

ups(small_ups) = [];
downs(small_ups) = [];

% only keep long upstates followed by long downstates
if ~isempty(extension_thresh) && ~isempty(dur_thresh)

    % calculate downstate durations (in points)
    down_durs = [ups(2:end) length(v)] - downs;  % consider the end of the recording to be the final "up"
    up_durs = downs - ups;
    
    long_downs = down_durs > extension_thresh / dt;
    long_ups = up_durs > dur_thresh / dt;
    
    ups = ups(long_ups & long_downs);
    downs = downs(long_ups & long_downs);
end

assert(length(ups) == length(downs), 'Number of detected onsets and offsets are different.')

end