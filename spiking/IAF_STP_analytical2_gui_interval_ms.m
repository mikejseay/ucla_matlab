function IAF_STP_analytical2_gui_interval_ms(t, spiketimes, trec, tfac, U, f, in)
% Self-Contained function to Study the Markram/Tsodyks Model

% t: time vector in ms
% spiketimes: spike times in ms
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

% initialize the "potential value" variables
uP = u;
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
        
        r = 1 - (1 - r * (1 - u)) * exp(-ipi/trec);
        
        % change in utilization following spike
        % eqn 2.3 from Tsodyks et al. (1998)
        u = U + (u + f * (1 - u) - U) * exp(-ipi / tfac);
%         u = u - u / tfac + U * (1 - u);  % corresponding difference equation

%         r = 1 + exp(-ipi/trec) * (r * (1 - u) - 1);

        % the presynaptic maximal current will be their product
%         presyni(t) = r * u;
        curr = curr - curr / tau + u * r;
        
        % change in resources following spike
        % solved version of second differential equation in (1) of
        % http://www.scholarpedia.org/article/Short-term_synaptic_plasticity
%         r = 1 + exp(-ipi/trec) * (r * (1 - u) - 1);
%         r = r + (1 - r) / trec - u * r;  % corresponding difference equation
        
        
        % the presynaptic maximal current will be their product
%         presyni(t) = r * u;
        
        % update lastspike to be the new spike time
        lastspike = spiketimes(spike);
        
        % record values
        util(t) = u;
        resources(t) = r;
        produc(t) = curr;
        
        % assign current values of u and r to new variables so that their potential
        % values can be calculated
        uP = u;
        rP = r;
    
    % if not spiking, u and r simply decay in an exponential fashion
    else
%         u = u - u / tfac;
        rP = 1 - (1 - r * (1 - u)) * exp(-ipi/trec);
        uP = U + (u + f * (1 - u) - U) * exp(-ipi / tfac);
        curr = curr - curr / tau;  % notice that u and r do not influence this
        
%         r = r + (1 - r) / trec;
        presyni(t) = 0;
        
        % record values
        util(t) = uP;
        resources(t) = rP;
        produc(t) = curr;
    
    end
    
    
    v = v - v / tau + curr + Iin(t);
    V(t) = v;
    
%     fprintf('t=%3d, IPI=%3d, u=%.2f, R=%.2f, lastspk=%d, V=%.2f\n', ...
%              t, ipi, uP, rP, lastspike, v);
    fprintf('t=%3d, IPI=%3d, u=%.2f, R=%.2f, lastspk=%d, V=%.2f\n', ...
             t, ipi, u, r, lastspike, v);
end
if do_plot
    V(circshift(V < .0001, -1)) = NaN;
    plot(V, 'LineWidth', 2)
    hold on;
    xlabel('Time (ms)');
end
