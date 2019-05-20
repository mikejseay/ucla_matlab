function y = nanSEM(x, dim)
%SEM    Standard Error of the Mean.
%   SEM = STD/n^2
%   uses STD with FLAG=0, thus STD is calculated using (n-1)
%   See also STD.

%   Mike Seay 4/2/19

if nargin < 2
    [r, c] = size(x);
    if r == 1
        dim = 2;
    elseif c == 1
        dim = 1;
    end
end

n = size(x, dim);
y = nanstd(x, 0, dim) ./ sqrt(n);
