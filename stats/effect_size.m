function d = effect_size(data1, data2)

n1 = length(data1);
n2 = length(data2);

mu1 = mean(data1);
mu2 = mean(data2);

sigmasq1 = var(data1);
sigmasq2 = var(data2);

d = (mu2 - mu1)/sqrt(((n1-1)*sigmasq1 + (n2-1)*sigmasq2)/(n1+n2-2));

end