function index = spike_time_tiling_coefficient(spiketrain_1, spiketrain_2, t_start, t_stop, dt)

if nargin < 5
    dt = 0.005;
end

N1 = length(spiketrain_1);
N2 = length(spiketrain_2);

if N1 == 0 || N2 == 0
    index = NaN;
else
    TA = run_T(spiketrain_1, N1, t_start, t_stop, dt);
    TB = run_T(spiketrain_2, N2, t_start, t_stop, dt);
    PA = run_P(spiketrain_1, spiketrain_2, N1, N2, dt);
    PA = PA / N1;
    PB = run_P(spiketrain_2, spiketrain_1, N2, N1, dt);
    PB = PB / N2;
    % check if the P and T values are 1 to avoid division by zero
    % This only happens for TA = PB = 1 and/or TB = PA = 1,
    % which leads to 0/0 in the calculation of the index.
    % In those cases, every spike in the train with P = 1
    % is within dt of a spike in the other train,
    % so we set the respective (partial) index to 1.
    if PA * TB == 1
        if PB * TA == 1
            index = 1;
        else
            index = 0.5 + 0.5 * (PB - TA) / (1 - PB * TA);
        end
    elseif PB * TA == 1
        index = 0.5 + 0.5 * (PA - TB) / (1 - PA * TB);
    else
        index = 0.5 * (PA - TB) / (1 - PA * TB) + 0.5 * (PB - TA) / (1 - PB * TA);
    end
end
end

function Nab = run_P(spiketrain_1, spiketrain_2, N1, N2, dt)

Nab = 0;
j = 1;
for i = 1:length(N1)
    while j < N2
        if abs(spiketrain_1(i) - spiketrain_2(j)) <= dt
            Nab = Nab + 1;
            break
        elseif spiketrain_2(j) > spiketrain_1(i)
            break
        else
            j = j + 1;
        end
    end
end

end

function T = run_T(spiketrain, N, t_start, t_stop, dt)
% Calculate the proportion of the total recording time 'tiled' by spikes.

time_A = 2 * N * dt;  % maximum possible time

if N == 1  % for just one spike in train
    if spiketrain(1) - t_start < dt
        time_A = time_A - dt + spiketrain(1) - t_start;
    end
    if spiketrain(1) + dt > t_stop
        time_A = time_A - dt - spiketrain(1) + t_stop;
    end
else  % if more than one spike in train
    i = 1;
    while i < N
        tmp_diff = spiketrain(i + 1) - spiketrain(i);

        if tmp_diff < (2 * dt)  % subtract overlap
            time_A = time_A - 2 * dt + tmp_diff;
        end
        i = i + 1;
    end
        % check if spikes are within dt of the start and/or end
        % if so subtract overlap of first and/or last spike
    if (spiketrain(1) - t_start) < dt
        time_A = time_A + spiketrain(1) - dt - t_start;
    end

    if (t_stop - spiketrain(N)) < dt
        time_A = time_A - spiketrain(end) - dt + t_stop;
    end
end
T = time_A / (t_stop - t_start);

end