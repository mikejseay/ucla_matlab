% set null and alternate population means, population standard deviation
mu_0 = 25;
mu_a = 30;
sigma = 8;

% set desired alpha and power
alpha = 0.05;
power = 0.9;

% compute z-score for desired power and alpha
z_power = norminv(1 - power);
z_alpha = norminv(1 - alpha);

% compute non-trivial effect size
d = (mu_a - mu_0) / sigma;

% compute minimum needed n
n = ((z_power - z_alpha) / d) ^ 2;