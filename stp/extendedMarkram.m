function STP = extendedMarkram(coef, spiketimes)

U = coef(1);
tfac = coef(2);
trec = coef(3);
f = coef(4);

%%% VARIABLES %%%
r = 1;
u = 0;

interSpikeIntervals = zeros(length(spiketimes), 1);
interSpikeIntervals(1) = Inf;
interSpikeIntervals(2:end) = diff(spiketimes); 

STP = zeros(1, length(spikeTimes));

for spikeInd = 1:length(interSpikeIntervals)
    ipi = interSpikeIntervals(spikeInd);
    r = 1 - (1 - r * (1 - u)) * exp(-ipi / trec);        
    u = U + (u + f * (1 - u) - U) * exp(-ipi / tfac);
    STP(spikeInd) = r * u;
end

STP = STP ./ STP(1);
end