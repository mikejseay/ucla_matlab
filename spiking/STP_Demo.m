% SIMPLE MARKRAM-TSODYKS STP DEMO
% USES IAF_STP.m

% init vals
U_init = 0.25;
tFac_init = 100;
tDep_init = 20;
spikeTimes_init = [50:25:150 200:50:300];

%%

close all
figure
set(gcf, 'units', 'normal', 'position', [0.005, 0.04, 0.9, 0.8])
SP1 = subplot(2, 1, 1);
set(SP1, 'position', [0.1, 0.1, 0.8, 0.6])
hold on

callback_str = ['[V, RELEASE] = IAF_STP(1:max(str2num(get(P4, ''string'')))+100,', ...
    'str2num(get(P4, ''string'')), str2num(get(P1, ''string'')),', ...
    'str2num(get(P2, ''string'')), str2num(get(P3, ''string'')), 0);'];
% [V, RELEASE] = IAF_STP(1:max(str2num(get(P4, 'string')))+100, str2num(get(P4, 'string')), str2num(get(P1, 'string')), str2num(get(P2, 'string')), str2num(get(P3, 'string')), 0);

%%% INTERACTIVE GRAPHICS
button1 = uicontrol('units', 'normal', 'style', 'pushbutton', 'fontsize', 14, ...
    'fontweight', 'bold', 'String', 'RUN', 'position', [0.1, 0.8, 0.12, 0.08], ...
    'Callback', callback_str);
% resetbutton = uicontrol('units', 'normal', 'style', 'pushbutton', 'String', 'RESET', 'position', [0.05, 0.05, 0.1, 0.08], 'Callback', 'XOR_demo;');

%Parameters
P1 = uicontrol('units', 'normal', 'style', 'edit', 'String', num2str(U_init), 'position', [0.25, 0.8, 0.07, 0.05]);
P2 = uicontrol('units', 'normal', 'style', 'edit', 'String', num2str(tFac_init), 'position', [0.4, 0.8, 0.07, 0.05]);
P3 = uicontrol('units', 'normal', 'style', 'edit', 'String', num2str(tDep_init), 'position', [0.55, 0.8, 0.07, 0.05]);
P4 = uicontrol('units', 'normal', 'style', 'edit', 'String', num2str(spikeTimes_init), 'position', [0.7, 0.8, 0.12, 0.05]);

%Text labels for Parameters
T1 = uicontrol('units', 'normal', 'style', 'text', 'String', 'U(''Pr'')', 'fontsize', [10], 'foregroundcolor', 'c', 'fontweight', 'bold', 'position', [0.25, 0.87, 0.07, 0.04]);
T2 = uicontrol('units', 'normal', 'style', 'text', 'String', 'tFac', 'fontsize', [10], 'foregroundcolor', 'g', 'fontweight', 'bold', 'position', [0.4, 0.87, 0.07, 0.04]);
T3 = uicontrol('units', 'normal', 'style', 'text', 'String', 'tRec', 'fontsize', [10], 'foregroundcolor', 'r', 'fontweight', 'bold', 'position', [0.55, 0.87, 0.07, 0.04]);
T4 = uicontrol('units', 'normal', 'style', 'text', 'String', 'Spike Times', 'fontsize', [10], 'foregroundcolor', 'k', 'fontweight', 'bold', 'position', [0.7, 0.87, 0.12, 0.04]);

%LEGENDS
L1 = uicontrol('units', 'normal', 'style', 'text', 'String', 'F*D', 'fontsize', [14], 'foregroundcolor', 'c', 'fontweight', 'bold', 'position', [0.25, 0.7, 0.07, 0.04]);
L2 = uicontrol('units', 'normal', 'style', 'text', 'String', 'F', 'fontsize', [14], 'foregroundcolor', 'g', 'fontweight', 'bold', 'position', [0.4, 0.7, 0.07, 0.04]);
L3 = uicontrol('units', 'normal', 'style', 'text', 'String', 'D', 'fontsize', [14], 'foregroundcolor', 'r', 'fontweight', 'bold', 'position', [0.55, 0.7, 0.07, 0.04]);
