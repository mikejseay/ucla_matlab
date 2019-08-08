%% Load the recording, define the time between samples, and define a time vector.

% load('recording1_good.mat')
% load('recording2_drift.mat')
% load('recording3_driftsubmerged.mat')
% load('recording4_submerged.mat')
% load('recording5_drift.mat')
% load('recording6_extremedrift.mat')
% load('recording7_drift.mat')
% load('recording8_nonlinear_drift.mat')
% load('recording9_nonlinear_drift.mat')
load('recordingZ_noisydrift.mat')
data = data';  % transpose for future convenience
dt = 1 ./ samplingRate;  % dt is the time between samples
time = dt:dt:dt*(length(data));  % this time vector will come in handy later!
% data = detrend(data) + mode(data);

%%

% Neske et al. use 10 s and 0.1 s
% Seamari et al. use 6 s and 0.1 s
EMA_WIDTH_SLOW = 10;  % 2-6
EMA_WIDTH_FAST = 0.1; % .025-.1

dataSlowEMA1f = movmean_exp(data, round(EMA_WIDTH_SLOW / 2 / dt));
dataSlowEMA1r = flipud(movmean_exp(flipud(data), round(EMA_WIDTH_SLOW / 2 / dt)));
dataFastEMA1f = movmean_exp(data, round(EMA_WIDTH_FAST / 2 / dt));
dataFastEMA1r = flipud(movmean_exp(flipud(data), round(EMA_WIDTH_FAST / 2 / dt)));

dataSlowEMA1 = 0.5 * dataSlowEMA1f + 0.5 * dataSlowEMA1r;
dataFastEMA1 = 0.5 * dataFastEMA1f + 0.5 * dataFastEMA1r;

figure(1); clf;
% p = plot(time, data, 'k');
% p.Color(4) = 0.2;
hold on;
plot(time, dataSlowEMA1, 'g');
plot(time, dataFastEMA1, 'r');
% fill([time fliplr(time)], [dataSlowEMA1' fliplr(dataFastEMA1')], 'b');
% fill_between(time, dataSlowEMA1, dataFastEMA1);
scrollplot_default;

%% investigate the actual distribution of ups and downs

% MIN_UP_AREA = 0.5;
% MIN_DOWN_AREA = 0.04;
MIN_UP_AREA = 1;
MIN_DOWN_AREA = 0.15;

% [ups, downs] = find_upstates_ema_crossover4(data, dt, ...
%     EMA_WIDTH_SLOW, EMA_WIDTH_FAST, [], []);

% MEDIAN_FILTER_WIDTH = 0.1;  % 100 ms
% dataMedf = medfilt1(data, round(MEDIAN_FILTER_WIDTH / dt) + 1, 'truncate');

[ups, downs, up_areas, down_areas] = investigate_upstates_ema_crossover7_mean(data, dt, ...
    EMA_WIDTH_SLOW, EMA_WIDTH_FAST, MIN_UP_AREA, MIN_DOWN_AREA, [], []);

down_durs = [ups(2:end) length(data)] - downs;  % consider the end of the recording to be the final "up"
up_durs = downs - ups;

figure(4); clf;
subplot(211);
histogram(up_durs * dt, 0:.04:2);  % bin edges are chosen carefully
xlabel('Time (s)');
ylabel('# of occurrences');
title('putative Up state durations');

subplot(212);
% histogram(down_durs * dt, 0:.2:10);  % bin edges are chosen carefully
histogram(down_durs * dt, 0:.04:2);  % bin edges are chosen carefully
xlabel('Time (s)');
ylabel('# of occurrences');
title('putative Down state durations');

figure(5); clf;
subplot(211);
% histogram(up_areas);  % bin edges are chosen carefully
histogram(up_areas, 0:.01:1);  % bin edges are chosen carefully
% histogram(up_areas * dt, 0:.2:max(up_areas * dt));  % bin edges are chosen carefully
% histogram(up_areas * dt, 0:.02:1);  % bin edges are chosen carefully
% histogram(up_areas * dt);  % bin edges are chosen carefully
xlabel('Area (mV * ms)');
ylabel('# of occurrences');
title('putative Up state amplitudes');

