n_units = 10;
w = rand(n_units, 1);
x_init = rand(n_units, 1) - 0.5;

n_timepts = 100;
alpha = .001;

x = x_init;
y = rand(1, 1) - 0.5;
w_log = zeros(n_units, n_timepts);
for t = 1:100
    y = y + sum(x .* w);
    w = w + alpha .* x .* y;
    w_log(:, t) = w;
end