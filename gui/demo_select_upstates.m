%% Load the recording, define the time between samples, and define a time vector.

load('recording1_good.mat')
data = data';  % transpose for future convenience

dt = 1 ./ samplingRate;  % dt is the time between samples
time = dt:dt:dt*(length(data));  % this time vector will come in handy later!

V_THRESH = mode(data) + 5;
MIN_UP_DUR = 0.5;
MIN_DOWN_DUR = 0.1;

[u_ons, u_off] = find_upstates(data, dt, V_THRESH, MIN_UP_DUR, MIN_DOWN_DUR);

figure(1); clf;
keep_inds = select_upstates(time, data, u_ons, u_off);
scrollplot_default(time, 20);

%%

u_ons_select = u_ons(keep_inds);
u_off_select = u_off(keep_inds);

figure(2); clf;
plot_upstates(time, data, u_ons_select, u_off_select);
scrollplot_default(time, 20);
