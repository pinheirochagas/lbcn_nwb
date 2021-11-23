function createTrialInfo(nwb, cfg, sbj_name)
%CREATETRIALINFO creates trialinfo file
%   constructs properly formatted trialinfo table with 2 extra
%   columns:start_time & stop_time. Saves trialinfo to psychData.
%
%   INPUTS:
%       nwb: NwbFile type
%       cfg: folder paths 
%       sbj_name: deidentified subject name
% 
%   Laboratory of Behavioral and Cognitive Neuroscience, Stanford University
%   Authors: Pedro Pinheiro-Chagas, Areti Majumdar
%   Copyright: MIT License 2021

start_time = nwb.intervals_trials.start_time.data.load;
stop_time = nwb.intervals_trials.stop_time.data.load;

trialinfo = table(start_time, stop_time);

colnames = nwb.intervals_trials.colnames;

%remove pdio channel
idx = strcmp(colnames, 'Pdio');
colnames(idx) = [];

for j = 1:length(colnames)
    
    curr_name = colnames{j};
    curr_data = nwb.intervals_trials.vectordata.get(curr_name).data.load;
    trialinfo.(curr_name) = string(curr_data);
    
end

% save trial info
save_path = [cfg.psychData '/' sbj_name ];
table_path_format = fullfile(save_path, ['trialinfo_' sbj_name '.mat'])
save(table_path_format, 'trialinfo');

end

