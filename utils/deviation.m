function x_deviation = deviation(x, baselinePeriodInds, dim, avoidDivZero)
% create a version of x in which each value represents how far that value
% deviates from the baseline mean in units of the standard deviation of the baseline

% baselinePeriodInds and dim tell which indices of which dim contain the baseline

if nargin < 4
    avoidDivZero = true;
end

pre_colons = repmat({':'}, 1, dim - 1);
post_colons = repmat({':'}, 1, ndims(x) - dim);

x_baselineData = x(pre_colons{:}, baselinePeriodInds, post_colons{:});

x_baselineMean = mean(x_baselineData, dim);
x_baselineStd = std(x_baselineData, 0, dim);

% set all STD values of 0 to be the global min... avoids division by zero
if avoidDivZero
    minStd = min(x_baselineStd(x_baselineStd ~= 0));
    x_baselineStd(x_baselineStd == 0) = minStd;
end

x_deviation = (x - x_baselineMean) ./ x_baselineStd;

end