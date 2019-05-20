function [f, fprime] = logistic(x)

%returns the logistic function (with slope parameter c and bias b) and its derivative evaluated at x
% f = logistic function evaluated at x
% f_prime = derivative of logistic function evaluated at x


f = 1 ./ (1 + exp(-x));
fprime = f.*(1-f);