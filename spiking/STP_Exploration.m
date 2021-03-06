% script to iterate through a bunch of varieties of STP, visualize results,
% and plot. first we will look only at a 2-stim paradigm

% first define params

intervals = [25 50 100 200 400];
t = 1:max(intervals)+50;
in = 0;
lbls = cell(length(intervals), 1);

tf_vals = [1 25*2.^(1:5)];
td_vals = [1 25*2.^(1:5)];
U_vals = .1:.1:.3;
f_vals = .1:.1:.3;

spk_range = [10 20];

n_tf = length(tf_vals);
n_td = length(td_vals);
n_U = length(U_vals);
n_f = length(f_vals);
n_intervals = length(intervals);
n_timepts = length(t);

V_intended_dims = [n_timepts n_intervals n_tf n_td n_U n_f];
ppr_intended_dims = [n_intervals n_tf n_td n_U n_f];

%% calculate all results

[a, b, c, d] = ndgrid(tf_vals, td_vals, U_vals, f_vals);
tf_ur = a(:);
td_ur = b(:);
U_ur = c(:);
f_ur = d(:);
n_iter = length(f_ur);

all_V = zeros(n_timepts, n_intervals, n_iter);
all_psp1_long = zeros(n_intervals, n_iter);
all_psp2_long = zeros(n_intervals, n_iter);
all_ppr_long = zeros(n_intervals, n_iter);

for i=1:n_iter
    
    tfac = tf_ur(i);
    trec = td_ur(i);
    U = U_ur(i);
    f = f_ur(i);
    
    for inti=1:length(intervals)
        spiketimes = [10 10 + intervals(inti)];
        vi = IAF_STP_analytical2_gui_interval_ms(...
            t, spiketimes, trec, tfac, U, f, in);
        psp1 = max(vi(spk_range(1):spk_range(2)));
        psp2 = max(vi(spk_range(1):spk_range(2) + intervals(inti)));
        ppr = psp2 / psp1;
        all_V(:, inti, i) = vi;
        all_ppr_long(inti, i) = ppr;
        all_psp1_long(inti, i) = psp1;
        all_psp2_long(inti, i) = psp2;
    end
    
end

% reshape results

all_V2 = reshape(all_V, V_intended_dims);
all_ppr = reshape(all_ppr_long, ppr_intended_dims);
all_psp1 = reshape(all_psp1_long, ppr_intended_dims);
all_psp2 = reshape(all_psp2_long, ppr_intended_dims);

% calculate linear fits

bexc_all = zeros(ppr_intended_dims(2:end));
binh_all = zeros(ppr_intended_dims(2:end));
r2exc_all = zeros(ppr_intended_dims(2:end));
r2inh_all = zeros(ppr_intended_dims(2:end));

x = (1:4)';
X = [ones(size(x)) x];
for tfi=1:n_tf
    for tdi=1:n_td
        for Ui=1:n_U
            for fi=1:n_f
                yexc = all_ppr(2:5, tfi, tdi, Ui, fi);
                yinh = all_ppr(1:4, tfi, tdi, Ui, fi);
                [bexc, ~, ~, ~, statsexc] = regress(yexc, X);
                [binh, ~, ~, ~, statsinh] = regress(yinh, X);
                bexc_all(tfi, tdi, Ui, fi) = bexc(2); % slope
                binh_all(tfi, tdi, Ui, fi) = binh(2);
                r2exc_all(tfi, tdi, Ui, fi) = statsexc(1); % r^2
                r2inh_all(tfi, tdi, Ui, fi) = statsinh(1);
            end
        end
    end
end

%% plot results (1)
% display experiments across taus for a fixed U and f

% set U and f
Ui_use = 1;
fi_use = 2;

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
            vi = all_V2(:, inti, tfi, tdi, Ui_use, fi_use);
            plot(vi);
            ylim([ymin ymax]);
        end
        set(gca,'Yticklabel',[]) 
        set(gca,'Xticklabel',[])
        supi = ['tf=', num2str(tf_vals(tfi)), ' td=', num2str(td_vals(tdi))];
        title(supi);
    end
end
supi = ['U=', num2str(U_vals(Ui_use)), ' f=', num2str(f_vals(fi_use))];
suptitle(supi);


%% plot results (1.1)
% display experiments across taus for all U/f

% set U and f
ymin = nanmin(all_V2(:));
ymax = nanmax(all_V2(:));

for Ui=1:n_U
    for fi=1:n_f
