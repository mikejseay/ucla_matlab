function plot_spikes(spike_times)

n_spikes = length(spike_times);

hold on;
for spike_ind = 1:n_spikes
    
    vline(spike_times(spike_ind), 'r--');
    
end

end