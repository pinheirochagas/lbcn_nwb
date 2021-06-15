%% Copy data
task = {'MMR'};
subjs_to_copy.MMR = {}; % this is to initiate and copy from excel files

%name of lab computer 
[server_root, comp_root, code_root] = AddPaths('Areti');
comp_root = '/Volumes/LBCN_Pedro/Stanford/data';%replace in lab
dirs = InitializeDirs(' ', ' ', comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'
neuralData_folders = {'all'};

%% Update BlockbySubj first!
for ti = 1:length(task)
    project_name = task{ti};
    block_names_all = {};
    for i = 1:length(subjs_to_copy.(task{ti}))
        block_names_all{i} = BlockBySubj(subjs_to_copy.(task{ti}){i},project_name);
    end
    for i = 1:length(subjs_to_copy.(task{ti}))
        subjs_to_copy.(task{ti}){i}
        block_names_all{i}
        CopySubject(subjs_to_copy.(task{ti}){i}, dirs.psych_root, '/Volumes/Areti_drive/data/psychData', dirs.data_root, '/Volumes/Areti_drive/data/neuralData', neuralData_folders, project_name, block_names_all{i})
    end
end


% Run after having copied on the destination computer
comp_root = '/Volumes/Areti_drive/data';
dirs = InitializeDirs(' ', ' ', comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'
for ti = 1:length(task)
    project_name = task{ti};
    for i = 1:length(subjs_to_copy.(task{ti}))
        block_names = BlockBySubj(subjs_to_copy.(task{ti}){i},project_name); %
        UpdateGlobalVarDirs(subjs_to_copy.(task{ti}){i}, project_name, block_names, dirs)%
    end
end