figure;
d = 0;
for tfi=1:n_tf
    for tdi=1:n_td
        
        d = d + 1;
        subplot(n_tf, n_td, d);
        hold on;
        for inti=1:n_intervals
            vi = all_V2(:, inti, tfi, tdi, Ui, fi);
            plot(vi);
            ylim([ymin ymax]);
        end
        set(gca,'Yticklabel',[]) 
        set(gca,'Xticklabel',[])
        supi = ['tf=', num2str(tf_vals(tfi)), ' td=', num2str(td_vals(tdi))];
        title(supi);
    end
end
supi = ['U=', num2str(U_vals(Ui)), ' f=', num2str(f_vals(fi))];
suptitle(supi);
    end
end

%% plot results (1.2)
% display psp1 amps

%% plot results (1.3)


%% plot results (2)
% show PPRs by intervals (figure), U/f (subplot), and taus (x/y axes of
% image plot)

cmax = max(all_ppr(:));
clims = [1 cmax];
for inti=1:n_intervals
    figure(inti); clf;
    d = 0;
    for Ui=1:n_U
        for fi=1:n_f
            d = d + 1;
            ax = subplot(n_U, n_f, d);
            pd = squeeze(all_ppr(inti, :, :, Ui, fi));
            imagesc_cb(pd, ax, 'Reds', clims);
            if Ui == n_U
                xticks(1:n_td);
                xticklabels(td_vals);
                set(gca,'Yticklabel',[]) 
                xlabel('tau-dep');
            elseif fi == 1
                yticks(1:n_tf);
                yticklabels(tf_vals);
                set(gca,'Xticklabel',[])
                ylabel('tau-fac');
            else
                set(gca,'Yticklabel',[]) 
                set(gca,'Xticklabel',[])
            end
            supi = ['U=', num2str(U_vals(Ui)), ' f=', num2str(f_vals(fi))];
            title(supi);
        end
    end
    suptitle(['interval=', num2str(intervals(inti))]);
end

%% which parameters provide the most dynamic range in PPR across intervals?

ppr_intcvs = squeeze(std(all_ppr, 0, 1) ./ mean(all_ppr, 1));

cmin = min(ppr_intcvs(:));
cmax = max(ppr_intcvs(:));
clims = [cmin cmax];
figure(20); clf;
d = 0;
for Ui=1:n_U
    for fi=1:n_f
        d = d + 1;
        ax = subplot(n_U, n_f, d);
        pd = squeeze(ppr_intcvs(:, :, Ui, fi));
        imagesc_cb(pd, ax, 'Reds', clims);
        if Ui == n_U
            xticks(1:n_td);
            xticklabels(td_vals);
            set(gca,'Yticklabel',[]) 
            xlabel('tau-dep');
        elseif fi == 1
            yticks(1:n_tf);
            yticklabels(tf_vals);
            set(gca,'Xticklabel',[])
            ylabel('tau-fac');
        else
            set(gca,'Yticklabel',[]) 
            set(gca,'Xticklabel',[])
        end
        supi = ['U=', num2str(U_vals(Ui)), ' f=', num2str(f_vals(fi))];
        title(supi);
    end
end

%% which parameters provide good dynamic range of PPRs *and* a relatively small
% EPSP for the first interval? this optimizes the excitatory neuron

ppr_intcvs = squeeze(std(all_ppr, 0, 1) ./ mean(all_ppr, 1));

% comb_mat = ppr_intcvs .* (1 / firstint_epsps);
comb_mat = ppr_intcvs;

cmin = min(comb_mat(:));
cmax = max(comb_mat(:));

comb_mat(1:2, 3:6, :, :) = cmin;

clims = [cmin cmax];
figure(21); clf;
d = 0;
for Ui=1:n_U
    for fi=1:n_f
        d = d + 1;
        ax = subplot(n_U, n_f, d);
        pd = squeeze(comb_mat(:, :, Ui, fi));
        imagesc_cb(pd, ax, 'Reds', clims);
        if Ui == n_U
            xticks(1:n_td);
            xticklabels(td_vals);
            set(gca,'Yticklabel',[]) 
            xlabel('tau-dep');
        elseif fi == 1
            yticks(1:n_tf);
            yticklabels(tf_vals);
            set(gca,'Xticklabel',[])
            ylabel('tau-fac');
        else
            set(gca,'Yticklabel',[]) 
            set(gca,'Xticklabel',[])
        end
        supi = ['U=', num2str(U_vals(Ui)), ' f=', num2str(f_vals(fi))];
        title(supi);
    end
