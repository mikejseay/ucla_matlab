function h=vline_me(x,color,linestyle)
% function h=vline(x, linetype, label)
% 
% i gutted it

switch nargin
    case 1
        color = 'k';
        linestyle = '-';
    case 2
        linestyle = '-';
end
y=get(gca,'ylim');
h=plot([x x],y,'Color', color, 'LineStyle', linestyle);

end
