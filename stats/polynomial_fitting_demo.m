x = linspace(-10, 10, 100);
y1 = x;
y2 = x.^2;
y3 = x + x.^2;
figure; plot(x, y1, x, y2, x, y3);
legend('x', 'x^2', 'x + x^2');