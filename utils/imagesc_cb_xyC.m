function [ax, i, c] = imagesc_cb_xyC(x, y, C, varargin)
% convenience function for quick imagesc plots
%
% C is a 2d array
%
% varargin
% --
% ax: axes object (if not provided, create an axis)
% scheme: colorbrewer scheme for colormap ('*RdBu')
% lims: give pre-defined color limits
% plot_cbar: whether to plot the colorbar
% n_cols: number of color gradations for colormap (64)

% parse varargs and assign defaults
n_varargs = length(varargin);
optargs = {[], '*RdBu', [], false, 64};
optargs(1:n_varargs) = varargin;
[ax, scheme, lims, plot_cbar, n_cols] = optargs{:};

% create colorbrewer colormap
cmap = brewermap(n_cols, scheme);
[~, ~, typ] = brewermap(0, scheme);

if isempty(ax)
    ax = axes;
end

% build figure
i = imagesc(ax, x, y, C);
% set(gca, 'YDir', 'normal');
colormap(ax, cmap);

if plot_cbar
    c = colorbar(ax);
end

if isempty(lims)
    % modify image and colorbar limits
    if strcmp(typ, 'Diverging')
        % set image color limits to be symmetric about zero
        lims = ax.CLim;
        ax.CLim = max(abs(lims)) * [-1 1];
        
        if plot_cbar
            % change the displayed limits of the colorbar
            % to reflect the limits of the input data
            c.Limits = lims;
        end
    end
else
    ax.CLim = lims;
    if plot_cbar
        c.Limits = lims;
    end
end

end