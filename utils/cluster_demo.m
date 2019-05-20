X = vUpstatesForCorrShort;
Y = pdist(X);
Y_sq = squareform(Y);
Z = linkage(Y);
figure(42); clf;
dendrogram(Z);
c = cophenet(Z, Y);
I = inconsistent(Z);

%%

Y2 = pdist(X,'cityblock');
Z2 = linkage(Y2,'average');
c2 = cophenet(Z2,Y2);

%%

T1 = cluster(Z, 'cutoff', 1.2);
T2 = cluster(Z, 'cutoff', 1.14);
T3 = cluster(Z, 'maxclust', 2);
T4 = cluster(Z, 'maxclust', 3);

