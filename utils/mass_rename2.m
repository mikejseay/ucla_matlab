% mass rename??

outer_folder = '/Users/michaelseay/Documents/MATLAB/data/doubledouble_pt2/figs';
new_outer_folder = '/Users/michaelseay/Documents/MATLAB/data/doubledouble_pt2/figs-bk';

files_inside = glob([outer_folder, '/*.tif']);

for fileInd = 1:length(files_inside)

    current_path = files_inside{fileInd};
    [pathstr, name, ext] = fileparts(current_path);
    new_name = [name(2), name(1), name(3:end)];
    new_path = fullfile(new_outer_folder, [new_name, ext]);
    copyfile(current_path, new_path);

end
