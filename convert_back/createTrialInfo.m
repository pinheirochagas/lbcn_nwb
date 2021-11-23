function trialinfo = createTrialInfo(nwb, cfg, sbj_name)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

start_time = nwb.intervals_trials.start_time.data.load;
end_time = nwb.intervals_trials.stop_time.data.load;

trialinfo = table(start_time, end_time);

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

