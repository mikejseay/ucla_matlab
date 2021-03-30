% Assuming that P is N-by-3 numeric array
P = ARMACoeff;

B = [P(:,1), P(:,2), ones(size(P,1),1)] \ P(:,3);                       % Linear Regression
xv = [min(P(:,1)) max(P(:,1))];
yv = [min(P(:,2)) max(P(:,2))];
zv = [xv(:), yv(:), ones(2,1)] * B;                                     % Calculate Regression Plane
figure
scatter3(P(:,1), P(:,2), P(:,3), '.')
hold on
patch([min(xv) min(xv) max(xv) max(xv)], [min(yv) max(yv) max(yv) min(yv)], [min(zv) min(zv) max(zv) max(zv)], 'r', 'FaceAlpha',0.5)
hold off
grid on
xlabel('X')
ylabel('Y')
