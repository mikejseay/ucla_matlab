x = linspace(0, 1, 100)';
y = x + rand(100, 1);

X = [ones(size(x)) x];

[b, bint, r, rint, stats] = regress(y, X);

figure; scatter(x, y);
hold on;
plot(x, b(1) + b(2) .* x, 'k-');
