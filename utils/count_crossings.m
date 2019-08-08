function [uc, dc] = count_crossings(v, v_thresh)

above_bool = v > v_thresh;
below_bool = v < v_thresh;

uc = sum(below_bool(1:end - 1) & above_bool(2:end));
dc = sum(above_bool(1:end - 1) & below_bool(2:end));

end