function h=hline_me(y,color,linestyle)
% i gutted it

switch nargin
    case 1
        color = 'k';
        linestyle = '-';
    case 2
        linestyle = '-';
end
x = get(gca, 'xlim');
h = plot(x, [y y], 'Color', color, 'LineStyle', linestyle);

end
