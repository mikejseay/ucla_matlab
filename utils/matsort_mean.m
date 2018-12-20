function aSorted = matsort_mean(a)

[~, amaxinds] = max(a, [], 2);
[~, asortorder] = sort(amaxinds);
asorted = a(asortorder, :);
