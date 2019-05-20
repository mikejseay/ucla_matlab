function s = PCAClusterTable(tbl, nPCAComponents, maxClusters, clusterMethod)

arrayNans = table2array(tbl);
array = arrayNans;
array(any(isnan(array), 2), :) = [];

arrayZ = zscore(array);
[coeff, score, latent, tsquared, explained, mu] = pca(arrayZ);

[clust, clusterind] = Cluster(score(:, 1:nPCAComponents)', 1:maxClusters, clusterMethod);

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

s = struct()
s.tbl = tbl;
s.arrayNans = arrayNans;
s.array = array;
s.arrayZ = arrayZ;
s.coeff
s.score
s.latent
s.tsquared
s.explained
s.mu

end