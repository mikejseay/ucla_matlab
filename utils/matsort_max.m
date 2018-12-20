function aSorted = matsort_max(a, sortDim)

[~, aMaxInds] = max(a, [], sortDim);
[~, aSortOrder] = sort(aMaxInds);
aSorted = a(aSortOrder, :);
