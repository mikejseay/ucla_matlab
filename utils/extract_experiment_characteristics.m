function [sliceIndex, cellIndex, experimentType, experimentIndex, dateTime] = extract_experiment_characteristics(fileName)

fileNameParts = strsplit(fileName, '_');
monthStr = fileNameParts{1}(1:2);
dayStr = fileNameParts{1}(3:4);
yearStr = fileNameParts{1}(5:6);
sliceIndex = str2double(fileNameParts{2}(2));
cellIndex = str2double(fileNameParts{2}(4));
experimentType = fileNameParts{3};
experimentIndex = str2double(fileNameParts{4});
dateTime = [monthStr, '-', dayStr, '-', yearStr];    

end