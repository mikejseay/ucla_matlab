f = figure(1); clf;
tabgp = uitabgroup(f);
for thingInd = 1:nThings
    t = uitab(tabgp, 'Title', num2str(thingInd));
    axes('Parent', t);
    
    % plot
end