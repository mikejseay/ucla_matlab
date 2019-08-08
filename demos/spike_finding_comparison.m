DO_PLOT = false;

load('example_currentClamp_recording.mat')
spikeTimesM = find_spikes2(data, -10);
spikeTimesA = locate_spikes(data, -10);
spikeTimesA2 = locate_spikes2(data, -10);

if DO_PLOT
    figure; clf;
    plot(data);
    hold on;
    scatter(spikeTimesM, data(spikeTimesM));
    scatter(spikeTimesA, data(spikeTimesA));
    discordantInd = find(ismember(spikeTimesM, spikeTimesA) == 0);
    figure; clf; plot(data); hold on; scatter(spikeTimesM(discordantInd), data(spikeTimesM(discordantInd)));
end