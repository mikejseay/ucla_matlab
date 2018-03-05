function out = cv(in)

% if nargin < 2
%     dim = 1;
% end

in2 = in( ~isnan(in) & isfinite(in) );

out = std(in2, 0) ./ mean(in2);

end