end

%% which parameters have a large difference betweeen EPSP for the first
% and second interval *and* a large EPSP for the first interval
% this optimizes the inhibitory neuron

epsp_diffs = squeeze(all_psp2(1, :, :, :, :) - all_psp2(2, :, :, :, :));
firstint_epsps = squeeze(all_psp2(1, :, :, :, :));

comb_mat2 = epsp_diffs .* firstint_epsps;

cmin = min(comb_mat2(:));
cmax = max(comb_mat2(:));

comb_mat2(1:2, 3:6, :, :) = cmin;

clims = [cmin cmax];
figure(22); clf;
d = 0;
for Ui=1:n_U
    for fi=1:n_f
        d = d + 1;
        ax = subplot(n_U, n_f, d);
        pd = squeeze(comb_mat2(:, :, Ui, fi));
        imagesc_cb(pd, ax, 'Reds', clims);
        if Ui == n_U
            xticks(1:n_td);
            xticklabels(td_vals);
            set(gca,'Yticklabel',[]) 
            xlabel('tau-dep');
        elseif fi == 1
            yticks(1:n_tf);
            yticklabels(tf_vals);
            set(gca,'Xticklabel',[])
            ylabel('tau-fac');
        else
            set(gca,'Yticklabel',[]) 
            set(gca,'Xticklabel',[])
        end
        supi = ['U=', num2str(U_vals(Ui)), ' f=', num2str(f_vals(fi))];
        title(supi);
    end
end


%% adjacent interval PSP size ratios

adjint_ratios = all_psp2(1:4, :, :, :, :) ./ all_psp2(2:5, :, :, :, :);
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
        if Ui == n_U
            xticks(1:n_td);
            xticklabels(td_vals);
            set(gca,'Yticklabel',[]) 
            xlabel('tau-dep');
        elseif fi == 1
            yticks(1:n_tf);
            yticklabels(tf_vals);
            set(gca,'Xticklabel',[])
            ylabel('tau-fac');
        else
            set(gca,'Yticklabel',[]) 
            set(gca,'Xticklabel',[])
        end
        supi = ['U=', num2str(U_vals(Ui)), ' f=', num2str(f_vals(fi))];
        title(supi);
    end
end

%% lower vs. upper interval PPR variance

ppr_intcvs_exc = squeeze(std(all_ppr(2:5, :, :, :, :), 0, 1) ./ mean(all_ppr(2:5, :, :, :, :), 1));
ppr_intcvs_inh = squeeze(std(all_ppr(1:4, :, :, :, :), 0, 1) ./ mean(all_ppr(1:4, :, :, :, :), 1));

% optim_mat = ppr_intcvs_exc .* ppr_intcvs_inh;

cmin = min(ppr_intcvs_exc(:));
cmax = max(ppr_intcvs_exc(:));
clims = [cmin cmax];
figure(24); clf;
d = 0;
for Ui=1:n_U
    for fi=1:n_f
        d = d + 1;
        ax = subplot(n_U, n_f, d);
        pd = squeeze(ppr_intcvs_exc(:, :, Ui, fi));
        imagesc_cb(pd, ax, 'Greens', clims);
        if Ui == n_U
            xticks(1:n_td);
            xticklabels(td_vals);
            set(gca,'Yticklabel',[]) 
            xlabel('tau-dep');
        elseif fi == 1
            yticks(1:n_tf);
            yticklabels(tf_vals);
            set(gca,'Xticklabel',[])
            ylabel('tau-fac');
        else
            set(gca,'Yticklabel',[]) 
            set(gca,'Xticklabel',[])
        end
        supi = ['U=', num2str(U_vals(Ui)), ' f=', num2str(f_vals(fi))];
        title(supi);
    end
end

cmin = min(ppr_intcvs_inh(:));
cmax = max(ppr_intcvs_inh(:));
clims = [cmin cmax];
figure(25); clf;
d = 0;
for Ui=1:n_U
    for fi=1:n_f
        d = d + 1;
        ax = subplot(n_U, n_f, d);
        pd = squeeze(ppr_intcvs_inh(:, :, Ui, fi));
        imagesc_cb(pd, ax, 'Reds', clims);
        if Ui == n_U
            xticks(1:n_td);
            xticklabels(td_vals);
            set(gca,'Yticklabel',[]) 
            xlabel('tau-dep');
        elseif fi == 1
            yticks(1:n_tf);
            yticklabels(tf_vals);
            set(gca,'Xticklabel',[])
            ylabel('tau-fac');
        else
            set(gca,'Yticklabel',[]) 
            set(gca,'Xticklabel',[])
        end
        supi = ['U=', num2str(U_vals(Ui)), ' f=', num2str(f_vals(fi))];
        title(supi);
    end
