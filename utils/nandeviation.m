function xNan_deviation = nandeviation(xNan, xGood, baselinePeriodInds, dim)
% create a version of x in which each value represents how far that value
% deviates from the baseline mean in units of the standard deviation of the
% baseline

% baselinePeriodInds and dim tell which indices of which dim contain the
% baseline

pre_colons = repmat({':'}, 1, dim - 1);
post_colons = repmat({':'}, 1, ndims(xGood) - dim);

xGood_baselineData = xGood(pre_colons{:}, baselinePeriodInds, post_colons{:});

xGood_baselineMean = mean(xGood_baselineData, dim);
xGood_baselineStd = std(xGood_baselineData, 0, dim);

% set all STD values of 0 to be the global min... avoids division by zero
minStd = min(xGood_baselineStd(xGood_baselineStd ~= 0));
xGood_baselineStd(xGood_baselineStd == 0) = minStd;

xNan_deviation = (xNan - xGood_baselineMean) ./ xGood_baselineStd;

end