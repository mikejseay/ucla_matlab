function PSTH_gf = gaussian_psth(spikeTimes, binCenters_GF, sigma_GF)

PSTH_gf = sum(exp(-0.5 * ((binCenters_GF - spikeTimes)./sigma_GF).^2) ./ (sqrt(2*pi) .* sigma_GF), 2);

end