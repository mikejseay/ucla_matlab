function [out, sums, dotprods] = is_orthogonal_imba(o, group_ns)
% check orthogonality when groups are imbalanced

% o is a matrix of size [n_contrasts, n_preds]
% in which each row is a contrast

% group_ns is a vector of the group size for each of n_preds

[n_contrasts, n_preds] = size(o);

if n_contrasts ~= n_preds - 1
    disp('contrast is not complete');
end

if n_preds ~= length(group_ns)
    out = false;
    disp('group n''s vector is not correct length');
    return
end

sums = sum(group_ns .* o, 2);    
if any(sums ~= 0)
    out = false;
    return
end

combs = combnk(1:n_contrasts, 2);
n_combs = length(combs);
dotprods = zeros(n_combs, 1);

for c_i = 1:n_combs
    
    comb = combs(c_i, :);
    dotprods(c_i) = sum(group_ns .* o(comb(1), :) .* o(comb(2), :));
    
    if dotprods(c_i) ~= 0
        out = false;
        return
    end
    
end

out = true;
return

end