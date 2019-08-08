function [ups, downs] = sharpen_upstates_thresh(v, ups, downs, v_thresh_onset)

n_events = length(ups);
for event_ind = 1:n_events
    
    if event_ind == 1
        previous_index = 1;
    else
        previous_index = downs(event_ind - 1);
    end
    
    % for onset...
    % move backward to find crossing of a lower threshold
    current_index = ups(event_ind);
    current_value = v(current_index);
    while current_value > v_thresh_onset && current_index > previous_index
        current_index = current_index - 1;
        current_value = v(current_index);
    end
    ups(event_ind) = current_index;
    
%     if event_ind == n_events
%         next_index = n_events;
%     else
%         next_index = ups(event_ind + 1);
%     end
%     
%     % for offset...
%     % move forward to find crossing of a lower threshold
%     current_index = downs(event_ind);
%     current_value = v(current_index);
%     while current_value > v_thresh_onset && current_index < next_index
%         current_index = current_index + 1;
%         current_value = v(current_index);
%     end
%     downs(event_ind) = current_index;
    
end

end