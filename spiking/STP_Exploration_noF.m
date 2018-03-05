% script to iterate through a bunch of varieties of STP, visualize results,
% and plot. first we will look only at a 2-stim paradigm

% first define params

intervals = [25 50 100 200 400];
t = 1:max(intervals)+50;
in = 0;
lbls = cell(length(intervals), 1);

tf_vals = [1 25*2.^(1:5)];
td_vals = [1 25*2.^(1:5)];
U_vals = .1:.3;
spk_range = [10 40];

n_tf = length(tf_vals);
n_td = length(td_vals);
n_U = length(U_vals);
n_intervals = length(intervals);
n_timepts = length(t);

V_intended_dims = [n_timepts n_intervals n_tf n_td n_U];
ppr_intended_dims = [n_intervals n_tf n_td n_U];

%% calculate all results

[a, b, c] = ndgrid(tf_vals, td_vals, U_vals);
tf_ur = a(:);
td_ur = b(:);
U_ur = c(:);
n_iter = length(U_ur);

all_V = zeros(n_timepts, n_intervals, n_iter);
all_psp2 = zeros(n_intervals, n_iter);
all_ppr = zeros(n_intervals, n_iter);

for i=1:n_iter
    
    tfac = tf_ur(i);
    trec = td_ur(i);
    U = U_ur(i);
    f = U;
    
    for inti=1:length(intervals)
        spiketimes = [10 10 + intervals(inti)];
        vi = IAF_STP_analytical2_gui_interval_ms(...
            t, spiketimes, trec, tfac, U, f, in);
        psp1 = max(vi(spk_range(1):spk_range(2)));
        psp2 = max(vi(spk_range(1):spk_range(2) + intervals(inti)));
        ppr = psp2 / psp1;
        all_V(:, inti, i) = vi;
        all_ppr(inti, i) = ppr;
        all_psp2(inti, i) = psp2;
    end
    
end

%% reshape results

all_V2 = reshape(all_V, V_intended_dims);
all_ppr2 = reshape(all_ppr, ppr_intended_dims);
all_psp22 = reshape(all_psp2, ppr_intended_dims);

%% plot results (1)
% display experiments across taus for a fixed U and f

% set U and f
Ui_use = 1;

ymin = nanmin(all_V2(:));
ymax = nanmax(all_V2(:));

figure;
d = 0;
for tfi=1:n_tf
    
    for tdi=1:n_td
        
        d = d + 1;
        subplot(n_tf, n_td, d);
        hold on;
        for inti=1:n_intervals
            vi = all_V2(:, inti, tfi, tdi, Ui_use);
            plot(vi);
            ylim([ymin ymax]);
        end
        set(gca,'Yticklabel',[]) 
        set(gca,'Xticklabel',[])
        supi = ['tf=', num2str(tf_vals(tfi)), ' td=', num2str(td_vals(tdi))];
        title(supi);
    end
end
supi = ['U=', num2str(U_vals(Ui_use))];
suptitle(supi);

%% plot results (2)
% show PPRs by intervals (figure), U/f (subplot), and taus (x/y axes of
% image plot)

cmax = max(all_ppr2(:));
clims = [1 cmax];
figure; clf;
for inti=1:n_intervals
    for Ui=1:n_U
        d = d + 1;
        ax = subplot(inti, n_U, d);
        pd = squeeze(all_ppr2(inti, :, :, Ui));
        imagesc_cb(pd, ax, 'Reds', clims);
        set(gca,'Yticklabel',[]) 
        set(gca,'Xticklabel',[])
        supi = ['U=', num2str(U_vals(Ui))];
        title(supi);
    end
end
suptitle(['interval=', num2str(intervals(inti))]);

%% which parameters provide the most dynamic range in PPR across intervals?

ppr_intcvs = squeeze(std(all_ppr2, 0, 1) ./ mean(all_ppr2, 1));

cmin = min(ppr_intcvs(:));
cmax = max(ppr_intcvs(:));
clims = [cmin cmax];
figure(20); clf;
d = 0;
for Ui=1:n_U
    d = d + 1;
    ax = subplot(1, n_U, d);
    pd = squeeze(ppr_intcvs(:, :, Ui));
    imagesc_cb(pd, ax, 'Reds', clims);
    set(gca,'Yticklabel',[]) 
    set(gca,'Xticklabel',[])
    supi = ['U=', num2str(U_vals(Ui))];
    title(supi);
end

%% which parameters provide good dynamic range of PPRs *and* a relatively small
% EPSP for the first interval? this optimizes the excitatory neuron

ppr_intcvs = squeeze(std(all_ppr2, 0, 1) ./ mean(all_ppr2, 1));
firstint_epsps = squeeze(all_psp22(1, :, :, :));

% comb_mat = ppr_intcvs .* (1 / firstint_epsps);
comb_mat = ppr_intcvs;

cmin = min(comb_mat(:));
cmax = max(comb_mat(:));

comb_mat(1:2, 3:6, :, :) = cmin;

clims = [cmin cmax];
figure(21); clf;
d = 0;
for Ui=1:n_U

    d = d + 1;
    ax = subplot(1, n_U, d);
    pd = squeeze(comb_mat(:, :, Ui));
    imagesc_cb(pd, ax, 'Reds', clims);
    set(gca,'Yticklabel',[]) 
    set(gca,'Xticklabel',[])
    supi = ['U=', num2str(U_vals(Ui))];
    title(supi);
end

%% which parameters have a large difference betweeen EPSP for the first
% and second interval *and* a large EPSP for the first interval
% this optimizes the inhibitory neuron

epsp_diffs = squeeze(all_psp22(1, :, :, :) - all_psp22(2, :, :, :));
firstint_epsps = squeeze(all_psp22(1, :, :, :));

comb_mat2 = epsp_diffs .* firstint_epsps;

cmin = min(comb_mat2(:));
cmax = max(comb_mat2(:));

comb_mat2(1:2, 3:6, :, :) = cmin;

clims = [cmin cmax];
figure(22); clf;
d = 0;
for Ui=1:n_U
    d = d + 1;
    ax = subplot(n_U, n_f, d);
    pd = squeeze(comb_mat2(:, :, Ui, fi));
    imagesc_cb(pd, ax, 'Reds', clims);
    set(gca,'Yticklabel',[]) 
    set(gca,'Xticklabel',[])
    supi = ['U=', num2str(U_vals(Ui)), ' f=', num2str(f_vals(fi))];
    title(supi);
end


%% adjacent interval PSP size ratios

adjint_ratios = all_psp22(1:4, :, :, :, :) ./ all_psp22(2:5, :, :, :, :);
xadjint_cvs = squeeze(std(adjint_ratios, 0, 1) ./ mean(adjint_ratios, 1));
xadjint_means = squeeze(mean(adjint_ratios, 1));
xadjint_mask = squeeze(all(adjint_ratios > 1, 1));

xadjint_means(~xadjint_mask) = NaN;

cmin = min(xadjint_means(:));
cmax = max(xadjint_means(:));
clims = [cmin cmax];
figure(23); clf;
d = 0;
for Ui=1:n_U
    for fi=1:n_f
        d = d + 1;
        ax = subplot(n_U, n_f, d);
        pd = squeeze(xadjint_means(:, :, Ui, fi));
        imagesc_cb(pd, ax, 'Reds', clims);
        set(gca,'Yticklabel',[]) 
        set(gca,'Xticklabel',[])
        supi = ['U=', num2str(U_vals(Ui)), ' f=', num2str(f_vals(fi))];
        title(supi);
    end
end