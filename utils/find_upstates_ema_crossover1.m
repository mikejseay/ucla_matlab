function [ups, downs] = find_upstates_ema_crossover(v, dt, slow_width, fast_width, ...
    dur_thresh, extension_thresh)
% given 1d signal, returns indices of on-sets and off-sets of "upstates"

% input arguments:
% v: voltage time series

% returns:
% u_ons: indices of upstate onsets
% u_off: indices of upstate offsets

if nargin < 6
    extension_thresh = [];
end

if nargin < 5
    dur_thresh = [];
end

% ensure voltage vector is oriented correctly (we use a row vector)
if size(v, 1) ~= 1
    v = v';
end

slow_width_pts = round(slow_width / dt);
fast_width_pts = round(fast_width / dt);

v_slow = movmean_exp(v, slow_width_pts);
v_fast = movmean_exp(v, fast_width_pts);

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

% delete short downstates
if ~isempty(extension_thresh)

    % calculate downstate durations (in points)
    down_durs = ups(2:end) - downs(1:end - 1);

    % (this effectively combines upstates that are separated by short downstates)
    keep_downs = down_durs > extension_thresh / dt;
    ups = ups([true keep_downs]);
    downs = downs([keep_downs true]);

end

% delete short upstates
if ~isempty(dur_thresh)
    
    up_durs = downs - ups;
    
    long_durs = up_durs > dur_thresh / dt;
    ups = ups(long_durs);
    downs = downs(long_durs);
end

assert(length(ups) == length(downs), 'Number of detected onsets and offsets are different.')

end