% data = dataLong(1:100000);
% f = 1 ./ dt;

compressSpont;
close all;

%% take a data segment

useLimsInSeconds = [1 91];
% useLimsInSeconds = [61 91];
useSegment = dataLongMedf2(useLimsInSeconds(1) / dt:useLimsInSeconds(2) / dt - 1)';
useTime = time(1:length(useSegment));
% useTime = time(useLimsInSeconds(1) / dt:useLimsInSeconds(2) / dt - 1);

%% find upstates in multiple ways and compare

F_EST = 1;

[u_ons, u_off] = find_upstates(useSegment, dt, V_THRESH, DUR_THRESH, EXTENSION_THRESH);
u_dur = (u_off - u_ons) * dt;
n_upstates = length(u_ons);

figure(7); clf;
% hold on;
[data, f, dw] = plotMaudsFromData(useSegment, 1 / dt, F_EST, 1);
hold on;

% subplot(311);

% plot(useTime, useSegment);
% plot(use_vr + up_counter_history / running_dur_thresh * 30);
y1 = -40;
y2 = -10;
for ui = 1:n_upstates
    x1 = useTime(u_ons(ui));
    x2 = useTime(u_off(ui));
%     subplot(212);
    patch('Vertices', [x1, y1; x2, y1; x2, y2; x1, y2], ...
        'Faces', [1, 2, 3, 4], ...
        'FaceColor', 'green', 'FaceAlpha', 0.2, 'EdgeAlpha', 0);
%     subplot(211);
    line([x1 x2], [-67 -67]);
end
ylim([-70 20]);
xlim([useTime(1) useTime(end)]);

u_ons_mauds_orig = dw(1:end - 1, 2)';
u_off_mauds_orig = dw(2:end, 1)';

[u_ons_mauds_filtered, u_off_mauds_filtered] = filter_upstates(u_ons_mauds_orig, u_off_mauds_orig, dt, EXTENSION_THRESH, DUR_THRESH);
u_dur_mauds_filtered = (u_off_mauds_filtered(1:end - 1) - u_ons_mauds_filtered(1:end - 1)) * dt;
n_upstates_maud_filtered = length(u_ons_mauds_filtered);


% check out the STD method used by Mann et al. (2009)
useSegmentDeviation = dataLongDeviation(useLimsInSeconds(1) / dt:useLimsInSeconds(2) / dt - 1);
[u_ons_std, u_off_std] = find_upstates_std(useSegmentDeviation', dt, STD_THRESH, STD_THRESH_ONSET, DUR_THRESH, EXTENSION_THRESH);
n_upstates_std = length(u_ons_std);

% subplot(313);
% hold on;
% plot(useTime, useSegment);
y1 = -10;
y2 = 20;
% for ui = 1:n_upstates_maud_filtered
%     x1 = useTime(u_ons_mauds_filtered(ui));
%     x2 = useTime(u_off_mauds_filtered(ui));
for ui = 1:n_upstates_std
    x1 = useTime(u_ons_std(ui));
    x2 = useTime(u_off_std(ui));
    patch('Vertices', [x1, y1; x2, y1; x2, y2; x1, y2], ...
        'Faces', [1, 2, 3, 4], ...
        'FaceColor', 'red', 'FaceAlpha', 0.2, 'EdgeAlpha', 0);
    line([x1 x2], [-63 -63]);
end
ylim([-70, 20]);
xlim([useTime(1) useTime(end)]);


%% i like the 50 ms median filtered version

% idea: divide "upstates" from "events" based on the minimum at 470 ms
% so up periods that last longer than 470 ms are upstates
% and up periods that last less are events

F_EST = 1;
% [data, dw, dd, hmfast, hmslow] = maudsStatesFest(dataLong, f, F_EST);
[data, dw, dd, hmfast, hmslow] = maudsStatesFest(dataLongMedf2, f, F_EST);
u_ons_mauds_orig = dw(1:end - 1, 2)';
u_off_mauds_orig = dw(2:end, 1)';
u_dur_mauds_orig = (u_off_mauds_orig - u_ons_mauds_orig) * dt;
d_dur_mauds_orig = (u_ons_mauds_orig(2:end) - u_off_mauds_orig(1:end - 1)) * dt;

dataLongMedf2 = medfilt1(dataLong, 0.05 / dt - 1);

[u_ons_medf2, u_off_medf2] = investigate_crossings(dataLongMedf2', dt, V_THRESH);
u_dur_medf2 = u_off_medf2 - u_ons_medf2;
d_dur_medf2 = u_ons_medf2(2:end) - u_off_medf2(1:end - 1);

[N_um2, edges] = histcounts(u_dur_medf2, 0:.02:20);
binCentersUp = (edges(1:end - 1) + edges(2:end)) / 2;
[N_dm2, edges] = histcounts(d_dur_medf2, 0:.1:20);
binCentersDown = (edges(1:end - 1) + edges(2:end)) / 2;

[N_umaud, edges] = histcounts(u_dur_mauds_orig, 0:.02:20);
[N_dmaud, edges] = histcounts(d_dur_mauds_orig, 0:.1:20);

%%

figure(42); clf;
subplot(211);
plot(binCentersUp, N_um2, binCentersUp, N_umaud);
legend('med50', 'maud');
xlim([0 2])
subplot(212);
plot(binCentersDown, N_dm2, binCentersDown, N_dmaud);
legend('med50', 'maud');
xlim([0 8])
ylim([0 40])

%% classify into "up states" and "events" based on the distribution of up period durations

UPSTATE_THRESH = 0.47;
EVENT_THRESH = 0.05;
EXTENSION_THRESH = 0.03;

[ons, off, dist, dur] = find_upstates_and_events_points(dataLongMedf4', dt, V_THRESH, EXTENSION_THRESH);

upstate_bool = dur >= UPSTATE_THRESH / dt;
event_bool = (dur > EVENT_THRESH / dt) & (dur < UPSTATE_THRESH / dt);
u_ons = ons(upstate_bool);
u_off = off(upstate_bool);
e_ons = ons(event_bool);
e_off = off(event_bool);
n_upstates = length(u_ons);
n_events = length(e_ons);

%% plot with different colors

figure(43); clf;
plot(time, dataLongMedf4);
hold on;
y1 = -100;
y2 = 100;
for ui = 1:n_upstates
    x1 = time(u_ons(ui));
    x2 = time(u_off(ui));
    patch('Vertices', [x1, y1; x2, y1; x2, y2; x1, y2], ...
        'Faces', [1, 2, 3, 4], ...
        'FaceColor', 'blue', 'FaceAlpha', 0.2, 'EdgeAlpha', 0);
%     line([x1 x2], [-70 -70]);
end
for ei = 1:n_events
    x1 = time(e_ons(ei));
    x2 = time(e_off(ei));
    patch('Vertices', [x1, y1; x2, y1; x2, y2; x1, y2], ...
        'Faces', [1, 2, 3, 4], ...
        'FaceColor', 'red', 'FaceAlpha', 0.2, 'EdgeAlpha', 0);
%     line([x1 x2], [-70 -70]);
end
hold off;
ylim([-80, 20]);
