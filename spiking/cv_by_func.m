x = linspace(-1, 1, 100);
x_odds = (x + 1) / 2;
ylin = x;
ytanh = tanh(x);
yatanh = atanh(x);
ylogis = 1 ./ (1 + exp(-4 * x)) - .5; % logistic
yatanh = yatanh / max(abs(yatanh(isfinite(yatanh))));

cvlin = cv(ylin);
cvtanh = cv(ytanh);
cvatanh = cv(yatanh);
cvlogis = cv(ylogis);

figure; clf;
plot(x, ylin, x, ytanh, x, ylogis, x, yatanh);
legend('lin', 'tanh', 'logistic', 'atanh');
% hold on;
% plot(x, ylin, x, ytanh, x, yatanh);
% plot(x, ysup2);