function [ax, i, c] = imagesc_cb(C, varargin)
% convenience function for quick imagesc plots
%
% C is a 2d array
%
% varargin
% --
% ax: axes object (if not provided, create an axis)
% scheme: colorbrewer scheme for colormap ('*RdBu')
% n_cols: number of color gradations for colormap (64)
% lims: give pre-defined color limits

% parse varargs and assign defaults
n_varargs = length(varargin);
optargs = {[], '*RdBu', 64, []};
optargs(1:n_varargs) = varargin;
[ax, scheme, n_cols, lims] = optargs{:};

% create colorbrewer colormap
cmap = brewermap(n_cols, scheme);
[~, ~, typ] = brewermap(0, scheme);

if isempty(ax)
    ax = axes;
end

% build figure
i = imagesc(ax, C);
colormap(ax, cmap);
c = colorbar(ax);

if isempty(lims)
    % modify image and colorbar limits
    if strcmp(typ, 'Diverging')
        % set image color limits to be symmetric about zero
        lims = ax.CLim;
        ax.CLim = max(abs(lims)) * [-1 1];

        % change the displayed limits of the colorbar
        % to reflect the limits of the input data
        c.Limits = lims;
    end
else
    ax.CLim = lims;
    c.Limits = lims;
end

end