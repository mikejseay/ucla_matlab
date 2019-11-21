function patternCounts = count_rgb(a)

% given logical array a of size n x 3,
% count how many elements fall into each of 8 possible RGB categories
% ordered as RGBYMCWK

possibleBools = logical([1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1; 0 1 1; 1 1 1; 0 0 0]);
nPossibleBools = size(possibleBools, 1);
patternCounts = zeros(1, nPossibleBools);

for possibleBoolInd = 1:nPossibleBools
    currentBoolPattern = possibleBools(possibleBoolInd, :);
    countsOfThatPattern = sum(all(a == currentBoolPattern, 2));
    patternCounts(possibleBoolInd) = countsOfThatPattern;
end

end