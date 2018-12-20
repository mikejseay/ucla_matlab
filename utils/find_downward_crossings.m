function downs = find_downward_crossings(v, v_thresh)

above_bool = v > v_thresh;
below_bool = v < v_thresh;

downs = [false above_bool(1:end - 1) & below_bool(2:end)];

end