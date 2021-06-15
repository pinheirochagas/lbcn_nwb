sbj_name = 'S13_57';
task = 'MMR'



cfg = [];
cfg.dirs = dirs;
cfg.dirs.output_nwb = '/Volumes/Areti_drive/code/lbcn_nwb/output_nwb';
cfg.save = true;
cfg.datatype = 'CAR';% 'HFB', 'RAW'
cfg.freq_band = 'CAR';% 'HFB', 'RAW'
cfg.visualize_channels = true; % display all channels w/ bad channels shown in red
cfg.vol_to_planes = false; %convert volumes to planes 
cfg.plot_elec = false; %plot electrodes; % display all channels w/ bad channels shown in red
cfg.vol_to_planes = false; %convert volumes to planes 
cfg.plot_elec = false; %plot electrodes


% comment this whole thing a bunchhhh

%% Link Google Spreadsheet with subject information
[DOCID,GID] = getGoogleSheetInfo_nwb('nwb_meta_data', 'cohort');
sheet = GetGoogleSpreadsheet(DOCID, GID);

%% Retrieve subject & block information
[block_name, ext_name] = get_names(sheet, sbj_name);

%% load globalVars & subjVars
glob_file = [cfg.dirs.original_data filesep ext_name{1} filesep 'global_MMR_' ext_name{1} '_' block_name{1} '.mat'];
load(glob_file);

subjVars = [cfg.dirs.original_data filesep ext_name{1} filesep 'subjVar_' ext_name{1} '.mat'];
load(subjVars);

%% Initialize nwb file
nwb = initialize_nwb(sbj_name, sheet);
nwb
%% Subject Information
% what subject info to include
%   aka age, DOB, description, genotype, sex, species, subj_id -
%   deidentified, no initials
nwb.general_subject = get_subject(sbj_name, sheet);

%% Concatenate block data
data = ConcatenateAll_continuous(sbj_name, block_name, cfg.dirs,[], cfg.datatype, cfg.freq_band, ext_name);

%% For visualization - display data for all channels with bad channels in red


if cfg.visualize_channels
    visualize_channels(data, globalVar)
end

%% Electrode table
%stores fields x, y, z, impedence, location, filtering, and electrode_group
%but more can be added

[nwb.general_extracellular_ephys_electrodes, tbl] = get_electrodes(sbj_name, cfg.dirs, ext_name);

%% Trials
% to access different fields in vectordata, use .get('nameOfField').data
% for example: nwb.intervals_trials(1).vectordata.get('CorrectResult').data
%           will get the first block's 'CorrectResult' data 

nwb.intervals_trials = organize_trials(sbj_name, data.fsample, block_name, cfg.dirs, ext_name);

%% Link tables & add eeg data
electrical_series = add_eeg_data(tbl, data);

% set nwb data
nwb.acquisition.set('ElectricalSeries', electrical_series);

%% Create cortical surface
cortical_surface = convert_cortical_surface(ext_name, cfg.dirs);

% set in subject portion of nwb
nwb.general_subject = types.ndx_ecog.ECoGSubject('subject', cortical_surface);

%visualizecortex(cortical_surface);

%% Convert volumes
volumes_module = add_volumes(subjVar);

%set in processing modules
nwb.processing.set('Volumes', volumes_module);

% convert volumes to planes & visualize
if cfg.vol_to_planes
    volumes = nwb.processing.get('Volumes').nwbdatainterface.get('grayscale_volume').data;
    convert_volumes_planes(volumes, cfg.plot_elec);
end
%% Export file
if cfg.save == true
    cd(cfg.dirs.output_nwb)
    ofile = ['nwb_' block_name{1} '.nwb']
    nwbExport(nwb, ofile)
else
end


