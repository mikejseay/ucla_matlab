function outlying_bool = mark_outliers(in, std_thresh)

if nargin < 2
    std_thresh = 3;
end

in_mean = mean(in);
in_std = std(in);

outlying_bool = in > (in_mean + std_thresh * in_std) | in < (in_mean - std_thresh * in_std);

end