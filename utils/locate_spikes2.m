function peakIndices = locate_spikes2(dataGiven, threshold)
% Finds the peaks above a certain given threshold
    % Inputs are data values
    % and the desired threshold for determining peaks. Creates a temporary
    % array of all values in given data that are above the threshold. Detects the
    % values that are greater than the value before them and after them (local maxima),
    % and returns the indices of these local maxima.
    
% written by Ash T, Buonomano Lab, May 2019
% edited by Mike S, Buonomano Lab, May 2019

if isa(dataGiven, 'double')
    useData = dataGiven;
else
    useData = double(dataGiven);
end

aboveThresholdBool = useData > threshold;
aboveThresholdIndices = find(aboveThresholdBool);
dataAboveThreshold = useData(aboveThresholdBool); 

[~, peaksAboveThreshold] = findpeaks(dataAboveThreshold);
peakIndices = aboveThresholdIndices(peaksAboveThreshold);

end