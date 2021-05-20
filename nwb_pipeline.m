%% Generate Schema
addpath '/Volumes/Areti_drive/code/matnwb';
generateCore();

%% Basic Config
[server_root, comp_root, code_root] = AddPaths('Areti');

%% Initialize Directories
project_name = 'MMR';

%% Retrieve subject information
sbj_name ='S13_57'
% center = googleSheet.center{sbj_number};
center = 'Stanford'

%% Set up NWB file
% what other file info to include
% all possibilities listed here: https://neurodatawithoutborders.github.io/matnwb/doc/+types/+core/NWBFile.html
nwb = NwbFile( ...
    'session_description', 'MMR', ...
    'identifier', sbj_name, ... %make sure deidentified
    'session_start_time', datetime(2013, 10, 18), ... % what if theres multiple dates?
    'general_institution', center, ...
    'general_keywords', project_name);

% display nwb object
nwb

%% Subject Information
% what subject info to include
%   aka age, DOB, description, genotype, sex, species, subj_id -
%   deidentified, no initials

% load in global variable and read in demographics

subject = types.core.Subject( ...
    'subject_id', sbj_name, ...
    'species', 'Homo sapiens');     % add any other subject info

% display subject object
subject

% set nwb subject
nwb.general_subject = subject;

%% Test write
nwbExport(nwb, 'nwb_practice.nwb')
read_nwbfile = nwbRead('nwb_practice.nwb')

%% Trials
nwb.trial = organize_trials(sbj_name, task);

%goes through all blocks, creates 'trial' time interval object for each block
%and adds to an array, array will go in intervals_trials group in nwb file

block_array = types.core.TimeIntervals.empty;

for block_num = 1:4
    switch block_num
        case 1
            descrip1 = 'block 08 trial data and properties';
            load('/Volumes/Areti_drive/data/psychData/S13_57_TVD/TVD_08/trialinfo_TVD_08.mat');
            descrip2 = 'start time of each trial in block 1';
        case 2 
            descrip1 = 'block 10 trial data and properties';
            load('/Volumes/Areti_drive/data/psychData/S13_57_TVD/TVD_10/trialinfo_TVD_10.mat');
            descrip2 = 'start time of each trial in block 2';
        case 3
            descrip1 = 'block 13 trial data and properties';
            load('/Volumes/Areti_drive/data/psychData/S13_57_TVD/TVD_13/trialinfo_TVD_13.mat');
            descrip2 = 'start time of each trial in block 3';
        case 4
            descrip1 = 'block 14 trial data and properties';
            load('/Volumes/Areti_drive/data/psychData/S13_57_TVD/TVD_14/trialinfo_TVD_14.mat');
            descrip2 = 'start time of each trial in block 4';
    end
    
    trials = types.core.TimeIntervals(...
    'colnames', {'start_time', 'stop_time'}, ...
    'description', descrip1 ,...
    'id', types.hdmf_common.ElementIdentifiers('data', 0:height(trialinfo)), ...
    'start_time', types.hdmf_common.VectorData('data', trialinfo.allonsets, ...
       'description', descrip2));
   
   block_array = [block_array, trials];
    
end

%intervals_trials holds trial start_time info for each block
nwb.intervals_trials = block_array;