end

%% diffs

ppr_diffs = diff(all_ppr, 1, 1);

ppr_intdiffcvs_exc = squeeze(std(ppr_diffs(2:4, :, :, :, :), 0, 1) ./ mean(ppr_diffs(2:4, :, :, :, :), 1));
ppr_intdiffcvs_inh = squeeze(std(ppr_diffs(1:3, :, :, :, :), 0, 1) ./ mean(ppr_diffs(1:3, :, :, :, :), 1));

%% plot linear fit results

figure(31); clf;
cmin = min(r2exc_all(:));
cmax = max(r2exc_all(:));
clims = [cmin cmax];
d = 0;
for Ui=1:n_U
    for fi=1:n_f
        d = d + 1;
        ax = subplot(n_U, n_f, d);
        pd = squeeze(r2exc_all(:, :, Ui, fi));
        imagesc_cb(pd, ax, 'Greens', clims);
        if Ui == n_U
            xticks(1:n_td);
            xticklabels(td_vals);
            set(gca,'Yticklabel',[]) 
            xlabel('tau-dep');
        elseif fi == 1
            yticks(1:n_tf);
            yticklabels(tf_vals);
            set(gca,'Xticklabel',[])
            ylabel('tau-fac');
        else
            set(gca,'Yticklabel',[]) 
            set(gca,'Xticklabel',[])
        end
        supi = ['U=', num2str(U_vals(Ui)), ' f=', num2str(f_vals(fi))];
        title(supi);
    end
end
suptitle('R^2 across upper intervals');

figure(32); clf;
cmin = min(bexc_all(:));
cmax = max(bexc_all(:));
clims = [cmin cmax];
d = 0;
for Ui=1:n_U
    for fi=1:n_f
        d = d + 1;
        ax = subplot(n_U, n_f, d);
        pd = squeeze(bexc_all(:, :, Ui, fi));
        imagesc_cb(pd, ax, '*Greens', clims);
        if Ui == n_U
            xticks(1:n_td);
            xticklabels(td_vals);
            set(gca,'Yticklabel',[]) 
            xlabel('tau-dep');
        elseif fi == 1
            yticks(1:n_tf);
            yticklabels(tf_vals);
            set(gca,'Xticklabel',[])
            ylabel('tau-fac');
        else
            set(gca,'Yticklabel',[]) 
            set(gca,'Xticklabel',[])
        end
        supi = ['U=', num2str(U_vals(Ui)), ' f=', num2str(f_vals(fi))];
        title(supi);
    end
end
suptitle('Slope across upper intervals');

figure(33); clf;
cmin = min(r2inh_all(:));
cmax = max(r2inh_all(:));
clims = [cmin cmax];
d = 0;
for Ui=1:n_U
    for fi=1:n_f
        d = d + 1;
        ax = subplot(n_U, n_f, d);
        pd = squeeze(r2inh_all(:, :, Ui, fi));
        imagesc_cb(pd, ax, 'Reds', clims);
        if Ui == n_U
            xticks(1:n_td);
            xticklabels(td_vals);
            set(gca,'Yticklabel',[]) 
            xlabel('tau-dep');
        elseif fi == 1
            yticks(1:n_tf);
            yticklabels(tf_vals);
            set(gca,'Xticklabel',[])
            ylabel('tau-fac');
        else
            set(gca,'Yticklabel',[]) 
            set(gca,'Xticklabel',[])
        end
        supi = ['U=', num2str(U_vals(Ui)), ' f=', num2str(f_vals(fi))];
        title(supi);
    end
end
suptitle('R^2 across lower intervals');

figure(34); clf;
cmin = min(binh_all(:));
cmax = max(binh_all(:));
clims = [cmin cmax];
d = 0;
for Ui=1:n_U
    for fi=1:n_f
        d = d + 1;
        ax = subplot(n_U, n_f, d);
        pd = squeeze(binh_all(:, :, Ui, fi));
        imagesc_cb(pd, ax, '*Reds', clims);
        if Ui == n_U
            xticks(1:n_td);
            xticklabels(td_vals);
            set(gca,'Yticklabel',[]) 
            xlabel('tau-dep');
        elseif fi == 1
            yticks(1:n_tf);
            yticklabels(tf_vals);
            set(gca,'Xticklabel',[])
            ylabel('tau-fac');
        else
            set(gca,'Yticklabel',[]) 
            set(gca,'Xticklabel',[])
        end
        supi = ['U=', num2str(U_vals(Ui)), ' f=', num2str(f_vals(fi))];
        title(supi);
    end
