function [u_ons, u_off] = find_upstates_std(v, dt, v_thresh, v_thresh_onset, dur_thresh, extension_thresh)
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

% sharpen onset timing detection by checking backward for the point
% that is at a certain less stringent threshold value

n_events = length(ups);
for event_ind = 1:n_events
%     starting_index = ups(event_ind);
    current_index = ups(event_ind);
    current_value = v(current_index);
    
    if event_ind == 1
        previous_index = 1;
    else
        previous_index = downs(event_ind - 1);
    end
    
    while current_value > v_thresh_onset && current_index > previous_index
        current_index = current_index - 1;
        current_value = v(current_index);
    end
    
    ups(event_ind) = current_index;
    
end

durs = downs - ups;
long_durs = durs > dur_thresh / dt;
u_ons = ups(long_durs);
u_off = downs(long_durs);

assert(length(u_ons) == length(u_off), 'Number of detected onsets and offsets are different.')

end