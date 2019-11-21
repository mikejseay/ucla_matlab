function result = sliding_equality(a, b)
% slide a along b

assert(size(a, 1) == size(b, 1));

nWidth = size(a, 2);
nPositions = size(b, 2) - nWidth + 1;

result = false(1, nPositions);
for posInd = 1:nPositions
    
    result(posInd) = allx(b(:, posInd:posInd + nWidth - 1) == a);
    
end

end