function s = classifyClusterUnitTones(s)

clusterUnitTones = cell(1, s.nClusters);
clusterTypeProp = cell(1, s.nClusters);
clusterNumUnitTones = cell(1, s.nClusters);
for clustInd = 1:s.nClusters
    unitInds = s.tblFull.unitIndex(s.clust == clustInd);
    toneInds = s.tblFull.toneFreqNumeric(s.clust == clustInd);
    clusterUnitTones{clustInd} = [unitInds, toneInds];
    unitTypes = s.tblFull.unitTypeNumeric(s.clust == clustInd);
    clusterTypeProp{clustInd} = sum(unitTypes) / numel(unitTypes);
    clusterNumUnitTones{clustInd} = numel(unitTypes);
end

expectedClustTypeProp = sum(s.tblFull.unitTypeNumeric) / numel(s.tblFull.unitTypeNumeric);

s.clusterUnitTones = clusterUnitTones;
s.clusterTypeProp = clusterTypeProp;
s.clusterNumUnitTones = clusterNumUnitTones;
s.expectedClustTypeProp = expectedClustTypeProp;

end