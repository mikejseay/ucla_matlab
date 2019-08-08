function peakTimes = locate_spikes(dataGiven, threshold)
% Finds the peaks above a certain given threshold
    % Inputs are data values
    % and the desired threshold for determining peaks. Creates a temporary
    % array of all values in given data that are above the threshold. Detects the
    % values that are greater than the value before them and after them (local maxima),
    % and returns the indices of these local maxima.
    
% written by Ash, Buonomano Lab, May 2019

peakTimes = [];
aboveThreshold = dataGiven > threshold;
aboveThresholdIndices = find(aboveThreshold);
dataAboveThreshold = dataGiven(aboveThreshold); 

for currentIndex = 2:length(dataAboveThreshold)-1
    currentDataValue = dataAboveThreshold(currentIndex);
    dataValueAfter = dataAboveThreshold(currentIndex+1);
    dataValueBefore = dataAboveThreshold(currentIndex-1);
    if (currentDataValue >= dataValueAfter) && (currentDataValue > dataValueBefore)
           peakTimes = [peakTimes aboveThresholdIndices(currentIndex)];
    end
end 

end