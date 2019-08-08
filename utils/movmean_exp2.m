function out = movmean_exp2(in, alpha)
% alpha is smoothing constant

nSamps = length(in);
out = in;

ro = 1 - alpha;

for sampInd = 2:nSamps
    
    out(sampInd) = ro * out(sampInd - 1) + alpha * in(sampInd);
    
end

end
