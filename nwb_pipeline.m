%% Generate Schema
cd '/Volumes/Areti_drive/code/matnwb'
generateExtension('/Volumes/Areti_drive/code/ndx-ecog/spec/ndx-ecog.namespace.yaml');
generateExtension('/Volumes/Areti_drive/code/ndx-grayscalevolume/spec/ndx-grayscalevolume.namespace.yaml');
% prevents generateCore() from adding two folders in lbcn_nwb
addpath(genpath(pwd));
generateCore();

%% Basic Config
[server_root, comp_root, code_root] = AddPaths('Areti');
dirs = InitializeDirs(' ', ' ', comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'

%% Link Google Spreadsheet with subject information
[DOCID,GID] = getGoogleSheetInfo_nwb('nwb_meta_data', 'cohort');
sheet = GetGoogleSpreadsheet(DOCID, GID);

%% Convert data
%cfg = get_nwb_cfg(task) % default values
%cfg.save = false;
%lbcn_nwb_convert(sbj_name, task, cfg)


cfg = [];
cfg.dirs = dirs;
cfg.dirs.output_nwb = '/Volumes/Areti_drive/code/lbcn_nwb';
cfg.save = true;
cfg.datatype = 'CAR'% 'HFB', 'RAW'
cfg.freq_band = 'CAR'% 'HFB', 'RAW'
cfg.visualize_channels = false % display all channels w/ bad channels shown in red

%iterate through subjects and blocks and create nwb files

for i = 1:size(sheet, 1)
    sbj_name = sheet.subject_name{i};
    task = sheet.task{i};
    lbcn_nwb_convert(sbj_name, task, cfg)
end 




