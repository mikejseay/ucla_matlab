% Assuming that yourData is N-by-3 numeric array
yourData = ARMACoeff;
N = size(yourData, 1);
B = [ones(N,1), yourData(:,1:2)] \ yourData(:,3);

a = B(2);
b = B(3);
c = B(1);

xv = [min(yourData(:, 1)) max(yourData(:, 1))];
yv = [min(yourData(:, 2)) max(yourData(:, 2))];
zv = a .* xv + b .* yv + c;

figure; clf;
scatter3(yourData(:,1), yourData(:,2), yourData(:,3), '.')
hold on
