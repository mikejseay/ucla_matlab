figure(1); clf;
set(gcf, 'Units', 'normalized')
k = waitforbuttonpress;
rect_pos = rbbox;
annotation('rectangle', rect_pos, 'Color', 'red');
