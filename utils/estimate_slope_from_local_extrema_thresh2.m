function [slope, onset_pt, offset_pt] = ...
    estimate_slope_from_local_extrema_thresh2(x, t, height_thresh, width_thresh, do_plot)

dt = t(2) - t(1);
width_thresh = round(width_thresh ./ dt);

[pks, pk_locs] = findpeaks(x);
[vls, vl_locs] = findpeaks(-x);
vls = -vls;

if isempty(pks)
    [pks, pk_locs] = max(x);
end

if isempty(vls)
    [vls, vl_locs] = min(x);
end

if pk_locs(1) < vl_locs(1)  % (the first local extremum is a maximum)
    vl_locs = [1, vl_locs];
    vls = [x(1), vls];
end

if vl_locs(end) > pk_locs(end)  % (the late local extremum is a minimum)
    pk_locs = [pk_locs, length(x)];
    pks = [pks, x(end)];
end

% if a peak is above a certain threshold, exclude it and the preceding valley
too_tall_peaks_bool = pks > height_thresh;
pks(too_tall_peaks_bool) = [];
vls(too_tall_peaks_bool) = [];
pk_locs(too_tall_peaks_bool) = [];
vl_locs(too_tall_peaks_bool) = [];

vl2pk_intervals = pk_locs - vl_locs;

% if a distance between a peak and valley is too short, remove those(?)
too_short_zigs_bool = vl2pk_intervals <= width_thresh;
% 
pks(too_short_zigs_bool) = [];
vls(too_short_zigs_bool) = [];
pk_locs(too_short_zigs_bool) = [];
vl_locs(too_short_zigs_bool) = [];

pk2vl_intervals = vl_locs(2:end) - pk_locs(1:end - 1);
too_short_zags_bool = pk2vl_intervals <= width_thresh;

pks([too_short_zags_bool false]) = [];
vls([false too_short_zags_bool]) = [];
pk_locs([too_short_zags_bool false]) = [];
vl_locs([false too_short_zags_bool]) = [];

pk_vl_diff = pks - vls;
[mpd, mpdi] = max(pk_vl_diff);
onset_pt = vl_locs(mpdi);
offset_pt = pk_locs(mpdi);
slope = mpd ./ (t(offset_pt) - t(onset_pt));

if do_plot
    hold on;
    plot(t, x);
    scatter(t(pk_locs), pks);
    scatter(t(vl_locs), vls);
    plot(t([vl_locs(mpdi), pk_locs(mpdi)]), [vls(mpdi), pks(mpdi)], '--');
    hold off;
end