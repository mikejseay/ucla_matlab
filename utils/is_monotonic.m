function bool = is_monotonic(x)

bool = all(diff(x) >= 0);

end