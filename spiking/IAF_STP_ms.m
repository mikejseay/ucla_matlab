function IAF_STP_ms(t, spiketimes, u_init, tfac, trec, in)
% Self-Contained function to Study the Markram/Tsodyks Model

% t: time vector in ms
% spiketimes: spike times in ms
% u_init: initial utilization
% U: maximum utilization increase
% tfac: time constant of facilitation
% trec: time constant of depression
% in = injected current (vector size t)

% EXAMPLE:

% Iin=zeros(1,2000); Iin(1000:1100)=0.06;
% [V p]=IAF_STP(1:2000,100:100:1000,0.15,270,6,Iin);
% u is essentially used for faciliation
% if u is constant e.g. tfac = 0.00001 then only synaptic depression
% dR/dt = (1-R)/trec ?
% u, I think is bounded between U and 1 (small values of U will help facilitation)

% U=0.75; tfac=100; trec = 5;

%%% CONSTANTS %%%
do_plot = true;
tau = 5;                            % membrane time constant
SpikeAmp = 2;                       % spike amplitude
U = u_init;                         % maximum utilization increase
% U = 0.1;
Iin = zeros(1, length(t)) + in; 

%%% VARIABLES %%%
r = 1;                              % ?
lastspike = -9e10;                  % initial spike time (forever ago)
v = 0;                              % initial voltage, 0 so it can be plotted alongside other vars

% initialize time vectors
[V, presyni, util, resources, produc] = deal(zeros(1, length(t)));

% set initial values of time vectors
resources(1) = r;                   % synaptic resources
u = 0;
curr = 0;
% u = U;
util(1) = u;                        % utilization level (release probability)
produc(1) = r * u;                  % product of the two above
rP = r;

for t = 2:length(t)
    
    % check if spiking
    spike = find(spiketimes == t);
    if ~isempty(spike)
        SPIKE = true;
    else
        SPIKE = false;
    end
    
    % time since last spike
    ipi = t - lastspike; % inter-pulse interval
    
    % calculate change in R and U
    % for more complete description, see below
%     uP = u + U * (1 - u) * exp(-ipi/tfac);
%     urP = uP * rP;
%     rP = 1 + (r * (1 - u) - 1) * exp(-ipi/trec);
%     urP = uP * rP;
    
    % record values
%     util(t) = uP;
%     resources(t) = rP;
%     produc(t) = urP;
    
    % if spiking, increment u and decrement r
    if SPIKE
        
        % change in utilization following spike
        % eqn 2.3 from Tsodyks et al. (1998)
%         u = u + U * (1 - u) * exp(-ipi/tfac);
        % u (lowercase, variable) represents the utilization.
        % initialized at 0. it can be
        % thought of as the amount of Ca2+ in the presynaptic terminal.
        % at a spike, u is incremented by a proportion U (uppercase, constant)
        % of the remaining "utilization space." this also prevents u from
        % ever going above 1
        % u decays to 0 with a time constant tfac... when tfac is small, u will
        % decay back to 0 very quickly (reflecting perhaps, faster Ca2+
        % clearance in the cell) whereas when tfac is large, u will be able
        % to "build up" Ca2+ given that the spike intervals are small
        % relative to tfac.
        u = u - u / tfac + U * (1 - u);
        % key: u is incremented by spike-unaffected u
        
        % the presynaptic maximal current will be their product
%         presyni(t) = r * u;
        % current represents the current (or current multiplier) caused by
        % the changes in STP.
        % at a spike, it is incremented by u+ times r-, that is, the
        % post-change utilization times the pre-change resources.
        % thus, at the first spike it can be at most 1 if U were 1
        curr = curr - curr / tau + u * r;
        % key: current is incremented by spike-affected u and
        % spike-unaffected r
        
        % change in resources following spike
        % solved version of second differential equation in (1) of
        % http://www.scholarpedia.org/article/Short-term_synaptic_plasticity
        % initialized at 1. can be thought of as the amount of
        % neurotransmitter available.
        % at a spike, r is decremented by the current multiplier value from
        % above.
        % r accumulates to 1 with a time constant trec... when trec is
        % large, r will take longer to replenish and thus become
        % "exhausted." when trec is small, r will replenish very quickly.
%         r = 1 + (r * (1 - u) - 1) * exp(-ipi/trec);
        r = r + (1 - r) / trec - u * r;
        % key: resources are decremented by spike-affected u and
        % spike-unaffected r
        
        
        % the presynaptic maximal current will be their product
%         presyni(t) = r * u;
        
        % update lastspike to be the new spike time
        lastspike = spiketimes(spike);
    
    % if not spiking, u and r simply decay in an exponential fashion
    else
        u = u - u / tfac;
        curr = curr - curr / tau;
        r = r + (1 - r) / trec;
        presyni(t) = 0;
    end
    
    % record values
    util(t) = u;
    resources(t) = r;
    produc(t) = curr;
    
    v = v - v / tau + curr + Iin(t);
    V(t) = v;
    
%     fprintf('t=%3d, IPI=%3d, u=%.2f, R=%.2f, lastspk=%d, V=%.2f\n', ...
%              t, ipi, uP, rP, lastspike, v);
    fprintf('t=%3d, IPI=%3d, u=%.2f, R=%.2f, lastspk=%d, V=%.2f\n', ...
             t, ipi, u, r, lastspike, v);
end
if do_plot
    cla
%     plot(produc, 'c', 'linewidth', 3)
    plot(produc, 'c')
%     plot(presyni, 'c')
    plot(util, 'g')
    plot(resources, 'r')
%     plot(V, 'k', 'linewidth', 3)
    plot(V, 'k')
    xlabel('Time (ms)');
end
