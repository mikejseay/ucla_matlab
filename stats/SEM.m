function y = SEM(x)
%SEM    Standard Error of the Mean.
%   SEM = STD/n^2
%   uses STD with FLAG=0, thus STD is calculated using (n-1)
%   See also STD.

%   D.V. Buonomano 8-3-01

[n c] = size(x);
if (n==1) n=c; end
y = std(x,0)./sqrt(n);




