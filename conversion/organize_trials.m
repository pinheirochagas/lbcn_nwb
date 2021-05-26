function [organized_trials] = organize_trials(sbj_name, fsample, block_name, dirs, ext_name)
%% Get block names
% when BlockBySubj_nwb.m is done use this:
%block_names = BlockBySubj_nwb.m(sbj_name, task);

%% load block files and create trial object


% file and folder names need to be deidentified
sbj_file = [dirs.psych_root filesep ext_name{1} filesep block_name{1} filesep 'trialinfo_' block_name{1} '.mat'];
load(sbj_file)

% add start & stop time to trialinfo table
trialinfo.start_time = (trialinfo.allonsets * fsample); %dont hardcode

%iterate through each row of trialinfo to check stoptimes
for curr_row = 1:height(trialinfo)
    if trialinfo.condNames{curr_row} == "rest"
        RT = (trialinfo.start_time(curr_row+1) - trialinfo.stop_time(curr_row-1))/500 -1; % to avoid cloggin while we find the precise duration of rest trials
    elseif trialinfo.RT(curr_row) == 0
        RT = 15;
    else
        RT = trialinfo.RT(curr_row);
    end
    
    trialinfo.stop_time(curr_row) = (trialinfo.allonsets(curr_row) + RT) * fsample;
end



descrip = append(sbj_name, ' block: ', block_name);


organized_trials = types.core.TimeIntervals(...
    'colnames', {'start_time', 'stop_time', 'condNames', 'conds_math_memory', 'isCalc', 'CorrectResult'}, ...
    'description', descrip ,...
    'id', types.hdmf_common.ElementIdentifiers('data', 0:height(trialinfo)), ...
    'start_time', types.hdmf_common.VectorData('data', trialinfo.start_time), ...
    'stop_time', types.hdmf_common.VectorData('data', trialinfo.stop_time), ...
    'condNames', types.hdmf_common.VectorData('data', trialinfo.condNames), ...
    'cond_math_memory', types.hdmf_common.VectorData('data', trialinfo.conds_math_memory), ...
    'isCalc', types.hdmf_common.VectorData('data', trialinfo.isCalc), ...
    'CorrectResult', types.hdmf_common.VectorData('data', trialinfo.CorrectResult));

end 