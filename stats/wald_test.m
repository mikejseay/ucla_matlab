% clear;

% define data with y (observations) and x (grouping matrix)
% y = [60 64 24 26 30 27 75 80]';
% x = [1 0 0 0; 1 0 0 0; 0 1 0 0; 0 1 0 0; 0 0 1 0; 0 0 1 0; 0 0 0 1; 0 0 0 1];
% y = [4, 3, 6, 4, 5, 5, 7, 5, 6, 4, 5, 4, 6, 4, 6, 7, 8, 9, 9, 8, 2, 3, 4, 3, 1]';
% x = kron(eye(5), ones(5, 1));

% define a specific hypothesis matrix
% h = [1 -1 -1 1];
% h = [1 1 1 1 -4];
h = [1 0 -1; 0 1 -1];
% h = [1 1 -2];

% define t (# of obs.), r (# of groups), q (# of hypotheses)
t = length(y);
r = size(x, 2);
q = size(h, 1);

% calculate mu, sigma, and f value
a = zeros(q, 1);
mu = inv(x' * x) * x' * y;
sigma = (y - x * mu)' * (y - x * mu) / (t - r);
fval = (h * mu - a)' * inv(h * inv(x' * x) * h') * (h * mu - a) ...
    / q / sigma;

