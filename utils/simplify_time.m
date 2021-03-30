function simpleActivatedTimes = simplify_time(sortedActivatedTimes)

[uniqueActivatedTimes, ia, ic] = unique(sortedActivatedTimes);

simpleActivatedTimes = sortedActivatedTimes;

d = 0;
for timeInd = uniqueActivatedTimes'
    d = d + 1;
    currentInds = ic == d;
    if sum(currentInds) > 1
        insertVals = linspace(timeInd, timeInd + 1, sum(currentInds) + 1);
        simpleActivatedTimes(currentInds) = insertVals(1:end - 1);
    end
end

end