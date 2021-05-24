function [organized_trials] = organize_trials(sbj_name, task)


%goes through all blocks, creates 'trial' time interval object for each block
%and adds to an array, array will go in intervals_trials group in nwb file
block_array = types.core.TimeIntervals.empty;

%% Get block names
% when BlockBySubj_nwb.m is done use this:
block_names = BlockBySubj_nwb.m(sbj_name, task);

% get info from google sheets till BlockBySubj_nwb.m is done
% Load table
[DOCID,GID] = getGoogleSheetInfo_nwb('nwb_meta_data', 'cohort');
sheet = GetGoogleSpreadsheet(DOCID, GID);

block_names = [sheet.block1(strcmp(sheet.subject_name, sbj_name)), sheet.block2(strcmp(sheet.subject_name, sbj_name))];

%% load block files and create trial object
    sbj_file = strcat('/Volumes/neurology_jparvizi/data/psychData/', block_names{1});
    load(sbj_file)

for i = 1: length(block_names)


end