subplot(212);
% histogram(down_areas);  % bin edges are chosen carefully
histogram(down_areas, 0:.01:1);  % bin edges are chosen carefully
% histogram(down_areas * dt, 0:.2:max(down_areas * dt));  % bin edges are chosen carefully
% histogram(down_areas * dt, 0:.02:1);  % bin edges are chosen carefully
% histogram(down_areas * dt);  % bin edges are chosen carefully
xlabel('Area (mV * ms)');
ylabel('# of occurrences');
title('putative Down state amplitudes');

%%

% by Neske
MIN_UP_DUR = 0.5;  % minimum up state duration
MIN_DOWN_DUR = 0.1;  % minimum down state duration

% [u_ons_neske, u_off_neske] = find_upstates_ema_crossover5(data, dt, ...
%     EMA_WIDTH_SLOW, EMA_WIDTH_FAST, MIN_UP_DUR, MIN_DOWN_DUR);
% [u_ons_neske, u_off_neske] = find_upstates_ema_crossover7(data, dt, ...
%     EMA_WIDTH_SLOW, EMA_WIDTH_FAST, MIN_UP_AREA, MIN_DOWN_AREA, MIN_UP_DUR, MIN_DOWN_DUR);
% [u_ons_neske, u_off_neske] = find_upstates_ema_crossover7(data, dt, ...
%     EMA_WIDTH_SLOW, EMA_WIDTH_FAST, MIN_UP_AREA, MIN_DOWN_AREA, [], []);
% [u_ons_neske, u_off_neske] = find_upstates_ema_crossover7_mean(data, dt, ...
%     EMA_WIDTH_SLOW, EMA_WIDTH_FAST, MIN_UP_AREA, MIN_DOWN_AREA, [], []);
[u_ons_neske, u_off_neske] = find_upstates_ema_crossover8_mean(data, dt, ...
    EMA_WIDTH_SLOW, EMA_WIDTH_FAST, MIN_UP_AREA, MIN_DOWN_AREA, [], []);

figure(2); clf;
plot_upstates(time, data, u_ons_neske, u_off_neske);
scrollplot_default;

% u_ons_seq = {u_ons_neske1, u_ons_neske2};
% u_off_seq = {u_off_neske1, u_off_neske2};
% labels = {'1', '2'};
% plot_upstate_comparison(time, data, u_ons_seq, u_off_seq, labels);
% scrollplot_default;

%%

[u_ons_cema1, u_off_cema1] = find_upstates_ema_crossover5(data, dt, ...
    EMA_WIDTH_SLOW, EMA_WIDTH_FAST, [], []);
[u_ons_cema2, u_off_cema2] = find_upstates_ema_crossover5(data, dt, ...
    EMA_WIDTH_SLOW, EMA_WIDTH_FAST, MIN_UP_DUR, MIN_DOWN_DUR);
%{
dw gets filtered in the following way:
    1) 
%}
[data, dw, dd, hmfast, hmslow] = maudsStatesFestWindow(data, samplingRate, round(EMA_WIDTH_SLOW / dt), round(EMA_WIDTH_FAST / dt));
u_ons_mauds1 = dw(1:end - 1, 2)';
u_off_mauds1 = dw(2:end, 1)';
[u_ons_mauds2, u_off_mauds2] = filter_upstates(u_ons_mauds1, u_off_mauds1, dt, MIN_DOWN_DUR, MIN_UP_DUR);
% u_ons_mauds2 = dd(1:end - 1, 2)';
% u_off_mauds2 = dd(2:end, 1)';
% [u_ons_mauds2, u_off_mauds2] = filter_upstates(u_ons_mauds2, u_off_mauds2, dt, [], .04);

% figure(2); clf;
% plot_upstates(time, data, u_ons_cema, u_off_cema);

figure(3); clf;
u_ons_seq = {u_ons_cema1, u_ons_cema2, u_ons_mauds1, u_ons_mauds2};
u_off_seq = {u_off_cema1, u_off_cema2, u_off_mauds1, u_off_mauds2};
labels = {'CEMA-nofilt', 'CEMA-filt', 'MAUDS-d', 'MAUDS-d-filt'};
plot_upstate_comparison(time, data, u_ons_seq, u_off_seq, labels);
scrollplot_default;

%% 

figure(6); clf;
plotMaudsFromData(data, samplingRate);
