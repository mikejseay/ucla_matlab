function plot_light_pulses(time, p_ons, p_off, cond_inds)

assert(length(p_ons) == length(p_off));

n_pulses = length(p_ons);
n_conds = length(unique(cond_inds));

colors = {'r', 'b'};

yl = ylim;
y1 = yl(1);
y2 = yl(2);

hold on;
for pulse_ind = 1:n_pulses
    x1 = time(p_ons(pulse_ind));
    x2 = time(p_off(pulse_ind));
    cond_ind = cond_inds(pulse_ind);
    color = colors{cond_ind};
%     patch('Vertices', [x1, y1; x2, y1; x2, y2; x1, y2], 'Faces', [1, 2, 3, 4], ...
%             'FaceColor', color, 'FaceAlpha', 0.2, 'EdgeAlpha', 0);
    patch('Vertices', [x1, y1; x2, y1; x2, y2; x1, y2], 'Faces', [1, 2, 3, 4], ...
            'FaceColor', color, 'FaceAlpha', 1, 'EdgeColor', color, 'EdgeAlpha', 1);
hold off;

end