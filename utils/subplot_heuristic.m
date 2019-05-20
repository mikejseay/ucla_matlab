function [rows, cols] = subplot_heuristic(n)
% returns the dimensions of rows and columns that are most golden

phi = 1.618;

if n > 6 && isprime(n)
    n = n + 1;
end
numerators = n;
denominators = 1;
for x = 2:round(sqrt(n) + 1)
    if mod(n, x) == 0
        denominators = [denominators, x];
        numerators = [numerators, floor(n ./ x)];
    end
end
ratios = numerators ./ denominators;
[~, i] = min(abs(ratios - phi));

if denominators(i) < numerators(i)
    rows = denominators(i);
    cols = numerators(i);
else
    cols = denominators(i);
    rows = numerators(i);
end

end