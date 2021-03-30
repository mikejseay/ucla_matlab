% Assuming that arr is N-by-3 numeric array
arr = ARMACoeff;

x=arr(:,1);
y=arr(:,2);
z=arr(:,3);
DM = [x, y, ones(size(z))];                             % Design Matrix
B = DM\z;                                               % Estimate Parameters
[X,Y] = meshgrid(linspace(min(x),max(x),50), linspace(min(y),max(y),50));
Z = B(1)*X + B(2)*Y + B(3)*ones(size(X));
figure(1)
plot3(arr(:,1),arr(:,2),arr(:,3),'.')
hold on
meshc(X, Y, Z)
hold off
grid on
xlabel('\Phi_1'); ylabel('\Phi_2'); zlabel('\Phi_3');
grid on
