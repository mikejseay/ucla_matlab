function [V, RELEASE] = IAF_STP(t, spiketimes, u, tfac, tdep, in)

% [V R]=IAF_STP(1:500,[100 200],U,tfac,trec,(1:500)*0);
% Self-Contained function to Study the Markram/Tsodyks Model

% t: time vector in ms
% spiketimes: spike times in ms
% u: Utilization constant (how much is released)
% tfac: time constant of facilitation
% tdep: time constant of depression
% in = injected current (vector size t)
% EXAMPLE:
% Iin=zeros(1,2000); Iin(1000:1100)=0.06;
% [V p]=IAF_STP(1:2000,100:100:1000,0.15,270,6,Iin);
% u is essentially used for faciliation
% if u is constant e.g. tfac = 0.00001 then only synaptic depression
% dR/dt = (1-R)/trec ?
% u, I think is bounded between U and 1 (small values of U will help facilitation)

%%% CONSTANTS %%%
tau = 5; % membrane time constant
SpikeAmp = 4;
Iin = zeros(1, length(t)) + in;
%U=0.75; tfac=100; trec = 5;

%%% VARIABLES %%%
r = 1;
% uP = u; RP = 1; % potential values
lastspike = -9e10;
v = 0;

RELEASE(1, 2) = r * u;
RELEASE(1, 3) = u;
RELEASE(1, 4) = r;

V = zeros(1, length(t));
for t = 2:length(t)
    
    spike = find(t == spiketimes);
    if (~isempty(spike))
        SPIKE = 1;
    else
        SPIKE = 0;
    end;
    ipi = t - lastspike; % inter-peak interval
    RELEASE(t, 1) = 0;
    
    %%% POTENTIAL STENGTH AT ALL TIMES
    RP = r * (1 - u) * exp(-ipi/tdep) + 1 - exp(-ipi/tdep);
    uP = u * (exp(-ipi/tfac)) + u * (1 - u * exp(-ipi/tfac));
    RELEASE(t, 2) = RP * uP;
    RELEASE(t, 3) = uP; % "FACILITATION"
    RELEASE(t, 4) = RP; % "DEPRESSION"
    
    %%% ACTUAL STRENGTH AT SPIKES
    if SPIKE == 1
        r = r * (1 - u) * exp(-ipi/tdep) + 1 - exp(-ipi/tdep);
        u = u * (exp(-ipi/tfac)) + u * (1 - u * exp(-ipi/tfac));
        RELEASE(t, 1) = r * u;
    end
    
    %fprintf('t=%5d IPI=%5d  u=%5.2f   R=%5.2f lastspike=%5.2f\n',t,ipi,u,R,lastspike);
    if (~isempty(spike))
        lastspike = spiketimes(spike);
    end
    
    if (V(t-1) == SpikeAmp)
        V(t) = 0;
    else
%         t
        V(t) = v - v / tau + RELEASE(t, 1) + Iin(t);
        if (V(t) > 1), V(t) = SpikeAmp; end;
    end
    v = V(t);
end
if (1)
    cla
    %plot(RELEASE(:,1),'linewidth',[2])
    plot(RELEASE(:, 2), 'c')
    plot(RELEASE(:, 3), 'g')
    plot(RELEASE(:, 4), 'r')
    plot(V, 'k', 'linewidth', [3])
end
