%GETS all .cfs files from a cell and merges them into a single MATLAB file
%Assumes data collected with gain of 50x
%BMI Cond = 25 sec (@5kHz) and 3 Channels
%Excit Cond = 1 sec (@10kHz) and 2 Channels

clear;
close all;

% target_folder = 'C:\Users\Mike\Dropbox\UCLA\data\DoubleDoubleDual';
target_folder = 'C:\Users\Mike\Documents\MATLAB\order_dual';

filenames = glob([target_folder, '\*.cfs']);
n_files = length(filenames);

%Convert CFS to MAT
for f_ind = 1:n_files
    cfs2mat_func(filenames{f_ind})
end


% DIV=input('DIV=');
% BATCH=input('Date of Slicing (MMDDYY)=');
% MOUSETYPE = input('Mouse type=', 's');
% TRANSDATE=input('Trans Date (MMDDYY)=','s'); 
% TRANSTYPE=input('Trans virus=','s');
% DISTPIA=input('Distance from Pia=','s');
% DISTCELLS=input('Distance between cells=','s');
% PYRCELL = input('Which channel is the Pyramidal Cell=');
% PVCELL = input('Which channel is the PV Cell=');

%% SAVE ALL DATA TO A *.mat FILE %%
% [~, name, ext] = fileparts(fName{1});
% target_path = fullfile(target_folder, name);
% save(target_path, 'D')
% fprintf('Saving file as %s.mat\n', name)
