%% Generate Schema
addpath '/Volumes/Areti_drive/code/matnwb';
generateCore();

%% Basic Config
[server_root, comp_root, code_root] = AddPaths('Areti');

%% Initialize Directories
project_name = 'MMR';

%% Retrieve subject information
[DOCID,GID] = getGoogleSheetInfo_nwb('nwb_meta_data', 'cohort');
sheet = GetGoogleSpreadsheet(DOCID, GID);

sbj_names = sheet.subject_name
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


% display subject object
subject

% set nwb subject
nwb.general_subject = subject;

%% Test write
nwbExport(nwb, 'nwb_practice.nwb')

% go to matnwb folder 
cd('/Volumes/Areti_drive/code/matnwb');
read_nwbfile = nwbRead('/Volumes/Areti_drive/000019/sub-EC2/sub-EC2_ses-EC2-B9.nwb')

%% Trials
nwb.intervals_trials = organize_trials(sbj_name, nwb.session_description);

% to access different fields in vectordata, use .get('nameOfField').data
% for example: nwb.intervals_trials(1).vectordata.get('CorrectResult').data
%           will get the first block's 'CorrectResult' data 



