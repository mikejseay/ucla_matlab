% mass rename??

outer_folder = '/Users/michaelseay/Dropbox/UCLA/data/doubledouble/Experiments2';
inner_folders = {'031119', '031219', '031319', '031419', '031519', '031619', ...
    '031719', '031819', '040819', '040919', '041019', '041119', '041219', '041519', ...
    '043019', '050119', '050219', '050319', '050619', };
copy_folder = '/Users/michaelseay/Documents/MATLAB/data/doubledouble_pt2/';

for folderInd = 1:length(inner_folders)
    
    folder_path = fullfile(outer_folder, inner_folders{folderInd});
    files_inside = glob([folder_path, '/*.mat']);
    
    for fileInd = 1:length(files_inside)
        
        current_path = files_inside{fileInd};
        [pathstr, name, ext] = fileparts(current_path);
        copy_path = [copy_folder, filesep, name, ext];
        copyfile(current_path, copy_path);
        
    end
    
end