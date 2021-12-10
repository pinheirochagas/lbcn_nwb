%% Generate Schema
cd '/Volumes/Areti_drive/code/matnwb'
generateExtension('/Volumes/Areti_drive/code/ndx-ecog/spec/ndx-ecog.namespace.yaml');
generateExtension('/Volumes/Areti_drive/code/ndx-grayscalevolume/spec/ndx-grayscalevolume.namespace.yaml');
% prevents generateCore() from adding two folders in lbcn_nwb
addpath(genpath(pwd));
generateCore();

%% Link Google Spreadsheet with subject information
[DOCID,GID] = getGoogleSheetInfo_nwb('nwb_meta_data', 'cohort');
sheet = GetGoogleSpreadsheet(DOCID, GID);

%% Convert data
cfg = configure_nwb();


%iterate through subjects and blocks and create nwb files

for i = 1:size(sheet, 1)
    for round = 1:2
        nwb = lbcn_nwb_convert(sheet.de_name{i}, sheet.task{i}, cfg, round);
    end
end 

%% Plot cortex with electrodes
 visualizecortex('nwb_S1-1.nwb', 'left', 'lateral')