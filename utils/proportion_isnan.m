function p = proportion_isnan(a)

p = sumx(isnan(a)) / numel(a);

end