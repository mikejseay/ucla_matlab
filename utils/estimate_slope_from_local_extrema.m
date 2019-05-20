function [slope, onset_pt, offset_pt] = estimate_slope_from_local_extrema(x, t, do_plot)

[pks, pk_locs] = findpeaks(x);
[vls, vl_locs] = findpeaks(-x);
vls = -vls;

if pk_locs(1) < vl_locs(1)  % (the first local extremum is a maximum)
    vl_locs = [1, vl_locs];
    vls = [x(1), vls];
end

if vl_locs(end) > pk_locs(end)  % (the late local extremum is a minimum)
    pk_locs = [pk_locs, length(x)];
    pks = [pks, x(end)];
end

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