end
suptitle('Slope across lower intervals');

%% combining r^2 and slope


figure(41); clf;
cmin = min(r2exc_all(:));
cmax = max(r2exc_all(:));
clims = [cmin cmax];
d = 0;
for Ui=1:n_U
    for fi=1:n_f
        d = d + 1;
        ax = subplot(n_U, n_f, d);
        pd = squeeze(r2exc_all(:, :, Ui, fi));
        imagesc_cb(pd, ax, 'Greens', clims);
        if Ui == n_U
            xticks(1:n_td);
            xticklabels(td_vals);
            set(gca,'Yticklabel',[]) 
            xlabel('tau-dep');
        elseif fi == 1
            yticks(1:n_tf);
            yticklabels(tf_vals);
            set(gca,'Xticklabel',[])
            ylabel('tau-fac');
        else
            set(gca,'Yticklabel',[]) 
            set(gca,'Xticklabel',[])
        end
        supi = ['U=', num2str(U_vals(Ui)), ' f=', num2str(f_vals(fi))];
        title(supi);
    end
end
suptitle('R^2 across upper intervals');

figure(42); clf;
cmin = min(bexc_all(:));
cmax = max(bexc_all(:));
clims = [cmin cmax];
d = 0;
for Ui=1:n_U
    for fi=1:n_f
        d = d + 1;
        ax = subplot(n_U, n_f, d);
        pd = squeeze(bexc_all(:, :, Ui, fi));
        imagesc_cb(pd, ax, '*Greens', clims);
        if Ui == n_U
            xticks(1:n_td);
            xticklabels(td_vals);
            set(gca,'Yticklabel',[]) 
            xlabel('tau-dep');
        elseif fi == 1
            yticks(1:n_tf);
            yticklabels(tf_vals);
            set(gca,'Xticklabel',[])
            ylabel('tau-fac');
        else
            set(gca,'Yticklabel',[]) 
            set(gca,'Xticklabel',[])
        end
        supi = ['U=', num2str(U_vals(Ui)), ' f=', num2str(f_vals(fi))];
        title(supi);
    end
end
suptitle('Slope across upper intervals');

figure(33); clf;
cmin = min(r2inh_all(:));
cmax = max(r2inh_all(:));
clims = [cmin cmax];
d = 0;
for Ui=1:n_U
    for fi=1:n_f
        d = d + 1;
        ax = subplot(n_U, n_f, d);
        pd = squeeze(r2inh_all(:, :, Ui, fi));
        imagesc_cb(pd, ax, 'Reds', clims);
        if Ui == n_U
            xticks(1:n_td);
            xticklabels(td_vals);
            set(gca,'Yticklabel',[]) 
            xlabel('tau-dep');
        elseif fi == 1
            yticks(1:n_tf);
            yticklabels(tf_vals);
            set(gca,'Xticklabel',[])
            ylabel('tau-fac');
        else
            set(gca,'Yticklabel',[]) 
            set(gca,'Xticklabel',[])
        end
        supi = ['U=', num2str(U_vals(Ui)), ' f=', num2str(f_vals(fi))];
        title(supi);
    end
end
suptitle('R^2 across lower intervals');

figure(34); clf;
cmin = min(binh_all(:));
cmax = max(binh_all(:));
clims = [cmin cmax];
d = 0;
for Ui=1:n_U
    for fi=1:n_f
        d = d + 1;
        ax = subplot(n_U, n_f, d);
        pd = squeeze(binh_all(:, :, Ui, fi));
        imagesc_cb(pd, ax, '*Reds', clims);
        if Ui == n_U
            xticks(1:n_td);
            xticklabels(td_vals);
            set(gca,'Yticklabel',[]) 
            xlabel('tau-dep');
        elseif fi == 1
            yticks(1:n_tf);
            yticklabels(tf_vals);
            set(gca,'Xticklabel',[])
            ylabel('tau-fac');
        else
            set(gca,'Yticklabel',[]) 
            set(gca,'Xticklabel',[])
        end
        supi = ['U=', num2str(U_vals(Ui)), ' f=', num2str(f_vals(fi))];
        title(supi);
    end
end
suptitle('Slope across lower intervals');


