function [electrode_table, tbl] = get_electrodes(sbj_name, dirs, ext_name)
% creates electrodes table - describes electrodes that generated data

subj_file = [dirs.original_data filesep ext_name{1} filesep 'subjVar_' ext_name{1} '.mat'];
load(subj_file);


% add to variables as you add more info
variables = {'x', 'y', 'z', 'imp', 'location', 'filtering', 'label'};
tbl = cell2table(cell(0, length(variables)), 'VariableNames', variables);


for ielec = 1:height(subjVar.elinfo)
    x = subjVar.elinfo.MNI_coord(ielec,1,1);
    y = subjVar.elinfo.MNI_coord(ielec,2,1);
    z = subjVar.elinfo.MNI_coord(ielec,3,1);
    
    imp = 'NaN';
    location = subjVar.elinfo.DK_long_josef{ielec,1}{1};
    filtering = 'common average';
    label = subjVar.elinfo.FS_label{ielec};
    
    tbl = [tbl; {x, y, z, imp, location, filtering, label}];
end


%descrip = ['all electrodes, bad channels: ' globalVar.badChan]

electrode_table = util.table2nwb(tbl, 'all electrodes');