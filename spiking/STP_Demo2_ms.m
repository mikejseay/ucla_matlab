% SIMPLE MARKRAM-TSODYKS STP DEMO
% USES IAF_STP.m

% init vals
global tRec_init;
global tFac_init;
global U_init;
global f_init;

firing_type = 'set'; % set, regular, poisson
stp_regime = 'strong depression';

% how to set initial spike times
switch firing_type
    case 'set'
        % set times
        spikeTimes_init = [50:25:150 200:50:300];
        
    case 'regular'
        % regular firing
        fr = 50;
        init_spiketime = 100;
        fs = 1000;
        t_end = 1000;
        spikeTimes_init = init_spiketime:(fs/fr):t_end;
        
    case 'poisson'
        % Poisson spikes
        fr = 8;
        t_end = 1000;
        fs = 1000;
        t = 1:t_end;
        
        tmp_unif = rand(1, t_end);
        spikeTimes_init1 = find(tmp_unif < (fr / fs));
        close_spikes = [false diff(spikeTimes_init1) < 10];
        spikeTimes_init = spikeTimes_init1;
        spikeTimes_init(close_spikes) = [];
end

[tRec_init, tFac_init, U_init, f_init] = set_regime(stp_regime);

%%

close all
figure
set(gcf, 'units', 'normal', 'position', [0.005, 0.04, 0.9, 0.8])
SP1 = subplot(2, 1, 1);
set(SP1, 'position', [0.1, 0.1, 0.8, 0.6])
hold on

callback_str = ['IAF_STP_analytical2_ms(1:max(str2num(get(P5, ''string'')))+100,', ...
    'str2num(get(P5, ''string'')), str2num(get(P1, ''string'')),', ...
    'str2num(get(P2, ''string'')), str2num(get(P3, ''string'')),', ...
    'str2num(get(P4, ''string'')), 0);'];
% IAF_STP(1:max(str2num(get(P4, 'string')))+100, str2num(get(P4, 'string')), str2num(get(P1, 'string')), str2num(get(P2, 'string')), str2num(get(P3, 'string')), 0);

%%% INTERACTIVE GRAPHICS
button1 = uicontrol('units', 'normal', 'style', 'pushbutton', 'fontsize', 14, ...
    'fontweight', 'bold', 'String', 'RUN', 'position', [0.05, 0.9, 0.08, 0.08], ...
    'Callback', callback_str);

regime_list = {'strong depression', 'depression', 'facilitation-depression', ...
    'facilitation', 'strong facilitation'};

button2 = uicontrol('units', 'normal', 'style', 'popup', 'fontsize', 14, ...
    'fontweight', 'bold', 'String', regime_list, 'position', [0.3, 0.9, 0.08, 0.08], ...
    'Callback', @regime_popup_cb);
% resetbutton = uicontrol('units', 'normal', 'style', 'pushbutton', 'String', 'RESET', 'position', [0.05, 0.05, 0.1, 0.08], 'Callback', 'XOR_demo;');

%GUI item positions
param_x = linspace(.15, .75, 5);
label_y = 0.85;
label_height = 0.02;

%Parameters
P1 = uicontrol('units', 'normal', 'style', 'edit', 'String', num2str(tRec_init), 'position', [param_x(1), 0.8, 0.07, 0.05]);
P2 = uicontrol('units', 'normal', 'style', 'edit', 'String', num2str(tFac_init), 'position', [param_x(2), 0.8, 0.07, 0.05]);
P3 = uicontrol('units', 'normal', 'style', 'edit', 'String', num2str(U_init), 'position', [param_x(3), 0.8, 0.07, 0.05]);
P4 = uicontrol('units', 'normal', 'style', 'edit', 'String', num2str(f_init), 'position', [param_x(4), 0.8, 0.12, 0.05]);
P5 = uicontrol('units', 'normal', 'style', 'edit', 'String', num2str(spikeTimes_init), 'position', [param_x(5), 0.8, 0.12, 0.05]);

%Text labels for Parameters
T1 = uicontrol('units', 'normal', 'style', 'text', 'String', 'tRec', ...
    'fontsize', [10], 'foregroundcolor', 'k', ...
    'fontweight', 'bold', 'position', [param_x(1), label_y, 0.07, label_height]);
T2 = uicontrol('units', 'normal', 'style', 'text', 'String', 'tFac', ...
    'fontsize', [10], 'foregroundcolor', 'k', ...
    'fontweight', 'bold', 'position', [param_x(2), label_y, 0.07, label_height]);
T3 = uicontrol('units', 'normal', 'style', 'text', 'String', 'U', ...
    'fontsize', [10], 'foregroundcolor', 'k', ...
    'fontweight', 'bold', 'position', [param_x(3), label_y, 0.07, label_height]);
T4 = uicontrol('units', 'normal', 'style', 'text', 'String', 'f', ...
    'fontsize', [10], 'foregroundcolor', 'k', ...
    'fontweight', 'bold', 'position', [param_x(4), label_y, 0.12, label_height]);
T5 = uicontrol('units', 'normal', 'style', 'text', 'String', 'Spike Times', ...
    'fontsize', [10], 'foregroundcolor', 'k', ...
    'fontweight', 'bold', 'position', [param_x(5), label_y, 0.12, label_height]);

%LEGENDS
L1 = uicontrol('units', 'normal', 'style', 'text', 'String', 'Presyn. Potential I', ...
    'fontsize', [14], 'foregroundcolor', 'c', ...
    'fontweight', 'bold', 'position', [0.5, 0.7, 0.18, 0.04]);
L2 = uicontrol('units', 'normal', 'style', 'text', 'String', 'U - Util. (Release Prob.)', ...
    'fontsize', [14], 'foregroundcolor', 'g', ...
    'fontweight', 'bold', 'position', [0.1, 0.7, 0.18, 0.04]);
L3 = uicontrol('units', 'normal', 'style', 'text', 'String', 'R - Resources', ...
    'fontsize', [14], 'foregroundcolor', 'r', ...
    'fontweight', 'bold', 'position', [0.3, 0.7, 0.18, 0.04]);
L4 = uicontrol('units', 'normal', 'style', 'text', 'String', 'Postsyn. V', ...
    'fontsize', [14], 'foregroundcolor', 'k', ...
    'fontweight', 'bold', 'position', [0.7, 0.7, 0.18, 0.04]);


function regime_popup_cb(hObject, eventdata, handles)
    gui_num = hObject.Value;
    regime_list = hObject.String;
    new_regime = regime_list{gui_num};
    [tRec_init, tFac_init, U_init, f_init] = set_regime(new_regime);
end

function [tRec_init, tFac_init, U_init, f_init] = set_regime(stp_regime)
    switch stp_regime
        case 'strong depression'
            tRec_init = 1700;
            tFac_init = 20;
            U_init = 0.7;
            f_init = 0.05;
        case 'depression'
            tRec_init = 500;
            tFac_init = 50;
            U_init = 0.5;
            f_init = 0.05;
        case 'facilitation-depression'
            tRec_init = 200;
            tFac_init = 200;
            U_init = 0.25;
            f_init = 0.3;
        case 'facilitation'
            tRec_init = 50;
            tFac_init = 500;
            U_init = 0.15;
            f_init = 0.15;
        case 'strong facilitation'
            tRec_init = 20;
            tFac_init = 1700;
            U_init = 0.1;
            f_init = 0.11;
    end
end

