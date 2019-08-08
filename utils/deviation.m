function x_Deviation = deviation(x, baselinePeriodInds)

x_BaselineMean = mean(x(:, baselinePeriodInds), 2);
x_BaselineStd = std(x(:, baselinePeriodInds), 0, 2);
x_Deviation = (x - x_BaselineMean) ./ x_BaselineStd;

end