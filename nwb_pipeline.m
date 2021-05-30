%% Generate Schema

% prevents generateCore() from adding two folders in lbcn_nwb
cd '/Volumes/Areti_drive/code/matnwb'
addpath(genpath(pwd));
generateCore();

%% Basic Config
[server_root, comp_root, code_root] = AddPaths('Areti');
dirs = InitializeDirs(' ', ' ', comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'

%% Link Google Spreadsheet with subject information
[DOCID,GID] = getGoogleSheetInfo_nwb('nwb_meta_data', 'cohort');
sheet = GetGoogleSpreadsheet(DOCID, GID);

%% Retrieve subject & block information
[sbj_name, block_name, ext_name] = get_names(sheet);

%% Set up NWB file
nwb = NwbFile();
nwb.general_institution = 'Stanford';
[nwb.session_description, nwb.general_keywords, nwb.session_start_time] = get_task(sbj_name);
nwb.general_session_id = sbj_name;
nwb.identifier = sbj_name;
nwb.general_source_script_file_name	= 'nwb_pipeline.m';

% display nwb object
nwb

%% Subject Information
% what subject info to include
%   aka age, DOB, description, genotype, sex, species, subj_id -
%   deidentified, no initials

% load in global variable and read in demographics
subject = types.core.Subject();

subject.subject_id = sbj_name;
subject.species = 'Homo sapiens';

% add birth_date? 
[subject.sex, subject.age] = get_subject(sbj_name);

% set nwb subject
nwb.general_subject = subject;

%% Concatenate block data
data = ConcatenateAll_continuous(sbj_name,nwb.session_description,block_name,dirs ,[], 'CAR', 'CAR', ext_name);

% load globalVars
glob_file = [dirs.original_data filesep ext_name{1} filesep 'global_MMR_' ext_name{1} '_' block_name{1} '.mat'];
load(glob_file);

% display EEG data for all channels, noisy channels shown in red
for i = 1:128
    if sum(i == globalVar.badChan) == 1
        plot(data.wave(i,:)+(i*1000), 'r')
    else
        plot(data.wave(i,:)+(i*1000), 'k')
    end
    hold on
end

%% Electrode table
%stores fields x, y, z, impedence, location, filtering, and electrode_group
%but more can be added

[nwb.general_extracellular_ephys_electrodes, tbl] = get_electrodes(sbj_name, dirs, ext_name);
tbl


%% Trials
nwb.intervals_trials = organize_trials(sbj_name, data.fsample, block_name, dirs, ext_name);
nwb.intervals_trials

% to access different fields in vectordata, use .get('nameOfField').data
% for example: nwb.intervals_trials(1).vectordata.get('CorrectResult').data
%           will get the first block's 'CorrectResult' data 

%% Link tables & add eeg data
electrical_series = add_eeg_data(tbl, data);

% set nwb data
nwb.acquisition.set('ElectricalSeries', electrical_series);

%% Test write
cd '/Volumes/Areti_drive/code/matnwb'
nwbExport(nwb, 'nwb_practice.nwb')

% go to matnwb folder 

read_nwbfile = nwbRead('nwb_practice.nwb')





