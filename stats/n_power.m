% set null and alternate population means, population standard deviation
mu_0 = 32;
mu_a = 45;
sigma = 20;

% set desired alpha and n
alpha = 0.01;
n = 22;

% compute z-score for desired alpha
z_alpha = norminv(1 - alpha);
effect_sign = sign(mu_a - mu_0);

% find the critical mu value
mu_crit = mu_0 + effect_sign * z_alpha * sigma / sqrt(n);

% compute observed power
z_power = effect_sign * (mu_a - mu_crit) / (sigma / sqrt(n));
power = normcdf(z_power);