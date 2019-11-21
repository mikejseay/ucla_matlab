function keep_inds = select_upstates(t, v, u_ons_in, u_off_in)

ymin = min(v);
ymax = max(v);

hold on;
p = plot(t, v, 'k');
p.Color(4) = .2;
xlabel('Time (s)');
ylabel('Potential (mV)');

scatter(t(u_ons_in), v(u_ons_in), ...
    'MarkerEdgeColor', 'none', 'MarkerFaceColor', 'b', 'Marker', '^');
scatter(t(u_off_in), v(u_off_in), ...
    'MarkerEdgeColor', 'none', 'MarkerFaceColor', 'b', 'Marker', 'v');

n_upstates = length(u_ons_in);

for up_ind = 1:n_upstates
    x1 = t(u_ons_in(up_ind));
    x2 = t(u_off_in(up_ind));
    p = patch('Vertices', [x1, ymin; x2, ymin; x2, ymax; x1, ymax], 'Faces', [1, 2, 3, 4], ...
        'FaceColor', 'green', 'FaceAlpha', 0.2, 'EdgeAlpha', 0, 'ButtonDownFcn', @patchCallback, ...
        'UserData', up_ind);  % UserData will be the upstate index
    l = line([x1 x2], [(ymin - 1) (ymin - 1)]);
    l.Color = 'b';
end
hold off;

ylim([(ymin - 2) ymax]);

keep_inds = true(length(u_ons_in), 1);

function patchCallback(source, eventdata)
    keep_inds = evalin('base', 'keep_inds');
    if keep_inds(source.UserData)
        source.FaceColor = 'red';
    else
        source.FaceColor = 'green';
    end
    keep_inds(source.UserData) = ~keep_inds(source.UserData);
    assignin('base', 'keep_inds', keep_inds)
end

end