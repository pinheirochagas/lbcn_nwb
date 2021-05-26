%% Generate Schema

% prevents generateCore() from adding two folders in lbcn_nwb
cd '/Volumes/Areti_drive/code/matnwb'
addpath(genpath(pwd));
generateCore();

%% Basic Config
[server_root, comp_root, code_root] = AddPaths('Areti');

%% Retrieve subject information
[DOCID,GID] = getGoogleSheetInfo_nwb('nwb_meta_data', 'cohort');
sheet = GetGoogleSpreadsheet(DOCID, GID);

sbj_names = sheet.subject_name;
sbj_name = sbj_names{end};
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

%% Test write
nwbExport(nwb, 'nwb_practice.nwb')

% go to matnwb folder 
cd('/Volumes/Areti_drive/code/matnwb');
read_nwbfile = nwbRead('/Volumes/Areti_drive/000019/sub-EC2/sub-EC2_ses-EC2-B9.nwb')

%% Electrode table
%stores fields x, y, z, impedence, location, filtering, and electrode_group
%but more can be added

[nwb.general_extracellular_ephys_electrodes, tbl] = get_electrodes(sbj_name);

%% Link
dirs = InitializeDirs(' ', ' ', comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'
data = ConcatenateAll_continuous(sbj_name,task,block_names(1),dirs,[], 'CAR', 'CAR');
load('/Volumes/Areti_drive/data/neuralData/originalData/S13_57_TVD/global_MMR_S13_57_TVD_TVD_08.mat')
for i = 1:128
    if sum(i == globalVar.badChan) == 1
        plot(data.wave(i,:)+(i*1000), 'r')
    else
        plot(data.wave(i,:)+(i*1000), 'k')
    end
    hold on
end


%% Trials
nwb.intervals_trials = organize_trials(sbj_name, data.fsample);

% to access different fields in vectordata, use .get('nameOfField').data
% for example: nwb.intervals_trials(1).vectordata.get('CorrectResult').data
%           will get the first block's 'CorrectResult' data 


electrodes_object_view = types.untyped.ObjectView('/general/extracellular_ephys/electrodes');

% 'table' attribute is a link to another DynamicTable (in this case, the electrodes table, tbl)
% 'data' indicates the rows of the table
electrode_table_region = types.hdmf_common.DynamicTableRegion(...
    'table', electrodes_object_view, ...
    'description', 'all electrodes', ...
    'data', (0:height(tbl)-1)');







