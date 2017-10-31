function IAF_STP(t, spiketimes, u, tfac, trec, in)
% Self-Contained function to Study the Markram/Tsodyks Model

% t: time vector in ms
% spiketimes: spike times in ms
% u: util constant (how much is released)
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
Iin = zeros(1, length(t)) + in; 

%%% VARIABLES %%%
r = 1;                              % ?
lastspike = -9e10;                  % initial spike time (forever ago)
v = 0;                              % initial voltage, 0 so it can be plotted alongside other vars

% initialize time vectors
[V, presyni, util, resources, produc] = deal(zeros(1, length(t)));

% set initial values of time vectors
resources(1) = r;                   % synaptic resources
util(1) = u;                        % utilization level (release probability)
produc(1) = r * u;                  % product of the two above
% rP = r;

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
    uP = u + u * (1 - u) * exp(-ipi/tfac);
    rP = 1 + (r * (1 - u) - 1) * exp(-ipi/trec);
    urP = uP * rP;
    
    % record values
    util(t) = uP;
    resources(t) = rP;
    produc(t) = urP;
    
    % if spiking, actually change the R and U vals
    % NOTE: this means that r and u only change after spikes
    if SPIKE
        
        % change in utilization following spike
        % eqn 2.3 from Tsodyks et al. (1998)
        u = u + u * (1 - u) * exp(-ipi/tfac);
              
        % change in resources following spike
        % solved version of differential equation in (1) of
        % http://www.scholarpedia.org/article/Short-term_synaptic_plasticity
        r = 1 + (r * (1 - u) - 1) * exp(-ipi/trec);
        
        % the presynaptic current will be their product
        presyni(t) = r * u;
        
        % update lastspike to be the new spike time
        lastspike = spiketimes(spike);
        
    else
        presyni(t) = 0;
    end
    
    % calculate the postsynaptic potential
    if (V(t-1) == SpikeAmp)
        % if the previous time step was a spike, set v to 0 this time step
        % this does not get used
        v = 0;
    else
        % v evolves according to a classic different equation with two inputs:
        % 1.) presynaptic current (R * U)
        % 2.) input current (not really used here)
        v = v - v / tau + presyni(t) + Iin(t);
        if v > 1
            v = SpikeAmp;
        end
    end
    V(t) = v;
    
    fprintf('t=%3d, IPI=%3d, u=%.2f, R=%.2f, lastspk=%d, V=%.2f\n', ...
             t, ipi, uP, rP, lastspike, v);
end
if do_plot
    cla
    plot(produc, 'c')
    plot(util, 'g')
    plot(resources, 'r')
    plot(V, 'k', 'linewidth', [3])
    xlabel('Time (ms)');
end
