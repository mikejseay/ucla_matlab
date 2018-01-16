% set null and alternate population means, population standard deviation
mu_0 = 32;
mu_a = 45;
sigma = 20;

% set desired alpha and n
alpha = 0.01;
power = 0.95;

% compute z-score for desired power and alpha
z_power = norminv(1 - power);
z_alpha = norminv(1 - alpha);

% compute non-trivial effect size
d = (mu_a - mu_0) / sigma;

% compute minimum needed n
n = ((z_power - z_alpha) / d) ^ 2;
