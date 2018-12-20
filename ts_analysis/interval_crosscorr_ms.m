function mxc = interval_crosscorr_ms(f,g,maxlag,idex)

% This function searches the time series f and g (which must have the same
% number of elements) and extracts data from the index interval ranges specified by idex. 
% The cross correlation of f and g is computed within each extracted interval, and 
% truncated at lags ranging between -halfwid and +halfwid. The mean of all truncated
% crosscorrelograms is returned in 'mxc'

%%%%ARGUMENTS
% f = first time series
% g = second time series
% maxlag = width for the cross correlogram in number of samples 
% idex = matrix of start (column 1) ad end (column 2) indices for intervals
% in f and g:
%
% idex(1,1:2) = [startindex1 endindex1]
% idex(2,1:2) = [startindex2 endindex2]
%     .
%     .
%     .
% idex(N,1:2) = [startindexN endindexN]
%
% where N is the number of intervals found in the data, and startindex_i, endindex_i
% are the starting and ending indices of the i_th interval
 
%%%%RESULTS
% mxc = mean of the cross correlograms computed within the target
%       intervals, over the range -halfwid to +halfwid 

numints = size(idex, 1); %number of intervals to average over
gram_len = 2*maxlag + 1;
mxc = zeros(gram_len, 1);
segs_skipped = 0;

for i=1:numints %loop through the intervals
    
    %extract data segments from f and g that lie within the current interval
    fseg = f(idex(i, 1):idex(i, 2));
    gseg = g(idex(i, 1):idex(i, 2));
    
    %compute and truncate the cross correlogram of segments from f and g
    cc = conv(fseg, flip(gseg));
    center_pt = ceil(length(cc) / 2);
    
    if length(cc) < gram_len
        segs_skipped = segs_skipped + 1;
        continue
    end
    
    cc_trunc = cc((center_pt - maxlag):(center_pt + maxlag));
%     figure(1); clf;
%     plot(cc_trunc);
    
    %average over the intervals
    mxc = mxc + cc_trunc;
    
end

fprintf('%d segments skipped for being too short\n', segs_skipped);

mxc = mxc / numints;