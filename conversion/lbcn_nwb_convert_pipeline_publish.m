

sbj_name = 'S13_57';
task = 'MMR'

%% Configure
cfg = configure_nwb();

%display cfg
cfg
%% Link Google Spreadsheet with subject information
% Access to google sheet

[DOCID,GID] = getGoogleSheetInfo_nwb('nwb_meta_data', 'cohort');
sheet = GetGoogleSpreadsheet(DOCID, GID);

%% Retrieve subject & block information
% Retrieves full subject name (ext_name) and block name to be converted

[block_name, ext_name] = get_names(sheet, sbj_name);

%% Load Files
% Load files with data to be added to nwb - subject demographics,
%   global variables, etc.
glob_file = [cfg.dirs.original_data filesep ext_name{1} filesep 'global_MMR_' ext_name{1} '_' block_name{1} '.mat'];
load(glob_file);

subjVars = [cfg.dirs.original_data filesep ext_name{1} filesep 'subjVar_' ext_name{1} '.mat'];
load(subjVars);

%% Initialize nwb file
% Create nwb file object

% initializes nwb file with general information like institution,
%   keywords, etc 
nwb = initialize_nwb(sbj_name, sheet);

%nwb object
nwb
%% Subject Information
% Adds subject demographic information - 
%   aka age, DOB, description, genotype, sex, species, subj_id 
nwb.general_subject = get_subject(sbj_name, sheet);

%subject object
nwb.general_subject

%% Concatenate block data
% Concatenates data from all electrodes and returns struct of data &
%   sampling rate
data = ConcatenateAll_continuous(sbj_name, block_name, cfg.dirs,[], cfg.datatype, cfg.freq_band, ext_name);

%structure of data
data

% Displays eeg data for all electrode channels with bad channels  displayed in red
visualize_channels_data(data, globalVar, subjVar)
%% Electrode table
% Stores fields like x, y, z, left or right hemisphere, impedence, location, filtering, and electrode_group - more fields can be added

[nwb.general_extracellular_ephys_electrodes, tbl] = get_electrodes(sbj_name,cfg.dirs, ext_name, cfg, block_name);

%electrode information in table format
tbl(1:5, :)

%electrode information in dynamic table format
nwb.general_extracellular_ephys_electrodes

%colnames and description can be accessed with dot operator
nwb.general_extracellular_ephys_electrodes.colnames

%vector data (and other types.untyped.Set data) can be accessed with getter functions. For example, the data in
%'label' can be accessed with:
nwb.general_extracellular_ephys_electrodes.vectordata.get('label').data(1:10)

%% Link tables & add eeg data
% Stores the raw acquired data, we put the raw data that is downsampled
%   to 1000 hz
electrical_series = add_eeg_data(tbl, data);

% set nwb data
nwb.acquisition.set('ElectricalSeries', electrical_series);

%eeg data accessed through nwb file:
nwb.acquisition.get('ElectricalSeries')


%% Trials
% Trial information like start and stop times, response, etc

% To access different fields in vectordata, use .get('nameOfField').data - 
% for example: nwb.intervals_trials(1).vectordata.get('CorrectResult').data
%           will get the first block's 'CorrectResult' data 

nwb.intervals_trials = organize_trials(sbj_name, data.fsample, block_name, cfg.dirs, ext_name, data);

%organized trials object
nwb.intervals_trials

%types.hdmf_common.VectorData and types.hdmf_common.ElementIdentifiers can be accessed with dot operators:
nwb.intervals_trials.start_time.data(1:10)

%types.untyped.Set can be accessed with getter functions
nwb.intervals_trials.vectordata.get('isCalc').data(1:10)

%Photodiode channel added to nwb.intervals_trials, to plot photodiode data use:
close all;
plot(nwb.intervals_trials.vectordata.get('Pdio').data);

%% Create cortical surface
cortical_surface = convert_cortical_surface(ext_name, cfg.dirs);

% set in subject portion of nwb
nwb.general_subject = types.ndx_ecog.ECoGSubject('subject', cortical_surface);

%the different cortical surfaces can be accessed with:
nwb.general_subject.corticalsurfaces.value.surface

%the left cortical surface information can be accessed with:
nwb.general_subject.corticalsurfaces.value.surface.get('left')

%visualize electrodes on cortical surface:
visualizecortex_pipeline(nwb, 'left', 'lateral')


%% Convert volumes
volumes_module = add_volumes(subjVar);

%set in processing modules
nwb.processing.set('Volumes', volumes_module);

%Volumes data
nwb.processing.get('Volumes').nwbdatainterface.get('grayscale_volume')

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

%% Visualization
% Once the nwb file is exported, it can be read in to visualize electrodes
% on the cortical surface
visualizecortex('nwb_TVD_08.nwb', 'left', 'lateral')

