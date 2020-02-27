n1 = length(allTmpData{1});
n2 = length(allTmpData{2});

mu1 = mean(allTmpData{1});
mu2 = mean(allTmpData{2});

sigmasq1 = var(allTmpData{1});
sigmasq2 = var(allTmpData{2});

d = (mu2 - mu1)/sqrt(((n1-1)*sigmasq1 + (n2-1)*sigmasq2)/(n1+n2-2))

