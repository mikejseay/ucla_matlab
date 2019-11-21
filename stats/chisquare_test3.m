function [h, p, stats] = chisquare_test3(n1, n2, N1, N2)

% Pooled estimate of proportion
p0 = (n1 + n2) / (N1 + N2);

% Expected counts under H0 (null hypothesis)
n10 = N1 * p0;
n20 = N2 * p0;

% Chi-square test, by hand
observed = [n1, N1 - n1, n2, N2 - n2];
expected = [n10, N1 - n10, n20, N2 - n20];
[h, p, stats] = chi2gof([1, 2, 3, 4], 'freq', observed, 'expected', expected, ...
    'ctrs', [1, 2, 3, 4], 'nparams', 2);

end