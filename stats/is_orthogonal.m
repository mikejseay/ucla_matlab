function [out, sums, dotprods] = is_orthogonal(o)
% check orthogonality

% o is a matrix of size [n_contrasts, n_preds]
% in which each row is a contrast
% n_contrasts should be n-1

[n_contrasts, n_preds] = size(o);

if n_contrasts ~= n_preds - 1
    disp('contrast is not complete');
end

sums = sum(o, 2);    
if any(sums ~= 0)
    out = false;
    return
end
    
combs = combnk(1:n_contrasts, 2);
n_combs = length(combs);
dotprods = zeros(n_combs, 1);

for c_i = 1:n_combs
    
    comb = combs(c_i, :);
    dotprods(c_i) = sum(o(comb(1), :) .* o(comb(2), :));
    
    if dotprods(c_i) ~= 0
        out = false;
        return
    end
    
end

out = true;
return

end