% mfilename refers to the current mfile's name

fprintf('This file is called %s.m\n', mfilename);

% looking at the (already) trained weights for the Handwriting example

load W_Handwriting.mat

[nNeurons, nInputs] = size(WInEx);
nOutputs = size(WExOut, 2);

% WInEx -- nNeurons x nInputs matrix
% element (n, i) is the weight between neuron n and input i

% WExEx -- the RRN proper, which is a (sparse) square matrix in which
% value (n1, n2) specifies the connection weight between neurons n1 and n2

% WExOut -- nNeurons x nOutputs matrix
% element (n, o) is the weight between neuron n and output o

% visualizing weights
% input --> neurons
% imagesc_cb(WInEx);

% neuron --> neuron
figure;
imagesc_cb(WExEx);

% neuron --> output
% imagesc_cb(WExOut);

%% sorting WExEx?

WExEx_avg = mean(WExEx, 1)';
[WExEx_avgsort, order] = sort(WExEx_avg);
WExEx_sort = WExEx(order, :);

%% graph representation

% WExEx_plot = WExEx_sort;
% WExEx_plot = WExEx;
WExEx_plot = abs(WExEx);

WExEx_G = digraph(WExEx_plot);
% WExEx_G = digraph(abs(WExEx));
wExEx_G_Weight = WExEx_G.Edges.Weight;
wExEx_G_WeightNorm = wExEx_G_Weight / max(abs(wExEx_G_Weight));
% wExEx_G_WeightNorm = 3.5 * wExEx_G_WeightNorm; % re-scale
% wExEx_G_WeightNorm = exp(wExEx_G_WeightNorm)./(1+exp(wExEx_G_WeightNorm));  %logistic

graphLayouts = {'force', 'circle', 'subspace'};
nGraphLayouts = length(graphLayouts);

cmap = brewermap(64, 'Reds');
% cmap = brewermap(64, 'RdBu');

for gl = 1:nGraphLayouts
    f = figure('InnerPosition', [100, 100, 820, 800]);
%     p = plot(WExEx_G, 'EdgeAlpha', 0.01, 'Layout', graphLayouts{gl});
%     p = plot(WExEx_G, 'EdgeAlpha', 0.01, 'Layout', graphLayouts{gl}, ...
%         );
    p = plot(WExEx_G, 'EdgeAlpha', 0.05, 'Layout', graphLayouts{gl}, ...
        'EdgeCData', wExEx_G_WeightNorm, 'Marker', '.', 'MarkerSize', 1, ...
        'NodeColor', 'r');
%     p = plot(WExEx_G, 'LineWidth', wExEx_G_WeightNorm, 'EdgeAlpha', 0.01, 'Layout', graphLayouts{gl});
    colormap(cmap);
    axis_shrink(p);
    axis off
    fig_name = ['RRN_graph', graphLayouts{gl}, '.tif'];
%     saveas(f, fig_name);
end

%% scratch for above

%layered is extremely slow

figure;
plot(WExEx_G, 'EdgeAlpha', 0.05, 'Layout', 'force3');

figure;
plot(WExEx_G, 'EdgeAlpha', 0.05, 'Layout', 'subspace3');

figure;
plot(WExEx_G, 'OmitSelfLoops');

figure;
plot(WExEx_G, 'NodeLabel', {});

figure;
weightScale = 5;
lineWidths = weightScale * wExEx_G_Weight / max(wExEx_G_Weight);
plot(WExEx_G, 'LineWidth', lineWidths);

%% histogram of weights

WExEx_flatn0 = WExEx(:); % flatten
WExEx_flatn0 = WExEx_flatn0(WExEx_flatn0 ~= 0); %remove zeros
WExEx_flatn0 = WExEx_flatn0 / max(abs(WExEx_flatn0)); % normalize
WExEx_flatn0 = 3.5 * WExEx_flatn0; % re-scale
WExEx_flatn0 = exp(WExEx_flatn0)./(1+exp(WExEx_flatn0));  %logistic

f = figure_square;
h = histogram(WExEx_flatn0);
% set(gca, 'YScale', 'log');
