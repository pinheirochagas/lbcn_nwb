function [organized_trials] = organize_trials(sbj_name, task)


%goes through all blocks, creates 'trial' time interval object for each block
%and adds to an array, array will go in intervals_trials group in nwb file
organized_trials = types.core.TimeIntervals.empty;

%% Get block names
% when BlockBySubj_nwb.m is done use this:
%block_names = BlockBySubj_nwb.m(sbj_name, task);

% get info from google sheets till BlockBySubj_nwb.m is done
% Load table
[DOCID,GID] = getGoogleSheetInfo_nwb('nwb_meta_data', 'cohort');
sheet = GetGoogleSpreadsheet(DOCID, GID);

block_names = [sheet.block1(strcmp(sheet.subject_name, sbj_name)), sheet.block2(strcmp(sheet.subject_name, sbj_name))];
ext_name = sheet.subj_name_ext(strcmp(sheet.subject_name, sbj_name));
%% load block files and create trial object


for i = 1: length(block_names)
    
    % file and folder names need to be deidentified 
    sbj_file = strcat('/Volumes/Areti_drive/data/psychData/', ext_name, '/', block_names{i}, '/trialinfo_', block_names{i}, '.mat');
    load(sbj_file{1})

    descrip1 = append(sbj_name, ' block: ', block_names{i});
    descrip2 = append('start time of each trial in block: ', block_names{i});


    trials = types.core.TimeIntervals(...
         'colnames', {'start_time', 'condNames', 'conds_math_memory', 'isCalc', 'CorrectResult'}, ...
         'description', descrip1 ,...
         'id', types.hdmf_common.ElementIdentifiers('data', 0:height(trialinfo)), ...
         'start_time', types.hdmf_common.VectorData('data', trialinfo.allonsets, ...
          'description', descrip2), ...
          'condNames', types.hdmf_common.VectorData('data', trialinfo.condNames), ...
          'cond_math_memory', types.hdmf_common.VectorData('data', trialinfo.conds_math_memory), ...
          'isCalc', types.hdmf_common.VectorData('data', trialinfo.isCalc), ...
          'CorrectResult', types.hdmf_common.VectorData('data', trialinfo.CorrectResult));
   
    organized_trials = [organized_trials, trials];

end



