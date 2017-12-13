% set null and alternate population means, population standard deviation
mu_0 = 25;
mu_a = 30;
sigma = 8;

% set desired alpha and n
alpha = 0.05;
n = 22;

% compute z-score for desired alpha
z_alpha = norminv(1 - alpha);
z_alpha_sign = sign(mu_a - mu_0);

% find the critical mu value
mu_crit = mu_0 + z_alpha_sign * z_alpha * sigma / sqrt(n);

% compute observed power
z_power = z_alpha_sign * (mu_a - mu_crit) / (sigma / sqrt(n));
power = normcdf(z_power);