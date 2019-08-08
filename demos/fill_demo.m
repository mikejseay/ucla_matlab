x = linspace(0,8,50);
y1 = besselj(2,x);
y2 = besselj(3,x);
plot(x,y1)
hold on
plot(x,y2)
hold off
legend('J_2','J_3')

mask = y2 > y1;
fx = [x(mask), fliplr(x(mask))];
fy = [y1(mask), fliplr(y2(mask))];
hold on
fill_color = [.929 .694 .125];
fh = fill(fx,fy,fill_color);
hold off

fh.EdgeColor = 'none';
uistack(fh,'bottom')
