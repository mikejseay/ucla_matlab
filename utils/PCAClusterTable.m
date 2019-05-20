function s = PCAClusterTable(tblNaNFull, useColumns, nPCAComponents, maxClusters, clusterMethod)

tblNaN = tblNaNFull(:, useColumns);
arrayNaN = table2array(tblNaN);
array = arrayNaN;
tbl = tblNaN;
tblFull = tblNaNFull;
NaNIndices = any(isnan(array), 2);
tbl(NaNIndices, :) = [];
array(NaNIndices, :) = [];
tblFull(NaNIndices, :) = [];

arrayZ = zscore(array);
[coeff, score, latent, tsquared, explained, mu] = pca(arrayZ);

[clust, clusterind] = Cluster(score(:, 1:nPCAComponents)', 1:maxClusters, clusterMethod);
nClusters = length(unique(clust));

medoidIndices = zeros(nClusters, 1);
medoidSortedIndices = cell(nClusters, 1);

for clusterInd = 1:nClusters
    matchingIndices = find(clust == clusterInd);
    clusterChunk = score(matchingIndices, :);
    [myMedoid, medoidIndex] = medoid(clusterChunk');
    [myMedoidSort, medoidSortIndices] = medoid_sort(clusterChunk');
    trueMedoidIndex = matchingIndices(medoidIndex);
    trueMedoidSortIndices = matchingIndices(medoidSortIndices);
    medoidIndices(clusterInd) = trueMedoidIndex;
    medoidSortedIndices{clusterInd} = trueMedoidSortIndices;
end

s = struct();
s.tblFull = tblFull;
s.tblNaNFull = tblNaNFull;
s.useColumns = useColumns;
s.tblNaN = tblNaN;
s.tbl = tbl;
s.arrayNaN = arrayNaN;
s.array = array;
s.arrayZ = arrayZ;
s.coeff = coeff;
s.score = score;
s.latent = latent;
s.tsquared = tsquared;
s.explained = explained;
s.mu = mu;
s.clust = clust;
s.clusterind = clusterind;
s.nClusters = nClusters;
s.medoidIndices = medoidIndices;
s.medoidSortedIndices = medoidSortedIndices;

end