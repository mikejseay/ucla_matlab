% mass rename??

outer_folder = '/Users/michaelseay/Documents/MATLAB/data/doubledouble/figs';
new_outer_folder = '/Users/michaelseay/Documents/MATLAB/data/doubledouble/figs-bk';

files_inside = glob([outer_folder, '/*.fig']);

for fileInd = 1:length(files_inside)

    current_path = files_inside{fileInd};
    [pathstr, name, ext] = fileparts(current_path);
    name = strsplit(name, '_');
    new_name = strjoin({name{2}, name{1}, name{3:end}}, '_');
    new_path = fullfile(new_outer_folder, [new_name, ext]);
    copyfile(current_path, new_path);

end
