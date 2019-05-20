function p = proportion_notnan(a)

p = sumx(~isnan(a)) / numel(a);

end