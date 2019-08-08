function out = column_normalize(in)

out = in ./ max(in, [], 2);

end