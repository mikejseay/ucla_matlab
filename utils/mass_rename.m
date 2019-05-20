% mass rename??

outer_folder = '/Users/michaelseay/Dropbox/UCLA/data/doubledouble/Experiments2';
inner_folders = {'031119', '031219', '031319', '031419', '031519', '031619', '031719', '031819'};

for folderInd = 1:length(inner_folders)
    
    folder_path = fullfile(outer_folder, inner_folders{folderInd});
    files_inside = glob([folder_path, '/*.mat']);
    
    for fileInd = 1:length(files_inside)
        
        current_path = files_inside{fileInd};
        [pathstr, name, ext] = fileparts(current_path);
        new_name = [name(1:4), '19', name(5:end)];
        new_path = [pathstr, filesep, new_name, ext];
        movefile(current_path, new_path);
        
    end
    
end