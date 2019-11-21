function [tbl, chi2stat, pval] = chisquare_test(n1, n2, N1, N2)

x1 = [repmat('a', N1, 1); repmat('b', N2, 1)];
x2 = [ones(n1, 1); repmat(2, N1-n1, 1); ones(n2, 1); repmat(2, N2-n2, 1)];
[tbl, chi2stat, pval] = crosstab(x1, x2);

end