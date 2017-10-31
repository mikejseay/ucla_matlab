% SIMPLE MARKRAM-TSODYKS STP DEMO
% USES IAF_STP.m

% init vals
U_init = 0.25;
tFac_init = 100;
tRec_init = 20;

firing_type = 'poisson'; % set, regular, poisson

% how to set initial spike times
switch firing_type
    case 'set'
        % set times
        spikeTimes_init = [50:25:150 200:50:300];
        
    case 'regular'
        % regular firing
        fr = 10;
        init_spiketime = 100;
        fs = 1000;
        t_end = 1000;
        spikeTimes_init = init_spiketime:(fs/fr):t_end;
        
    case 'poisson'
        % Poisson spikes
        fr = 10;
        t_end = 1000;
        fs = 1000;
        t = 1:t_end;
        
        tmp_unif = rand(1, t_end);
        spikeTimes_init1 = find(tmp_unif < (fr / fs));
        close_spikes = [false diff(spikeTimes_init1) < 10];
        spikeTimes_init = spikeTimes_init1;
        spikeTimes_init(close_spikes) = [];
end

%%

close all
figure
set(gcf, 'units', 'normal', 'position', [0.005, 0.04, 0.9, 0.8])
SP1 = subplot(2, 1, 1);
set(SP1, 'position', [0.1, 0.1, 0.8, 0.6])
hold on

callback_str = ['IAF_STP(1:max(str2num(get(P4, ''string'')))+100,', ...
    'str2num(get(P4, ''string'')), str2num(get(P1, ''string'')),', ...
    'str2num(get(P2, ''string'')), str2num(get(P3, ''string'')), 0);'];
% IAF_STP(1:max(str2num(get(P4, 'string')))+100, str2num(get(P4, 'string')), str2num(get(P1, 'string')), str2num(get(P2, 'string')), str2num(get(P3, 'string')), 0);

%%% INTERACTIVE GRAPHICS
button1 = uicontrol('units', 'normal', 'style', 'pushbutton', 'fontsize', 14, ...
    'fontweight', 'bold', 'String', 'RUN', 'position', [0.1, 0.8, 0.12, 0.08], ...
    'Callback', callback_str);
% resetbutton = uicontrol('units', 'normal', 'style', 'pushbutton', 'String', 'RESET', 'position', [0.05, 0.05, 0.1, 0.08], 'Callback', 'XOR_demo;');

%Parameters
P1 = uicontrol('units', 'normal', 'style', 'edit', 'String', num2str(U_init), 'position', [0.25, 0.8, 0.07, 0.05]);
P2 = uicontrol('units', 'normal', 'style', 'edit', 'String', num2str(tFac_init), 'position', [0.4, 0.8, 0.07, 0.05]);
P3 = uicontrol('units', 'normal', 'style', 'edit', 'String', num2str(tRec_init), 'position', [0.55, 0.8, 0.07, 0.05]);
P4 = uicontrol('units', 'normal', 'style', 'edit', 'String', num2str(spikeTimes_init), 'position', [0.7, 0.8, 0.12, 0.05]);

%Text labels for Parameters
T1 = uicontrol('units', 'normal', 'style', 'text', 'String', 'U_init', ...
    'fontsize', [10], 'foregroundcolor', 'k', ...
    'fontweight', 'bold', 'position', [0.25, 0.87, 0.07, 0.04]);
T2 = uicontrol('units', 'normal', 'style', 'text', 'String', 'tFac', ...
    'fontsize', [10], 'foregroundcolor', 'k', ...
    'fontweight', 'bold', 'position', [0.4, 0.87, 0.07, 0.04]);
T3 = uicontrol('units', 'normal', 'style', 'text', 'String', 'tRec', ...
    'fontsize', [10], 'foregroundcolor', 'k', ...
    'fontweight', 'bold', 'position', [0.55, 0.87, 0.07, 0.04]);
T4 = uicontrol('units', 'normal', 'style', 'text', 'String', 'Spike Times', ...
    'fontsize', [10], 'foregroundcolor', 'k', ...
    'fontweight', 'bold', 'position', [0.7, 0.87, 0.12, 0.04]);

%LEGENDS
L1 = uicontrol('units', 'normal', 'style', 'text', 'String', 'Presyn. Potential I', ...
    'fontsize', [14], 'foregroundcolor', 'c', ...
    'fontweight', 'bold', 'position', [0.55, 0.7, 0.14, 0.04]);
L2 = uicontrol('units', 'normal', 'style', 'text', 'String', 'U - Util. (Release Prob.)', ...
    'fontsize', [14], 'foregroundcolor', 'g', ...
    'fontweight', 'bold', 'position', [0.25, 0.7, 0.14, 0.04]);
L3 = uicontrol('units', 'normal', 'style', 'text', 'String', 'R - Resources', ...
    'fontsize', [14], 'foregroundcolor', 'r', ...
    'fontweight', 'bold', 'position', [0.4, 0.7, 0.14, 0.04]);
L4 = uicontrol('units', 'normal', 'style', 'text', 'String', 'Postsyn. V', ...
    'fontsize', [14], 'foregroundcolor', 'k', ...
    'fontweight', 'bold', 'position', [0.7, 0.7, 0.14, 0.04]);

