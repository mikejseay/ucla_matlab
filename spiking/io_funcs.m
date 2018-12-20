% v = -100:0;
x1 = -6:.1:-3;
x2 = -3:.1:3;
flat_part = zeros(size(x1));
sigmoid_part = tanh(x2) + 1;
linear_part = x2 + 3;

out1 = [flat_part, sigmoid_part] / 2;
out2 = [flat_part, linear_part] / 6;
xp1 = [x1, x2];
xp1 = (xp1 - 3) * 10;

xp2 = [x1, x2];
xp2 = (xp2 - 1) * 10;

% out = [out, out];
% x = [x, x];
% out(out < 0) = 0;
% v = ((x * 2) - 4) * 10;

figure(1);
plot(xp1, out1);

figure(2);
plot(xp2, out2);
axis([-70 0 0 1])