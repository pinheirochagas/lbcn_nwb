function [electrode_table, tbl] = get_electrodes(sbj_name)
% creates electrodes table - describes electrodes that generated data



% Load subjVar - once file & folder names are deidentified, won't need to
%reference the googleSheet

% get info from google sheets till BlockBySubj_nwb.m is done
% Load table
[DOCID,GID] = getGoogleSheetInfo_nwb('nwb_meta_data', 'cohort');
sheet = GetGoogleSpreadsheet(DOCID, GID);

% need to deidentify folder/filenames
ext_name = sheet.subj_name_ext(strcmp(sheet.subject_name, sbj_name));

subj_file = strcat('/Volumes/Areti_drive/data/neuralData/originalData/', ...
    ext_name{1}, '/subjVar_', ext_name{1}, '.mat');

load(subj_file);

% start and stop time should be added from organize_trials.m

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

electrode_table = util.table2nwb(tbl, 'all electrodes');