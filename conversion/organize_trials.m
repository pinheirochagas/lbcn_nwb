function [organized_trials] = organize_trials(sbj_name, fsample, block_name, dirs, ext_name)
%% Get block names
% when BlockBySubj_nwb.m is done use this:
%block_names = BlockBySubj_nwb.m(sbj_name, task);

%% load files
% file and folder names need to be deidentified
sbj_file = [dirs.psych_root filesep ext_name{1} filesep block_name{1} filesep 'trialinfo_' block_name{1} '.mat'];
load(sbj_file)

%% create trials object and initialize column names
organized_trials = types.core.TimeIntervals();

% colnames shouldn't include start & stop time, these are part of the
% object itself
variables = trialinfo.Properties.VariableNames;
organized_trials.colnames = variables;

%% find start and stop times

% add start & stop time to trialinfo table
trialinfo.start_time = (trialinfo.allonsets * fsample); %dont hardcode

%iterate through each row of trialinfo to check stoptimes
for curr_row = 1:height(trialinfo)
    if trialinfo.condNames{curr_row} == "rest"
        RT = (trialinfo.start_time(curr_row+1) - trialinfo.stop_time(curr_row-1))/fsample -1; % to avoid cloggin while we find the precise duration of rest trials
    elseif trialinfo.RT(curr_row) == 0
        RT = 15;
    else
        RT = trialinfo.RT(curr_row);
    end
    
    trialinfo.stop_time(curr_row) = (trialinfo.allonsets(curr_row) + RT) * fsample;
end

%% Correct non strings in keys 
for i = 1:size(trialinfo,1)
   if isempty(trialinfo.keys{i})
       trialinfo.keys{i} = 'noasnwer';
   else
   end
end

%% create trials from trialinfo

descrip = append(sbj_name, ' block: ', block_name); %general description
organized_trials.description = descrip;

organized_trials.id = types.hdmf_common.ElementIdentifiers('data', 0:height(trialinfo));


%redefine variables to include start & stop time to iterate through entire
%   trialinfo table
variables = trialinfo.Properties.VariableNames;
variable_descriptions = trialinfo.Properties.VariableNames;

for i = 1:length(variables)
    if variables{i} == "start_time"
        organized_trials.start_time = types.hdmf_common.VectorData('data', trialinfo.start_time, 'description', variable_descriptions{i});
    elseif variables{i} == "stop_time"
        organized_trials.stop_time = types.hdmf_common.VectorData('data', trialinfo.stop_time, 'description', variable_descriptions{i});
    else
        curr_col = variables{i};
        if iscell(trialinfo.(variables{i})) == 1
            organized_trials.vectordata.set(curr_col, types.hdmf_common.VectorData('data', char(trialinfo.(variables{i})), 'description', variable_descriptions{i}));
        else
            organized_trials.vectordata.set(curr_col, types.hdmf_common.VectorData('data', trialinfo.(variables{i}), 'description', variable_descriptions{i}));
        end
        
    end
    
    %     'colnames', {'start_time', 'stop_time', 'condNames', 'conds_math_memory', 'isCalc', 'CorrectResult'}, ...
    %     'description', descrip ,...
    %     'id', types.hdmf_common.ElementIdentifiers('data', 0:height(trialinfo)), ...
    %     'start_time', types.hdmf_common.VectorData('data', trialinfo.start_time), ...
    %     'stop_time', types.hdmf_common.VectorData('data', trialinfo.stop_time), ...
    %     'condNames', types.hdmf_common.VectorData('data', trialinfo.condNames), ...
    %     'cond_math_memory', types.hdmf_common.VectorData('data', trialinfo.conds_math_memory), ...
    %     'isCalc', types.hdmf_common.VectorData('data', trialinfo.isCalc), ...
    %     'CorrectResult', types.hdmf_common.VectorData('data', trialinfo.CorrectResult));
    
end