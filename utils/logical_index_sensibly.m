function logical_index_sensibly(arr, partial_mask)

arrDims = size(arr);
pmDims = size(partial_mask);
% nonPMArrDims = setdiff(arrDims, pmDims);

dimAgreementMatrix = arrDims == pmDims';
shouldBePlacedLoc = find(sliding_equality(eye(length(pmDims)), dimAgreementMatrix));

repmatSpec = ones(1, length(arrDims) - length(pmDims));
repmatSpec = vector_insert(repmatSpec, [], shouldBePlacedLoc);

end