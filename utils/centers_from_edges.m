function centers = centers_from_edges(edges)

centers = (edges(1:end - 1) + edges(2:end)) ./ 2;

end