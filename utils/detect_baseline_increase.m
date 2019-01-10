function dev_ind = detect_baseline_increase(y, bl_pt)
% detect the first point in a time series y, which deviates positively
% from a statistical baseline (i.e. 3 * std(baseline)), which ends
% at index bl_pt

y_bl = y(1:bl_pt);

bl_sd = std(y_bl);
% bl_mean = mean(y_bl);
bl_mode = mode(y_bl);

nonbl_y = y(bl_pt:end);

dev_ind = find( nonbl_y > bl_mode + 3 * bl_sd );

end