load popcorn
popcorn
[p,tbl,stats] = friedman(popcorn, 3)
[p,tbl,stats] = friedman(popcorn, 1)

popcorn(1, 1) = NaN;

[p,tbl,stats] = friedman(popcorn, 3)
[p,tbl,stats] = friedman(popcorn, 1)
