function [mapper, u_ons1, u_ons2, u_off1, u_off2] = align_upstates(u_ons1, u_ons2, u_off1, u_off2)

% u_ons1 is always longer
% mapper is aligned to u_ons1
% the kth element of mapper is j
% this means that upstate k from u_ons1 is mapped to upstate j from u_ons2
% if j is 0, it means the upstate was orphaned from u_ons1 and has no buddy in u_ons2

if length(u_ons1) < length(u_ons2)
    [u_ons1, u_ons2] = deal(u_ons2, u_ons1);
    [u_off1, u_off2] = deal(u_off2, u_off1);
end

distances = abs(u_ons1' - u_ons2);
[~, min_inds] = min(distances, [], 2);

[~, counts] = count_unique_elements(min_inds);
repeated = find(counts ~= 1);

[~, best_mappers] = min(distances(:, repeated), [], 1);

mapper = min_inds;
mapper(ismember(mapper, repeated)) = 0;
mapper(best_mappers) = repeated;

end