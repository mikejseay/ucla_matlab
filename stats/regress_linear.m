function [b, bint, r, rint, stats] = regress_linear(x, y)

X = [ones(size(x)) x];

[b, bint, r, rint, stats] = regress(y, X);

end

% figure; scatter(x, y);
% hold on;
% plot(x, b(1) + b(2) .* x, 'k-');
