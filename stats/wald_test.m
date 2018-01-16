% clear;

% define data with y (observations) and x (grouping matrix)
% y = [60 64 24 26 30 27 75 80]';
% x = [1 0 0 0; 1 0 0 0; 0 1 0 0; 0 1 0 0; 0 0 1 0; 0 0 1 0; 0 0 0 1; 0 0 0 1];
% y = [4, 3, 6, 4, 5, 5, 7, 5, 6, 4, 5, 4, 6, 4, 6, 7, 8, 9, 9, 8, 2, 3, 4, 3, 1]';
% x = kron(eye(5), ones(5, 1));

% x = zeros(7,3); x(1,1)=1; x(2,1)=1; x(3,2)=1; x(4,2)=1; x(5,3)=1; x(6,3)=1; x(7,3)=1;
% y = [6, 8, 9, 13, 3, 5, 7]';

% x = zeros(11,4); x(1,1)=1; x(2,1)=1; x(3,2)=1; x(4,2)=1; x(5,2)=1; x(6,2)=1;
% x(7,3)=1; x(8,3)=1; x(9,4)=1; x(10,4)=1; x(11,4)=1; 
% y = [5 7 1 5 4 4 5 6 4 2 3]';

% define a specific hypothesis matrix
% h = [1 -1 -1 1];
% h = [1 1 1 1 -4];
% h = [1 0 -1; 0 1 -1];
% h = [0 1 0 -1];
% h = [1 1 -1 -1];
h = [1 -1 1 -1];
% h = [1 1 -2];

% define t (# of obs.), r (# of groups), q (# of hypotheses)
t = length(y);
r = size(x, 2);
q = size(h, 1);

% calculate mu, sigma, and f value
a = zeros(q, 1);
% a = ones(q, 1);
mu = inv(x' * x) * x' * y;
sigma = (y - x * mu)' * (y - x * mu) / (t - r);
fval = (h * mu - a)' * inv(h * inv(x' * x) * h') * (h * mu - a) ...
    / q / sigma;
p = 1 - fcdf(fval, q, t-r);
