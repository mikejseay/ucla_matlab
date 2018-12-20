function ups = find_upward_crossings(v, v_thresh)

above_bool = v > v_thresh;
below_bool = v < v_thresh;

ups = [false below_bool(1:end - 1) & above_bool(2:end)];

end