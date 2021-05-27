%% Generate Schema

% prevents generateCore() from adding two folders in lbcn_nwb
cd '/Volumes/Areti_drive/code/matnwb'
addpath(genpath(pwd));
generateCore();

%% Basic Config
[server_root, comp_root, code_root] = AddPaths('Areti');
dirs = InitializeDirs(' ', ' ', comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'

%% Retrieve subject & block information
[DOCID,GID] = getGoogleSheetInfo_nwb('nwb_meta_data', 'cohort');
sheet = GetGoogleSpreadsheet(DOCID, GID);

sbj_names = sheet.subject_name;
sbj_name = sbj_names{end}

% get info from google sheets till info is deidentified, then will be able
% to use sbj_name instead of ext_name
% Load table
[DOCID,GID] = getGoogleSheetInfo_nwb('nwb_meta_data', 'cohort');
sheet = GetGoogleSpreadsheet(DOCID, GID);

% load subjVar file, need to deidentify folder/filenames
ext_name = sheet.subj_name_ext(strcmp(sheet.subject_name, sbj_name)); 

%get block name
block_name = sheet.block1(strcmp(sheet.subject_name, sbj_name))

% for i = 1:length(sbj_names)
%   create_nwb_file(sbj_name)
% end

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
nwb.general_subject

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

trials = types.core.TimeIntervals( ...
    'colnames', {'start_time', 'stop_time', 'correct'}, ...
    'description', 'trial data and properties', ...
    'id', types.hdmf_common.ElementIdentifiers('data', 0:2), ...
    'start_time', types.hdmf_common.VectorData('data', [.1, 1.5, 2.5], ...
   	'description','start time of trial'), ...
    'stop_time', types.hdmf_common.VectorData('data', [1., 2., 3.], ...
   	'description','end of each trial'), ...
    'correct', types.hdmf_common.VectorData('data', [false, true, false], ...
   	'description', 'whether the trial was correct'))
nwb.intervals_trials = trials;


% to access different fields in vectordata, use .get('nameOfField').data
% for example: nwb.intervals_trials(1).vectordata.get('CorrectResult').data
%           will get the first block's 'CorrectResult' data 

%% Link tables
electrodes_object_view = types.untyped.ObjectView('/general/extracellular_ephys/electrodes');

% 'table' attribute is a link to another DynamicTable (in this case, the electrodes table, tbl)
% 'data' indicates the rows of the table
electrode_table_region = types.hdmf_common.DynamicTableRegion(...
    'table', electrodes_object_view, ...
    'description', 'all electrodes', ...
    'data', (0:height(tbl)-1)');

% TODO: add starting time and starting time rate info
electrical_series = types.core.ElectricalSeries( ...
    'starting_time', 0.0, ...
    'starting_time_rate', data.fsample, ...
    'data', data.wave, ...
    'electrodes', electrode_table_region, ...
    'data_unit', 'volts');

% set nwb data
nwb.acquisition.set('ElectricalSeries', electrical_series);

%% Test write
cd '/Volumes/Areti_drive/code/matnwb'
nwbExport(nwb, 'nwb_practice.nwb')

% go to matnwb folder 

read_nwbfile = nwbRead('nwb_practice.nwb')





