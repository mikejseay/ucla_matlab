function out = vector_insert(in, item, location)

out = [in(1:location - 1) item in(location:end)];

end