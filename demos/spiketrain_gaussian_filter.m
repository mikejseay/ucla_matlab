%% generate poisson spike train

fr = 20;
t_end = 500;
fs = 1000;

tmp_unif = rand(1, t_end);
spikeTimes1 = find(tmp_unif < (fr / fs));
close_spikes = [false diff(spikeTimes1) < 10];
spikeTimes = spikeTimes1;
spikeTimes(close_spikes) = [];

%% create gaussian kernel

% spikeTimes is a row vector

sigma = 50;
t = (1:t_end)';  % column vector so that the result broadcasts correctly
nRepeats = 1000;

% for repeatInd = 1:nRepeats
singleGauss1 = exp(-0.5 * ((t - spikeTimes(1))./sigma).^2) ./ (sqrt(2*pi) .* sigma);
singleGauss2 = normpdf(t, spikeTimes(1), sigma);
multiGauss1 = exp(-0.5 * ((t - spikeTimes)./sigma).^2) ./ (sqrt(2*pi) .* sigma);
multiGauss2 = normpdf(t, spikeTimes, sigma);
% end

sumGauss1 = sum(multiGauss1, 2);

figure(1); clf;
plot(singleGauss1);
figure(2); clf;
plot(singleGauss2);
figure(3); clf;
plot(multiGauss1);
figure(4); clf;
plot(multiGauss2);


figure(5); clf;
plot(sumGauss1);
