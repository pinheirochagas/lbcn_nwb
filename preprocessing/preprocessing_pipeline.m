%% Branch 1. basic config - PEDRO
addpath(genpath('/Users/pinheirochagas/Pedro/Stanford/code/paper_math_network/'))
addpath(genpath('/Users/pinheirochagas/Pedro/Stanford/code/lbcn_personal/'))
addpath(genpath('/Users/pinheirochagas/Pedro/Stanford/code/lbcn_preproc/'))
AddPaths('Pedro_iMAC');


parpool(16) % initialize number of cores

%% Initialize Directories
project_name = 'MMR';
project_name = 'UCLA';

project_name = 'MFA';
project_name = '7Heaven';

project_name = 'Scrambled';
project_name = 'Logo';
project_name = 'VTCLoc';
project_name = 'Animal_localizer';

project_name = 'Calculia';
project_name = 'Context';

project_name = 'Memoria';
project_name = 'Memoria_stim';


project_name = 'Calculia_production';
project_name = 'Calculia_production_addsubmult';

project_name = 'Calculia_production_stim'

project_name = 'Calculia_China';


project_name = 'Calculia_verification_digit';

project_name = 'Calculia_letter';

project_name = 'Number_comparison';

project_name = 'Flanker';
project_name = 'EglyDriver';
project_name = 'EglyDriver_stim';

project_name = 'NumLet';
project_name = 'GradCPT';

project_name = 'Rest'
project_name = 'ReadNumWord'


%% Retrieve subject information
% sbj_name = 'S18_124';

sbj_name ='S21_165_WN'

% center = googleSheet.center{sbj_number};
center = 'Stanford'
%% Get block names
block_names = BlockBySubj(sbj_name,project_name)
% Manually edit this function to include the name of the blocks:
% Make sure your are connected to CISCO and logged in the server
server_root = '/Volumes/neurology_jparvizi$/';
% comp_root = '/Volumes/NeuroSpin4T/Stanford/data';
comp_root = '/Volumes/LBCN8T/Stanford/data';

code_root = '/Users/pinheirochagas/Pedro/Stanford/code/lbcn_preproc/';
dirs = InitializeDirs(project_name, sbj_name); % 'Pedro_NeuroSpin2T'


%% Get iEEG and Pdio sampling rate and data format
[fs_iEEG, fs_Pdio, data_format] = GetFSdataFormat(sbj_name, center);

%% Create subject folders
CreateFolders(sbj_name, project_name, block_names, center, dirs, data_format, 'auto')

%% Copy the iEEG and behavioral files from server to local folders
for i = 1:length(block_names)
    CopyFilesServer(sbj_name,project_name,block_names{i},data_format,dirs)
end
% In the case of number comparison, one has also to copy the stim lists


%% Branch 2 - data conversion - PEDRO
ref_chan = [];
epi_chan = [];
empty_chan = [];

if strcmp(data_format, 'edf')
    SaveDataNihonKohden(sbj_name, project_name, block_names, dirs, ref_chan, epi_chan, empty_chan) %
elseif strcmp(data_format, 'TDT')
    SaveDataDecimate(sbj_name, project_name, block_names, fs_iEEG, fs_Pdio, dirs, ref_chan, epi_chan, empty_chan) %% DZa 3051.76
else
    error('Data format has to be either edf or TDT format')
end


%% Convert berhavioral data to trialinfo
switch project_name
    case 'Calculia_SingleDigit'
        %         OrganizeTrialInfoMMR(sbj_name, project_name, block_names, dirs) %%% FIX TIMING OF REST AND CHECK ACTUAL TIMING WITH PHOTODIODE!!! %%%
        OrganizeTrialInfoCalculia(sbj_name, project_name, block_names, dirs) %%% FIX ISSUE WITH TABLE SIZE, weird, works when separate, loop clear variable issue
    case 'UCLA'
        OrganizeTrialInfoUCLA(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds? INCLUDE REST!!!
    case 'MMR'
        OrganizeTrialInfoMMR_rest(sbj_name, project_name, block_names, dirs) %%% FIX ISSUE WITH TABLE SIZE, weird, works when separate, loop clear variable issue
    case {'Memoria', 'Memoria_stim'}
        language = 'english'; % make this automnatize by sbj_name
        OrganizeTrialInfoMemoria(sbj_name, project_name, block_names, dirs, language)
    case {'Calculia_China', 'Calculia_letter'}
        OrganizeTrialInfoCalculiaChina(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
    case {'Calculia_verification_digit', 'Calculia_verification_letter'}
        OrganizeTrialInfoCalculiaChina(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
        
        
    case {'Calculia_production', 'Calculia_production_addsubmult'}
        OrganizeTrialInfoCalculia_production(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
case 'Calculia_production_stim'
        OrganizeTrialInfoCalculia_production(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?        
        
    case 'Number_comparison'
        OrganizeTrialInfoNumber_comparison(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
    case 'MFA'
        OrganizeTrialInfoMFA(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
    case 'Calculia'
        OrganizeTrialInfoCalculia_combined(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
    case 'Context'
        OrganizeTrialInfoContext(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?        
    case 'EglyDriver'
        OrganizeTrialInfo_EglyDriver(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
        
    case 'VTCLoc'
        OrganizeTrialInfoVTC(sbj_name, project_name, block_names, dirs)
    case 'GradCPT'
        OrganizeTrialInfoGradCPT(sbj_name, project_name, block_names, dirs,1,'1')
        
end



%% Branch 3 - event identifier
if strcmp(project_name, 'Number_comparison')
    event_numcomparison_current(sbj_name, project_name, block_names, dirs, 1) %% MERGE THIS
    % elseif strcmp(project_name, 'Memoria')
    %     EventIdentifier_Memoria(sbj_name, project_name, block_names(3), dirs) % new ones, photo = 1; old ones, photo = 2; china, photo = varies, depends on the clinician, normally 9.)
elseif strcmp(project_name, 'EglyDriver')
    if strcmp(sbj_name, 'S20_148_SM')
        EventIdentifier_EglyDriver_separate_trigger_channels(sbj_name, project_name, block_names, dirs, 5)
    else
        EventIdentifier_EglyDriver(sbj_name, project_name, block_names, dirs, 5) % always 5 because of iES
    end
else
    EventIdentifier(sbj_name, project_name, block_names(1), dirs,2) % new ones, photo = 1; old ones, photo = 2; china, photo = varies, depends on the clinician, normally 9, mic = 2
end

% 
% %% Segment audio mic and update trialinfo
% %(in the case of Calculia production and number concatenation)
% bn = block_names{1};
% % Load globalVar
% load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,bn));    
% % Load mic
% load(sprintf('%s/Pdio%s_%.2d.mat',globalVar.originalData, bn, 2)); % going to be present in the globalVar
% % Load trialinto
% load([globalVar.psych_dir '/trialinfo_', bn '.mat'], 'trialinfo');
% % Manually annotate and save or load existing
% % audioMic_App(anlg,fs,trialinfo)
% load([globalVar.psych_dir '/transcript_', bn '.mat']);
% 
% % Correct for empty and nans
% if sum(cellfun(@isempty, trigger_labels)) ~= 0
%     trigger_labels{cellfun(@isempty, trigger_labels)} = 'NaN';
% else
% end
% trigger_ts(contains(trigger_labels, 'NaN'),:) = nan;
% save([globalVar.psych_dir '/transcript_', bn '.mat'], 'trigger_labels', 'trigger_ts')
% % update trialinfo
% trialinfo.RT_resp = trigger_ts/globalVar.Pdio_rate;
% trialinfo.RT = trialinfo.RT_resp(:,1) - trialinfo.allonsets(:,3);
% trialinfo.RT_lock = trialinfo.RT_resp(:,1);
% trialinfo.resp = cellfun(@str2num, trigger_labels)';
% switch project_name
%     case 'Calculia_production'
%         trialinfo.deviation = trialinfo.resp - trialinfo.result;
%         trialinfo.abs_deviation = abs(trialinfo.deviation);
%         trialinfo.Accuracy = double(trialinfo.deviation==0);
%     case 'Number concatenation'     
% end
% save([globalVar.psych_dir '/trialinfo_', bn '.mat'], 'trialinfo');


%% Branch 4 - bad channel rejection
% [refChan, badChan, epiChan, emptyChan] = GetMarkedChans(sbj_name);
load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,block_names{1}));
ref_chan = [];
epi_chan = [];
empty_chan = []; % INCLUDE THAT in SaveDataNihonKohden SaveDataDecimate

BadChanRejectCAR(sbj_name, project_name, block_names, dirs)

%% Branch 5 - Time-frequency analyses
% Load elecs info
load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,block_names{1}),'globalVar');
elecs = setdiff(1:globalVar.nchan,globalVar.refChan);
% 
% case 'Delta'
%         freqs = 2.^(-1:0.4:1.8);
%     case 'Theta'
%         freqs = 2.^(2:0.2:2.8);
%     case 'Alpha'
%         freqs = 2.^(3:0.2:4) - 0.9;
%     case 'Beta'
%         freqs = 2.^(4:0.2:5) - 0.1;
%     case 'Gamma'
%         freqs = 2.^(5:0.2:5.9);



for i = 1:length(block_names)
    parfor ei = 1:length(elecs)
%         WaveletFilterAll(sbj_name, project_name, block_names{i}, dirs, elecs(ei), 'HFB', [], [], [], 'Band') % only for HFB
        WaveletFilterAll(sbj_name, project_name, block_names{i}, dirs, elecs(ei), 'Spec', [], [], true, 'Spec') % across frequencies of interest
    end
end

%% Branch 6 - Epoching, identification of bad epochs and baseline correction
epoch_params = genEpochParams(project_name, 'stim');
epoch_params.noise.method = 'trials';
for i = 1:length(block_names)
    bn = block_names{i};
    parfor ei = 1:length(elecs)
                  EpochDataAll(sbj_name, project_name, bn, dirs,elecs(ei), 'HFB', [],[], epoch_params,'Band')
         %EpochDataAll(sbj_name, project_name, bn, dirs,elecs(ei), 'CAR', [],[], epoch_params,'CAR')
        %                    EpochDataAll(sbj_name, project_name, bn, dirs,elecs(ei), 'SpecDense', [],[], epoch_params,'Spec')
    end
end

epoch_params = genEpochParams(project_name, 'resp');
for i = 1:length(block_names)
    bn = block_names{i};
    parfor ei = 1:length(elecs)
         EpochDataAll(sbj_name, project_name, bn, dirs,elecs(ei), 'HFB', [],[], epoch_params,'Band')
%          EpochDataAll(sbj_name, project_name, bn, dirs, elecs(ei), 'SpecDense', [],[], epoch_params,'Spec')
    end
end

sbj_names = {}

sinfo_MMR = sinfo(strcmp(sinfo.task, 'MMR'),:);
sinfo_UCLA = sinfo(strcmp(sinfo.task, 'UCLA'),:);
sinfo_sim = [sinfo_MMR; sinfo_UCLA];

s = 'S20_152_HT'
t = 'Memoria'
    analyseMultipleSubjects(s, t, dirs, 0,1,0) % project_name{i}

%  Multiple subjects
for i = 1:size(sinfo_seq,1)
    analyseMultipleSubjects(sinfo_seq.sbj_name{i}, sinfo_seq.task{i}, dirs, 0,1,0) % project_name{i}
end
% update globals:
% S15_91_RP
sbj_names{6} = 'S19_139_JRb' missing
and missing trialinfo for 137 blocks 51 and 54

% %Error using EpochDataAll (line 176)
% Reference to non-existent field 'pathological_event_bipolar_montage'.
% 
% Error in analyseMultipleSubjects (line 28)
%         parfor ei = 1:length(elecs)
%   'S17_118_TW'

%% DONE PREPROCESSING.
% Eventually replace globalVar to update dirs in case of working from an
% with an external hard drive
%UpdateGlobalVarDirs(sbj_name, project_name, block_name, dirs)


%% Branch 7 - Plotting
% plot avg. HFB timecourse for each electrode separately
% plot individual trials (to visualize bad trials)
% plot_params = genPlotParams(project_name,'timecourse');
% plot_params.single_trial = true;
% plot_params.noise_method = 'trials'; %'trials','timepts','none'
% % plot_params.noise_fields_timepts = {'bad_epochs_HFnO','bad_epochs_raw_HFspike'};
% plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
% plot_params.textsize = 10;
% PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames',[],plot_params,'Band')
plot_params = genPlotParams(project_name,'timecourse');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
% plot_params.xlines = [.5 1.2];
% plot_params.col = [cdcol.ultramarine;
%             cdcol.yellow_green;% PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames',[],plot_params,'Band')
plot_params = genPlotParams(project_name,'timecourse');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
% plot_params.xlines = [.5 1.2];
% plot_params.col = [cdcol.ultramarine;
%             cdcol.yellow_green;
%             cdcol.carmine;
%             cdcol.yellow]
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames', [], plot_params,'Band') % condNames
%             cdcol.carmine;
%             cdcol.yellow]
plot_params.xlim = [-0.850 0.2];
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','resp','condNames', [], plot_params,'Band') % condNames




PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames', [], plot_params,'Band') % condNames


PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','correctness', {'correct', 'incorrect'}, plot_params,'Band') % condNames


PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','resp','CondNamesCueLoc', {'target_present_cue_left', 'target_present_cue_right'}, plot_params,'Band') % condNames

conds_min
plot_params.xlim = [-0.850 0.2];
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','resp','condNames', [], plot_params,'Band') % condNames



%% Egly 
plot_params = genPlotParams(project_name,'timecourse');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','CondNamesCueLoc', {'target_present_cue_left', 'target_present_cue_right'}, plot_params,'Band') % condNames
plot_params.xlim = [-0.850 0.2];
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','resp','CondNamesCueLoc', {'target_present_cue_left', 'target_present_cue_right'}, plot_params,'Band') % condNames



% plot_params.noise_method = 'none';

plot_params = genPlotParams(project_name,'RTSort');
plot_params.xlim = [-0.5 8.5];
plot_params.sort_column =  'RT';
plot_params.plot_slist = 1;
plot_params.xlabel = 'Time (sec)';
plot_params.textsize = 20;
plot_params.video = false;
plot_params.group_conds = 'Operand2';
plot_params.sort_columns = {'Operand2', 'mathtype', 'RTLock'};
PlotTrialRTSortedAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','condNames',{'math'},'Band', plot_params)
% 
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','CondNamesCueLoc', {'target_present_cue_left', 'target_present_cue_right'}, plot_params,'Band') % condNames
% PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,chan,'HFB','stim','CondNamesCueLoc', {'target_present_right', 'target_present_left'}, plot_params,'Band') % condNames
% 
% 
% chan = find(strcmp(subjVar.labels_EDF,'LM9'))
% PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,chan,'HFB','stim','condNames', {'math', 'autobio'}, plot_params,'Band') % condNames
% 
% 
% 
% % plot avg. HFB timecourse for each electrode separately
% plot_params = genPlotParams(project_name,'timecourse');
% plot_params.correct_label = 0;
% plot_params.FS_labels = subjVar.elinfo.FS_label;
% 
% plot_params.noise_method = 'trials'; %'trials','timepts','none'
% plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
% 
% plot_params.col = [cdcol.ultramarine;
%             cdcol.carmine];
% plot_params.xlim(2) = 5.5       
% plot_params.legend = 0
% PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,chan,'HFB','stim','condNames', {'autobio', 'math'}, plot_params,'Band') % condNames
% 
% 
% 
% 
% chan = find(strcmp(subjVar.elinfo.FS_label,'VPG30'))
% plot_params.noise_method = 'none'; %'trials','timepts','none'
% plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
% 
% plot_params.single_trial =1
% plot_params.ylim_min = 20
% plot_params.ylabel = 'HFB'
% plot_params.textsize = 12;
% 
% plot_params.correct_label = 1;
% plot_params.FS_labels = subjVar.elinfo.FS_label;
% 
% 
% PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames', [], plot_params,'Band') % condNames
% 
% PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,chan,'HFB','stim','condNames', {'numbers'} , plot_params,'Band') % condNames
% 
% 
% 
% plot_params.ylabel = 'z-scored HFB power'
% plot_params.legend = 0
% 
% % 
% % conds_plot = {'number_digit_1', 'number_digit_2', 'number_digit_3', 'number_digit_4'}
% % conds_plot = {'brightness_digit_1', 'brightness_digit_2', 'brightness_digit_3', 'brightness_digit_4'}
% 
% % PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','conds_num_lum_digit_dot_distance',conds_plot,plot_params,'Band') % condNames
% 
% plot_params.xlim = [-.2 1.5]
% plot_params.col = parula(4);
% PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,find(strcmp(subjVar.labels_EDF, 'LK10')),'HFB','stim','conds_min', [], plot_params,'Band') % condNames
% 
% 

%% Copy data
task = {'Scrambled', 'Logo', 'VTCLoc', 'SevenHeaven', 'ReadNumWord'};
task = {'VTCLoc'};
subjs_to_copy.Context = {}
subjs_to_copy.Scrambled = {}; % this is to initiate and copy from excel files
subjs_to_copy.Logo = {}; % this is to initiate and copy from excel files
subjs_to_copy.VTCLoc = {}; % this is to initiate and copy from excel files
subjs_to_copy.SevenHeaven = {}; % this is to initiate and copy from excel files
subjs_to_copy.ReadNumWord = {}; % this is to initiate and copy from excel files
subjs_to_copy.AllCateg = {}; % this is to initiate and copy from excel files
subjs_to_copy.Calculia_China = {}; % this is to initiate and copy from excel files
subjs_to_copy.Calculia_letter = {}; % this is to initiate and copy from excel files
subjs_to_copy.Calculia = {}; % this is to initiate and copy from excel files
subjs_to_copy.Calculia_production = {}; % this is to initiate and copy from excel files
subjs_to_copy.MMR = {}; % this is to initiate and copy from excel files
subjs_to_copy.Memoria = {}; % this is to initiate and copy from excel files
subjs_to_copy.Number_comparison = {}; % this is to initiate and copy from excel files
subjs_to_copy.EglyDriver = {}
subjs_to_copy.MFA = {}; % this is to initiate and copy from excel files

subjs_to_copy.VTCLoc = 


% comp_root = '/Volumes/SRI_LBCN/Stanford/data';
%comp_root = '/Volumes/CSS_backup/data';
dirs = InitializeDirs(' ', ' ', comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'
neuralData_folders = {''};

%% Update BlockbySubj first!
for ti = 1:length(task)
    project_name = task{ti};
    block_names_all = {};
    for i = 1:length(subjs_to_copy.(task{ti}))
        block_names_all{i} = BlockBySubj(subjs_to_copy.(task{ti}){i},project_name);
    end
    for i = 7:length(subjs_to_copy.(task{ti}))
        subjs_to_copy.(task{ti}){i}
        block_names_all{i}
        CopySubject(subjs_to_copy.(task{ti}){i}, dirs.psych_root, '/Volumes/LBCN8T/Stanford/data/psychData', dirs.data_root, '/Volumes/LBCN8T/Stanford/data/neuralData', neuralData_folders, project_name, block_names_all{i})
    end
end


% Run after having copied on the destination computer
comp_root = '/Volumes/LBCN8T/Stanford/data';
dirs = InitializeDirs(project_name, subjs_to_copy.VTCLoc{1}, comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'
for ti = 1:length(task)
    project_name = task{ti};
    for i = 1:length(subjs_to_copy.(task{ti}))
        block_names = BlockBySubj(subjs_to_copy.(task{ti}){i},project_name); % 
        UpdateGlobalVarDirs(subjs_to_copy.(task{ti}){i}, project_name, block_names, dirs)% 
    end
end

for ti = 1:length(task)
    sbj_names = subjs_to_copy.(task{ti});
    for i = 1:length(sbj_names)
        analyseMultipleSubjects(sbj_names{i}, task{ti}, dirs, 0,0,1) % project_name{i}
    end
end

% UpdateGlobalVarDirs(sbj_name, project_name, block_names, dirs)% 

%% Branch 6 - integrate brain and electrodes location MNI and native and other info
% Load and convert Freesurfer to Matlab
% load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,block_names{1}),'globalVar');
% elecs = setdiff(1:globalVar.nchan,globalVar.refChan);

% Retrieve subjects info
[DOCID,GID] = getGoogleSheetInfo('math_network', project_name);
googleSheet = GetGoogleSpreadsheet(DOCID, GID);
sbj_names = googleSheet.subject_name;
% selec_criteria = [~cellfun(@isempty, sbj_names)  ~cellfun(@(x) contains(x, '0'), googleSheet.freesurfer)  ~cellfun(@(x) contains(x, 'both'), googleSheet.hemi)];
selec_criteria = [~cellfun(@isempty, sbj_names)  ~cellfun(@(x) contains(x, '0'), googleSheet.freesurfer)];
sbj_names = sbj_names(sum(selec_criteria,2) == size(selec_criteria,2));
sbj_names = sbj_names(subjVar_created == 0)

all_folders = dir(fullfile([dirs.original_data]));
selec_criteria = ~cellfun(@(x) contains(x, '.'), all_folders.name)


all_folders = dir(fullfile(dirs.original_data));
sbj_names_p = {all_folders(:).name};
sbj_names = sbj_names_p(cellfun(@(x) ~contains(x, '.'), sbj_names_p));


S12_32_JTa


% Create subject variable
comp_root = '/Volumes/LBCN8T/Stanford/data';
server_root = '/Volumes/neurology_jparvizi$/';
code_root = '/Users/pinheirochagas/Pedro/Stanford/code/lbcn_preproc/';

center = 'Stanford';
subjVar_exist = ones(length(sbj_names),1,1);


for i = 1:length(sbj_names)
    % Load subjVar
    data_format = GetFSdataFormat(sbj_names{i}, 'Stanford');
    dirs = InitializeDirs('MMR', sbj_names{i}, comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'
    try
        load([dirs.original_data filesep   sbj_names{i} filesep 'subjVar_'  sbj_names{i} '.mat']);
    catch
        subjVar_exist(i) = 0;
    end
end

sbj_names = sbj_names(subjVar_exist == 1)

subjVar_created = zeros(length(sbj_names),1,1);
parfor i = 1:length(sbj_names)
%     data_format = GetFSdataFormat(sbj_names{i}, 'Stanford');
%     dirs = InitializeDirs('MMR', sbj_names{i}, comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'
    try
%     [subjVar, subjVar_created(i)] = CreateSubjVar(sbj_names{i}, dirs, data_format);
        CreateSubjVar(sbj_names{i}, comp_root, server_root, code_root)
        subjVar_created(i) = 1;
    catch
       subjVar_created(i) = 0;
    end
end

% Plot coverage for the ones with subjVar
for i = 1:length(sbj_names)
    disp(['plotting coverage of subject ' sbj_names{i}])
    dirs = InitializeDirs('Calculia_China', sbj_names{i}, comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'
    load([dirs.original_data filesep  sbj_names{i} filesep 'subjVar_'  sbj_names{i} '.mat']);
    PlotCoverage(subjVar, dirs.project, 0, 0)
end

% For individual subjects
sbj_name = {'S19_136_AG, S15_87_RL'}
fsDir_local = '/Applications/freesurfer/subjects/fsaverage';
dirs = InitializeDirs(' ', sbj_name, comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'
CreateSubjVar(sbj_name, comp_root, server_root, code_root)

% export elinfo to csv:
coords = subjVar.elinfo.MNI_coord

elec_names = subjVar.elinfo.FS_label;
for i = 1:length(elec_names)
    S = elec_names{i};
    elec_names_let{i} = S(isstrprop(S,'alpha'));
end
unique_chan_let = unique(elec_names_let);

cols = hsv(length(unique_chan_let))

colors = zeros(length(elec_names_let),3,1)
for i = 1:length(unique_chan_let)
    colstmp = find(strcmp(unique_chan_let(i), elec_names_let));
    for ii = 1:length(colstmp)
        colors(colstmp(ii),:) = cols(i,:);
    end
end
csvwrite('colors.csv', colors)

%% Branch 7 - Plotting
% plot avg. HFB timecourse for each electrode separately
% plot individual trials (to visualize bad trials)
% plot_params = genPlotParams(project_name,'timecourse');
% plot_params.single_trial = true;
% plot_params.noise_method = 'trials'; %'trials','timepts','none'
% % plot_params.noise_fields_timepts = {'bad_epochs_HFnO','bad_epochs_raw_HFspike'};
% plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
% plot_params.textsize = 10;
% PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames',[],plot_params,'Band')
block_names = 

plot_params = genPlotParams(project_name,'timecourse');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','CondNamesCueLoc', {'target_present_cue_left', 'target_present_cue_right'}, plot_params,'Band') % condNames


plot_params = genPlotParams(project_name,'timecourse');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames', {'digit_active_delayed', 'digit_active_non_delayed'}, plot_params,'Band') % condNames


block_names = block_names(3:end)
plot_params.xlim = [-1 .5]
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','CondNamesCueLoc', {'target_present_cue_left', 'target_present_cue_right'}, plot_params,'Band') % condNames
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','resp','CondNamesCueLoc', {'target_present_cue_left', 'target_present_cue_right'}, plot_params,'Band') % condNames







chan = find(strcmp(subjVar.labels_EDF,'LM4'))
plot_params = genPlotParams(project_name,'timecourse');
plot_params.legend = false
plot_params.xlim = [-0.2 8]

PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames', {'autobio', 'math'}, plot_params,'Band') % condNames


% plot_params.xlim = [-1, 0.5]
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,chan,'HFB','stim','CondNamesCueLoc', {'target_present_left', 'target_present_right'}, plot_params,'Band') % condNames
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,chan,'HFB','stim','CondNamesCueLoc', {'target_present_right', 'target_present_left'}, plot_params,'Band') % condNames


chan = find(strcmp(subjVar.labels_EDF,'LM9'))
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,chan,'HFB','stim','condNames', {'math', 'autobio'}, plot_params,'Band') % condNames



% plot avg. HFB timecourse for each electrode separately
plot_params = genPlotParams(project_name,'timecourse');
plot_params.correct_label = 0;
plot_params.FS_labels = subjVar.elinfo.FS_label;

plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};

plot_params.col = [cdcol.ultramarine;
            cdcol.carmine];
plot_params.xlim(2) = 5.5       
plot_params.legend = 0
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,chan,'HFB','stim','condNames', {'autobio', 'math'}, plot_params,'Band') % condNames




chan = find(strcmp(subjVar.elinfo.FS_label,'VPG30'))
plot_params.noise_method = 'none'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};

plot_params.single_trial =1
plot_params.ylim_min = 20
plot_params.ylabel = 'HFB'
plot_params.textsize = 12;

plot_params.correct_label = 1;
plot_params.FS_labels = subjVar.elinfo.FS_label;


PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','conds_all', [], plot_params,'Band') % condNames


plot_params.col = autumn(4)
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','conds_addsub_min',{'sub_0', 'sub_1', 'sub_2', 'sub_3'}, plot_params,'Band') % condNames
plot_params.col = winter(4)
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','conds_addsub_min',{'add_0', 'add_1', 'add_2', 'add_3'}, plot_params,'Band') % condNames



plot_params.ylabel = 'z-scored HFB power'
plot_params.legend = 0

% 
% conds_plot = {'number_digit_1', 'number_digit_2', 'number_digit_3', 'number_digit_4'}
% conds_plot = {'brightness_digit_1', 'brightness_digit_2', 'brightness_digit_3', 'brightness_digit_4'}

% PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','conds_num_lum_digit_dot_distance',conds_plot,plot_params,'Band') % condNames

plot_params.xlim = [-.2 1.5]
plot_params.col = parula(4);
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,find(strcmp(subjVar.labels_EDF, 'LK10')),'HFB','stim','conds_min', [], plot_params,'Band') % condNames


plot_params.legend = 0
plot_params.col = parula(5)
plot_params.ylim = [-0.3 0.4]
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,112,'HFB','stim','CondNamesCueLoc',{'target_present_left', 'target_present_right'},plot_params,'Band') % condNames
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,112,'HFB','resp','CondNamesCueLoc',{'target_present_left', 'target_present_right'},plot_params,'Band') % condNames

plot_params.col = [plot_params.col(2,:); plot_params.col(1,:)]
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,157,'HFB','stim','CondNamesCueLoc',{'target_present_left', 'target_present_right'},plot_params,'Band') % condNames
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,157,'HFB','resp','CondNamesCueLoc',{'target_present_left', 'target_present_right'},plot_params,'Band') % condNames


plot_params.single_trial =0
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,111,'HFB','resp','CondNamesCueLoc',{'target_present_left', 'target_present_right'},plot_params,'Band') % condNames


plot_params.xlim = [-1 .5]
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,111,'HFB','resp','CondNames',{'target_present'},plot_params,'Band') % condNames




plot_params.xlim = [-3 1];
plot_params.blc = 1
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','resp','condNames',[],plot_params,'Band') % condNames

% plot ERSP (event-related spectral perturbations) for each electrode
plot_params = genPlotParams(project_name,'ERSP');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
PlotERSPAll(sbj_name,project_name,block_names,dirs,61,'SpecDense','stim','condNames',{'math', 'autobio'},plot_params)% condNames



% plot HFB timecourse, grouping multiple conds together
plot_params = genPlotParams(project_name,'timecourse');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames',{{'math','autobio'},{'math'}},plot_params,'Band')

% plot HFB timecourse for multiple elecs on same plot
plot_params = genPlotParams(project_name,'timecourse');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
plot_params.multielec = true;
elecs = {'LK9', 'LK10'}; %S14_69b
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','condNames',[],plot_params,'Band')



PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','conds_min', [], plot_params,'Band') % condNames


% plot inter-trial phase coherence for each electrode
plot_params = genPlotParams(project_name,'ITPC');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
PlotITPCAll(sbj_name,project_name,block_names,dirs,61,'SpecDense','stim','conds_math_memory',{'math', 'memory'},plot_params)

%% Plot subjects individual electrodes
cfg = [];
cfg.highlight_col = [1 0 0];
cfg.correction_factor = 10;
cfg.alpha = 1;

for i = 10:length(sbj_names)
    
    load([dirs.original_data filesep  sbj_names{i} filesep 'subjVar_'  sbj_names{i} '.mat']);
    
    for ei = 105:106%1:size(subjVar.elinfo,1)
        cfg.chan_highlight = ei;
        PlotCoverageElect(subjVar, cfg) %elecs(ei)
        d_out = [dirs.result_root,filesep,'elect_localization',filesep,sbj_names{i}];
        fn_out = [d_out, filesep, sprintf('%s_%s_electrode.png', sbj_names{i}, subjVar.elinfo.FS_label{ei})];
        
        if ~exist(d_out, 'dir')
            mkdir(d_out)
        else
        end
        savePNG(gcf, 300, fn_out)
        close
    end
    
end

PlotCoverageElect(subjVar, 0, cfg) %elecs(ei)
fn_out = [d_out, filesep, sprintf('electrode_%s_loc.png', 'all')];
savePNG(gcf, 300, fn_out)


PlotCoverageElect(subjVar, 0, cfg) %elecs(ei)
 d_out = [dirs.result_root,filesep,'elect_localization',filesep,sbj_name];
% fn_out = [d_out, filesep, sprintf('electrode_%s_%s_loc.png', num2str(elecs(ei)), subjVar.elinfo.FS_label{ei})];


subjVar,correction_factor, ifsave, savefold

cfg = [];
cfg.chan_highlight = [find(strcmp(subjVar.elinfo.FS_label,'LK9')) find(strcmp(subjVar.elinfo.FS_label,'LK10'))]
cfg.highlight_col = [1 0 0];
cfg.correction_factor = 0;
cfg.alpha = 0.3;

PlotCoverageElect(subjVar, cfg) %elecs(ei)

fn_out = [d_out, filesep, sprintf('electrode_%s_%s_loc.png', num2str(cfg.chan_highlight), subjVar.elinfo.FS_label{cfg.chan_highlight(1)})];
savePNG(gcf, 300, fn_out)





%% PAC
phase_elecs = {'15'}; %S17_110
amp_elecs = {'61'}; %S17_110

pac_params = genPACParams(project_name);
PAC = computePACAll(sbj_name,project_name,block_names,dirs,phase_elecs,amp_elecs,[],'SpecDenseLF','stim','conds_math_memory',{'math'},pac_params);
plotPAC(PAC,{'math'},'15', '61')

plotPACAll(sbj_name,project_name,dirs,[],[],{'autobio','math'},'SpecDenseLF')

%% PLV RT correlation
PLVRTCorrAll(sbj_name,project_name,block_names,dirs,elecs1,elecs2,'all','stim','condNotAfterMtn',[],[])


plot_params = genPlotParams(project_name,'timecourse');
plot_params.xlim = [-.2 2]
plot_params.single_trial = true;

plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};


elecs = {'61'};
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames',[],plot_params)

ChanNamesToNums(globalVar, {'LPC6'})

noise_method = 'timepts'; %'trials','timepts','none'

% plot HFB timecourse for each electrode separately
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs, [] ,'HFB','stim','condNames',[],'none',[])


PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames',[],[],'trials',[],x_lim)
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','resp','conds_addsub',[],[],'none',[],x_lim)
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','conds_math_memory',[],[],'trials',[],x_lim)


baPlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames',[],col,'trials',[],x_lim)

x_lim = [-tmax 1];
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames',[],col,'trials',[],x_lim)

col = cool(15)
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','Operand2',[],col,'trials',[],x_lim)
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames',[],col,'trials',[],x_lim)


% Number comparison
% load a given trialinfo
load([dirs.psych_root,'/',sbj_name,'/',block_names{1},'/trialinfo_',block_names{1},'.mat'])
conds_dist = unique(trialinfo.conds_num_lum_digit_dot_distance)
conds_number_digit = conds_dist(contains(conds_dist, 'number_digit'));
conds_number_dot = conds_dist(contains(conds_dist, 'number_dot'));
conds_brightness_dot = conds_dist(contains(conds_dist, 'brightness_dot'));
conds_brightness_digit= conds_dist(contains(conds_dist, 'brightness_digit'));


col = gray(4)
col = col*0.85

PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames',[],,plot_params,'Band')
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','conds_min', [], plot_params,'Band') % condNames

% TODO:
% Allow conds to be any kind of class, logical, str, cell, double, etc.
% Input baseline correction flag to have the option.
% Include the lines option

PlotERSPAll(sbj_name,project_name,block_names,dirs,[],'stim','condNames',[],'trials',[])
PlotERSPAll(sbj_name,project_name,block_names,dirs,[],'stim','conds_calc',[],'trials',[])
PlotERSPAll(sbj_name,project_name,block_names,dirs,[],'stim','conds_math_memory',[],'trials',[])

% TODO: Fix cbrewer 2



%% Copy subjects
task = {'Scrambled', 'Logo', 'VTCLoc', 'SevenHeaven', 'ReadNumWord', 'AllCateg'};

subjs_to_copy.Context = {'S13_57_TVD'}
subjs_to_copy.Scrambled = {}; % this is to initiate and copy from excel files
subjs_to_copy.Logo = {}; % this is to initiate and copy from excel files
subjs_to_copy.VTCLoc = {}; % this is to initiate and copy from excel files
subjs_to_copy.SevenHeaven = {}; % this is to initiate and copy from excel files
subjs_to_copy.ReadNumWord = {}; % this is to initiate and copy from excel files
subjs_to_copy.AllCateg = {}; % this is to initiate and copy from excel files
subjs_to_copy.Calculia_China = {}; % this is to initiate and copy from excel files
subjs_to_copy.Calculia_letter = {}; % this is to initiate and copy from excel files
subjs_to_copy.EglyDriver = {'S19_137_AF'}
subjs_to_copy.MFA = {}; % this is to initiate and copy from excel files

task = {'MFA'}

comp_root = '/Volumes/SRI_LBCN/Stanford/data';
dirs = InitializeDirs(project_name, ' ', comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'
neuralData_folders = {'originalData', 'CARData'};

%% Update BlockbySubj first!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
for ti = 1:length(task)
    project_name = task{ti};
    block_names_all = {};
    for i = 1:length(subjs_to_copy.(task{ti}))
        block_names_all{i} = BlockBySubj(subjs_to_copy.(task{ti}){i},project_name);
    end
    parfor i = 1:length(subjs_to_copy.(task{ti}))
        CopySubject(subjs_to_copy.(task{ti}){i}, dirs.psych_root, '/Volumes/LBCN8T/Stanford/data/psychData', dirs.data_root, '/Volumes/LBCN8T/Stanford/data/neuralData', neuralData_folders, project_name, block_names_all{i})
    end
end

%% Run after having copied on the destination computer
comp_root = '/Volumes/LBCN8T/Stanford/data';
dirs = InitializeDirs(project_name, subjs_to_copy.MFA{1}, comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'
for ti = 1:length(task)
    project_name = task{ti};
    for i = 1:length(subjs_to_copy.(task{ti}))
        block_names = BlockBySubj(subjs_to_copy.(task{ti}){i},project_name); % 
        UpdateGlobalVarDirs(subjs_to_copy.(task{ti}){i}, project_name, block_names, dirs)% 
    end
end



% Run for all calculia after
for i = 2:length(subjs_to_copy.Calculia_letter)
    block_names = BlockBySubj(subjs_to_copy.Calculia_letter{i},project_name);
%     OrganizeTrialInfoCalculia_combined(subjs_to_copy{i}, project_name, block_names, dirs)
    EventIdentifier(subjs_to_copy.Calculia_letter{i}, project_name, block_names, dirs, 1)
end

sbj_name = subjs_to_copy{6}
block_names = BlockBySubj(sbj_name,project_name); % 
UpdateGlobalVarDirs(sbj_name, project_name, block_names, dirs)%
EventIdentifier(sbj_name, project_name, block_names, dirs, 2)
close all

% missing 
% sodata for S18_129_AS E18-767_0004

%% Analyse several subjects
all_folders = dir(fullfile([dirs.result_root filesep 'heatmap']));
sbj_names_p = {all_folders(:).name};
sbj_names_p = sbj_names_p(cellfun(@(x) contains(x, {'heatmap'}), sbj_names_p));
sbj_names_p = sbj_names_p(cellfun(@(x) contains(x, {'math'}), sbj_names_p));
mmr_inds = cellfun(@(x) contains(x, {'MMR'}), sbj_names_p);

expression = '\w{1}\d{2}\w{1}\d{2,3}\w{1}[A-Za-z10-9]{2,3}';
sbj_name_all = cellfun(@(x) regexp(x, expression,'match'), sbj_names_p);
[~, inds] = unique(sbj_name_all);
sbj_name_all = sbj_name_all(inds);
mmr_inds = mmr_inds(inds);

for i = 2:length(sbj_names)
%     if mmr_inds(i) == 1
%         project_name = 'MMR';
%     else
%         project_name = 'UCLA';
%     end
        analyseMultipleSubjects(sbj_names{i}, 'MFA', dirs, 1,1, 1) % project_name{i}
end



project_name = 'Calculia_China';
for i = 5:6%length(sbj_name_all)
    analyseMultipleSubjects(sbj_name_all{i}, project_name, dirs,0,0, 1)
end
1 4 5 6 etc

for i = 8:length(sbj_name_all)
    UpdateTrialinfo(sbj_name_all{i}, dirs, project_name, 'Band', 'HFB', 'stimlock_bl_corr')
end


sbj_name_all = {'S13_57_TVD'}
project_name = 'Context';
for i = 1:length(sbj_name_all)
    analyseMultipleSubjects(sbj_name_all{i}, project_name, dirs,0,0, 1)
end


% in case the global variable needs to be copied from Claras
block_names = BlockBySubj('S14_73_AY', project_name);
UpdateGlobalVarDirs('S14_73_AY', 'VTCLoc', block_names, dirs)%

AllCateg
VTCLoc

OrganizeTrialInfoVTC('S17_69_RTb', project_name, block_names, dirs)
analyseMultipleSubjects('S17_69_RTb', project_name, dirs,0,1,1)

EventIdentifier('S17_69_RTb', project_name, block_names, dirs, 1)



%% issues SP I think... only for plotting
% Error using concatBlocks (line 72)
% All tables in the bracketed expression must have the same number of variables.
% 
% Error in PlotTrialAvgAll (line 78)
%     data_all = concatBlocks(sbj_name,project_name,block_names,dirs,el,freq_band,datatype,concatfield,tag);
% 
% Error in analyseMultipleSubjects (line 46)
%     PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames',[],plot_params,'Band') % condNames
%  

%issue with 'S15_81_RM' and 'S12_37_EJ' not allonsets, maybe not event identifier?


%% Issues with logo S14_73_AY different variables in the trialinfo
% missing car for S12_36_SrS

%% ISSURES
% S16_102_MDO, S17_114_EB S17_115_MP try without parfor
% > In WaveletFilterAll (line 55)
% Warning: Directory already exists.
% > In WaveletFilterAll (line 55)
% Analyzing and transferring files to the workers ...
% Error using WaveletFilterAll (line 72)
% An UndefinedFunction error was thrown on the workers for 'data'.  This
% might be because the file containing 'data' is not accessible on the
% workers.  Use addAttachedFiles(pool, files) to specify the required
% files to be attached.  See the documentation for
% 'parallel.Pool/addAttachedFiles' for more details.
% 
% Error in analyseMultipleSubjects (line 14)
%     parfor ei = 1:length(elecs)
% 
% Caused by:
%     Undefined function or variable 'data'.

% Missing CAR for 


%%
% 'S17_117_MC'
sub = 41;
sbj_names{sub}
PlotCoverage(sbj_names{contains(sbj_names,'96')}, project_name) % {contains(sbj_names,'DY')}

sbj_name = 'S16_96_LF'
dirs = InitializeDirs('Pedro_iMAC', project_name, sbj_name, 1); % 'Pedro_NeuroSpin2T'
fsDir_local = '/Applications/freesurfer/subjects/fsaverage';
cortex = getcort(dirs);
coords = importCoordsFreesurfer(dirs);
elect_names = importElectNames(dirs);
V = importVolumes(dirs);

% Convert electrode coordinates from native to MNI space
for i = 1:length(sbj_names)
    dirs = InitializeDirs('Pedro_iMAC', project_name, sbj_name(i), comp_root, server_root); % 'Pedro_NeuroSpin2T'
    cortex = getcort(dirs);
    coords = importCoordsFreesurfer(dirs);
    elect_names = importElectNames(dirs);
    [MNI_coords, elecNames, isLeft, avgVids, subVids] = sub2AvgBrainCustom([],dirs, fsDir_local);
end
% Plot brain and coordinates
% transform coords
% coords(:,1) = coords(:,1) + 5;
% coords(:,2) = coords(:,2) + 5;
% coords(:,3) = coords(:,3) - 5;

%% Plot electrodes as dots in native space
figureDim = [0 0 1 .4];
figure('units', 'normalized', 'outerposition', figureDim)

views = [1 2 4];
if isLeft(1) == 1
    hemisphere = 'left';
else
    hemisphere = 'right';
end

hemisphere = 'right';

for i = 1:length(views)
    subplot(1,length(views),i)
    ctmr_gauss_plot(cortex.(hemisphere),[0 0 0], 0, hemisphere(1), views(i))
    f1 = plot3(coords(:,1),coords(:,2),coords(:,3), 'o', 'MarkerSize', 10, 'MarkerFaceColor', cdcol.light_cadmium_red, 'MarkerEdgeColor', cdcol.light_cadmium_red);
    alpha(0.7)
end
light('Position',[1 0 0])
text(350,90,sbj_name, 'Interpreter', 'none', 'FontSize', 30)
savePNG(gcf, 600, [dirs.result_root '/coverage/' sbj_name '.png']);
close all

%% Plot electrodes as text
% load subject variable
PlotCoverage(sbj_name,project_name, dirs, 1)

for v = 1:length(views)
    subplot(1,length(views),v)
    ctmr_gauss_plot(cortex.(hemisphere),[0 0 0], 0, hemisphere(1), views(v))
    for i = 1:length(elecs)
        hold on
        text(coords(i,1),coords(i,2),coords(i,3), num2str(elecs(i)), 'FontSize', 20);
    end
    alpha(0.5)
end

for i = 1:9
    subplot(3,3,i)
    ctmr_gauss_plot(cortex.left,[0 0 0], 0, 'left', i)
end
% Plot two hemispheres
ctmr_gauss_plot(cortex.left,[0 0 0], 0, 'left', 1)
ctmr_gauss_plot(cortex.right,[0 0 0], 0, 'right', 1)
f1 = plot3(coords(:,1),coords(:,2),coords(:,3), '.', 'Color', 'k', 'MarkerSize', 40);
f1 = plot3(coords(e,1),coords(e,2),coords(e,3), '.', 'Color', 'r', 'MarkerSize', 40);
text(coords(e,1),coords(e,2),coords(e,3), num2str(elecs(e)), 'FontSize', 20);








%% Medium-long term projects
% 1. Creat subfunctions of the EventIdentifier specific to each project
% 2. Stimuli identity to TTL

%% Decoding
decimate = 0;
final_fs = 500;
cfg = []
cfg.decimate = 0
concat_params = genConcatParams(decimate, cfg);
concat_params.noise_method = 'none';
concat_params.fieldtrip = true; 




hfa = ConcatenateAll(sbj_name,project_name,block_names,dirs,[], 'Band', 'HFB','stim', concat_params);

cfg.decimate = 1;
cfg.final_fs = 500;
concat_params = genConcatParams(project_name, cfg);
concat_params.fieldtrip = true; 

data3 = ConcatenateAll(sbj_name,project_name,block_names,dirs,[], 'CAR', 'CAR','stim', concat_params);



% data_all_spec = ConcatenateAll(sbj_name,project_name,block_names,dirs,[],'Spec','stim', plot_params);

% exportDataMNE(data_all_spec)

trialinfo = removevars(data_all.trialinfo, {'bad_epochs_raw_LFspike', 'bad_epochs_raw_HFspike' 'bad_epochs_raw_jump', 'bad_epochs_spec_HFspike', 'bad_epochs','bad_epochs_HFO', 'bad_inds_raw_LFspike', 'bad_inds_raw_HFspike', 'bad_inds_raw_jump', 'bad_inds_spec_HFspike', 'bad_inds_HFO', 'bad_inds', 'block', 'allonsets', 'StimulusOnsetTime'});
% 
for i = 1:200
    hold on
    plot(data_all.trial{i}(108,:))
end


% % excluse bad channels
% data_all.wave(:,data_all.badChan,:) = [];
% data_all.labels(data_all.badChan) = [];
% data_all.trialinfo(data_all.badChan) = [];

% check for channels with nan
nan_channel = [];
for i = 1:size(data_all.wave,2)
    nan_channel(i) = sum(sum(isnan(data_all.wave(:,i,:))));
end

% Interpolate nans channels witgh nan
% loop across dimensions
nanx = isnan(x);
t    = 1:numel(x);
x(nanx) = interp1(t(~nanx), x(~nanx), t(nanx));


%% Select some channels 
chan_indices = find(contains(data_all.labels, 'LPG'));
data_all.wave = data_all.wave(:,chan_indices,:);
data_all.labels = data_all.labels(chan_indices);
bad_chan_HFO = [17:23, 25:31, 37:39];
data_all.wave(:,bad_chan_HFO,:) = [];
data_all.labels(bad_chan_HFO) = [];


data_all.wave(:,data_all.badChan,:) = [];
data_all.labels(data_all.badChan) = [];


%Randomly select the same number of conditions

% Save
dirs.MVPAData = '/Volumes/LBCN8T_2/Stanford/data/MVPAData';
% save([dirs.MVPAData '/data_all_' sbj_name '_' project_name '_' 'HFB' '.mat'], 'data_all', '-v7.3');
save([dirs.MVPAData '/data_all_' sbj_name '_' project_name '_' '.mat'], 'data_all');

% Export trialinfo to csv
% data_all.wave = data_all.wave(~contains(trialinfo.wlist, 'Ê'),:,:); % correct that for MMR
% trialinfo = trialinfo(~contains(trialinfo.wlist, 'Ê'),:); % correct that for MMR
writetable(trialinfo,[dirs.MVPAData '/trialinfo_' sbj_name '_' project_name '.csv'])

%% Prepare data for cluster-based stats
% to do
% add the sem plot to the mean
% adapt the clust_perm2 to independent sample t-test
% adapt the clust_perm2 to f-test

data_math = data_all.wave(data_all.trialinfo{1}.isCalc == 1, 61, :);
data_math = permute(data_math, [2,3,1]);
data_autobio = data_all.wave(data_all.trialinfo{1}.isCalc == 0, 61, :);
data_autobio = permute(data_autobio, [2,3,1]);

% Example stats for one sample t-test
[pval, t_orig, clust_info, seed_state, est_alpha] = clust_perm1(data_math,[]);
pval(pval>0.05) = nan;
pvalsig = find(pval<0.05);
% Plot
hold on
plot(squeeze(mean(data_math,3)))
plot(pvalsig, zeros(length(pvalsig),1)', '*')

% Example stats for two sample t-test

data_math = data_all.wave(data_all.trialinfo{1}.isCalc == 1, 61, :);
data_math = permute(data_math, [2,3,1]);
data_autobio = data_all.wave(data_all.trialinfo{1}.isCalc == 0, 61, :);
data_autobio = permute(data_autobio, [2,3,1]);

[pval, t_orig, clust_info, seed_state, est_alpha] = clust_perm2(data_math, data_autobio(:,:,1:size(data_math,3)),[]);
pval(pval>0.05) = nan;
pvalsig = find(pval<0.05);

hold on
plot(squeeze(mean(data_math,3)))
plot(squeeze(mean(data_autobio,3)))
plot(pvalsig, zeros(length(pvalsig),1)', '*')




%% Plot heatmap
project_name = 'Memoria';
% Retrieve subjects info
[DOCID,GID] = getGoogleSheetInfo('math_network', project_name);
googleSheet = GetGoogleSpreadsheet(DOCID, GID);
sbj_names_s = googleSheet.subject_name;
% selec_criteria = [~cellfun(@isempty, sbj_names)  ~cellfun(@(x) contains(x, '0'), googleSheet.freesurfer)  ~cellfun(@(x) contains(x, 'both'), googleSheet.hemi)];
selec_criteria = [~cellfun(@isempty, sbj_names_s)  ~cellfun(@(x) contains(x, '0'), googleSheet.freesurfer) cellfun(@(x) contains(x, '1'), googleSheet.subjVar) cellfun(@(x) contains(x, 'MMR'), googleSheet.task)];
selec_criteria = [~cellfun(@isempty, sbj_names_s)  ~cellfun(@(x) contains(x, '0'), googleSheet.freesurfer) cellfun(@(x) contains(x, '1'), googleSheet.subjVar)];

sbj_names_s = sbj_names_s(sum(selec_criteria,2) == size(selec_criteria,2));

% check the processed ones
all_folders = dir(fullfile([dirs.result_root filesep project_name]));
sbj_names_p = {all_folders(:).name};
sbj_names = sbj_names_p(cellfun(@(x) ~contains(x, '.'), sbj_names_p));

[a,b] = intersect(sbj_names_s, sbj_names_p);

all_folders = dir(fullfile([dirs.result_root filesep 'heatmap']));
sbj_names_p = {all_folders(:).name};
sbj_names_p = sbj_names_p(cellfun(@(x) contains(x, {'heatmap'}), sbj_names_p));
sbj_names_p = sbj_names_p(cellfun(@(x) contains(x, {'MMR'}), sbj_names_p));

expression = '\w{1}\d{2}\w{1}\d{2,3}\w{1}[A-Za-z10-9]{2,3}';
sbj_names = cellfun(@(x) regexp(x, expression,'match'), sbj_names_p);

project_name = 'MMR';
conds_avg_field = 'condNames';
conds_avg_conds = {'math'};
cond_plot = 'math';
colormap_plot = 'RedsWhite';
for i = 14:length(sbj_names)
    dirs = InitializeDirs(project_name, sbj_names{i}, comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'
    PlotCoverageHeatmap(sbj_names{i},project_name, conds_avg_field, conds_avg_conds, cond_plot, colormap_plot, 'native', 0, dirs)
end

%% Plot selectivity
project_name = 'MMR';
% Retrieve subjects info
[DOCID,GID] = getGoogleSheetInfo('math_network', project_name);
googleSheet = GetGoogleSpreadsheet(DOCID, GID);
sbj_names = googleSheet.subject_name;
sbj_names = googleSheet.subject_name(strcmp(googleSheet.task, 'MMR'));


conds_avg_field = 'condNames';
conds_avg_conds = {'math', 'autobio'};
cond_plot = 'math';
colormap_plot = 'RedsWhite';
correction_factor = 10;

for i = 1:5%length(sbj_names)
    dirs = InitializeDirs(project_name, sbj_names{i}, comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'
    elect_select{i} = ElectSelectivity(sbj_names{i},project_name, conds_avg_field, conds_avg_conds, dirs);
    load([dirs.original_data filesep  sbj_names{i} filesep 'subjVar_'  sbj_names{i} '.mat']);
    PlotSelectivity(dirs, subjVar, project_name, elect_select{i}, 'native', 10)
end


%plot selective channels 
plot_params = genPlotParams(project_name,'timecourse');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};

for i = 1:length(sbj_names)
    elect_plot = find(~strcmp(elect_select{i}, 'no selectivity'));
    block_names = BlockBySubj(sbj_names{i},project_name);
    PlotTrialAvgAll(sbj_names{i},project_name,block_names,dirs,elect_plot,'HFB','stim','condNames',{'autobio', 'math'} ,plot_params,'Band', elect_select{i}(elect_plot)) % condNames
end


%% Plot all channels in fsaverage
% sbj_delete = [49,52,54,59 find(strcmp(sbj_names,'S17_113_CAM')), find(strcmp(sbj_names,'S14_80_KBa')), find(strcmp(sbj_names,'S15_87_RL')), find(strcmp(sbj_names,'S14_75_TB')) ];
sbj_delete = [];
elect_select_good = elect_select;
elect_select_good(sbj_delete) = [];
% elect_select_good = horzcat(elect_select_good{:});
sbj_names_good = sbj_names;
sbj_names_good(sbj_delete) = [];

coords_all = [];
% concatenate all coords
for i = 1:5%length(sbj_names_good)
    load([dirs.original_data filesep  sbj_names_good{i} filesep 'subjVar_'  sbj_names_good{i} '.mat']);
    if size(subjVar.MNI_coord,1) == size(elect_select_good{i},2)
    else
       warning(['electrode mismatch in subject ' sbj_names_good{i}]) 
    end
    coords = subjVar.MNI_coord;
    coords_all = [coords_all;coords]; % concatenate electrodes across subjects
end
elect_select_good = horzcat(elect_select_good{1:5});


PlotSelectivityGroup(dirs, coords_all, project_name, elect_select_good, 'MNI', 5)




%% For MEMORIA
project_name = 'Memoria';

all_folders = dir(fullfile([dirs.result_root filesep project_name]));
sbj_names_p = {all_folders(:).name};
sbj_names = sbj_names_p(cellfun(@(x) ~contains(x, '.'), sbj_names_p));


sbj_delete = [find(strcmp(sbj_names,'S16_102_MDO')), find(strcmp(sbj_names,'S17_106_SD')), find(strcmp(sbj_names,'S17_118_TW')), find(strcmp(sbj_names,'S18_130_RH')), find(strcmp(sbj_names,'S18_131_CB')), find(strcmp(sbj_names,'S18_127_AK')), find(strcmp(sbj_names,'S18_129_AS'))]


conds_avg_field = 'condNames';
conds_avg_conds = {'math', 'autobio'};
cond_plot = 'math';

for i = 24:length(sbj_names)
    dirs = InitializeDirs(project_name, sbj_names{i}, comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'
    elect_select{i} = ElectSelectivity(sbj_names{i},project_name, conds_avg_field, conds_avg_conds, dirs);
    load([dirs.original_data filesep  sbj_names{i} filesep 'subjVar_'  sbj_names{i} '.mat']);
    PlotSelectivity(dirs, subjVar, project_name, elect_select{i}, 'native', 5)
end




% FS average

elect_select_good = elect_select;
elect_select_good(sbj_delete) = [];
% elect_select_good = horzcat(elect_select_good{:});
sbj_names_good = sbj_names;
sbj_names_good(sbj_delete) = [];

coords_all = [];
% concatenate all coords
for i = 1:length(sbj_names_good)
    load([dirs.original_data filesep  sbj_names_good{i} filesep 'subjVar_'  sbj_names_good{i} '.mat']);
    if size(subjVar.MNI_coord,1) == size(elect_select_good{i},2)
    else
       warning(['electrode mismatch in subject ' sbj_names_good{i}]) 
    end
    coords = subjVar.MNI_coord;
    coords_all = [coords_all;coords]; % concatenate electrodes across subjects
end
elect_select_good = horzcat(elect_select_good{:});


PlotSelectivityGroup(dirs, coords_all, project_name, elect_select_good, 'MNI', 5)


%plot selective channels 
plot_params = genPlotParams(project_name,'timecourse');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};

for i = 1:length(sbj_names_good)
    elect_plot = find(~strcmp(elect_select_good{i}, 'no selectivity'));
    block_names = BlockBySubj(sbj_names_good{i},project_name);
    PlotTrialAvgAll(sbj_names_good{i},project_name,block_names,dirs,elect_plot,'HFB','stim','condNames',{'autobio', 'math'} ,plot_params,'Band') % condNames
end




%%
% For individual subjects
% CHECK S11_26_SRa after again more specific
sbj_name = 'S15_87_RL' 
fsDir_local = '/Applications/freesurfer/subjects/fsaverage';
[fs_iEEG, fs_Pdio, data_format] = GetFSdataFormat(sbj_name, center);
dirs = InitializeDirs(project_name, sbj_name, comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'
[subjVar,  subjVar_created] = CreateSubjVar(sbj_name, dirs, data_format);
subjVar


for i = 1:length(sbj_names)
    dirs = InitializeDirs(project_name, sbj_names{i}, comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'
    data_format = GetFSdataFormat(sbj_names{i}, center);
    [subjVar,  subjVar_created] = CreateSubjVar(sbj_names{i}, dirs, data_format);
end




conds_avg_field = 'condNames';
conds_avg_conds = {'math'};
cond_plot = 'math';
colormap_plot = 'RedsWhite';
cortex_space = 'native'
correction_factor = 5;
PlotCoverageHeatmap(sbj_name,'UCLA', conds_avg_field, conds_avg_conds, cond_plot, colormap_plot, cortex_space, correction_factor, dirs)

%% Groups subjects
dirs
concat_params = genConcatParams(0,[]);
data_all = ConcatenateAvgTrials(sbj_names,project_name, 'condNames', {'math', 'autobio'}, concat_params, false, dirs);
save('/Volumes/LBCN8T_2/Stanford/data/neural_data/data_MMR_paper.mat', 'data_all')

% select given data
data = data_all;
data.wave = [];
data.wave = data_all.wave_trimmean.math;

% exclude bad channels
fields = {'wave', 'MNI_coord', 'native_coord', 'subjects'};
for i = 1:length(fields)
    if strcmp(fields{i}, 'subjects')
        data.(fields{i})(data.badchans_all) = [];
    else
        data.(fields{i})(data.badchans_all,:) = [];
    end
end

% exclude nan values
for i = 1:size(data.wave,1)
    nan_sum(i) = sum(isnan(data.wave(i,:)));
end
for i = 1:length(fields)
    if strcmp(fields{i}, 'subjects')
        data.(fields{i})(find(nan_sum > 0)) = [];
    else
        data.(fields{i})(find(nan_sum > 0), :) = [];
    end
end

% calculate AUC to eventually exclude some channels
mat_auc = sum(data.wave,2);
extreme_val = [prctile(mat_auc,1) prctile(mat_auc,99)];
extreme_elects = find(mat_auc<extreme_val(1) | mat_auc>extreme_val(2));
for i = 1:length(fields)
    if strcmp(fields{i}, 'subjects')
        data.(fields{i})(extreme_elects) = [];
    else
        data.(fields{i})(extreme_elects, :) = [];
    end
end

% explore individual subjects
subjects = unique(data.subjects);
for i = 1:length(subjects)
    subplot(11,5,i)
    plot(data.time, data.wave(cellfun(@(x) strcmp(x, subjects{i}), data.subjects),:)')
    title(subjects{i}, 'interpreter', 'none')
    ylim([min(data.wave(:)) max(data.wave(:))])
end

% Exclude some subjects 

data.subjects(strcmp(data.subjects, 'S18_125_LU')) = [];
indx_exclude = find(cellfun(@(x) strcmp(x, 'S18_125_LU'), data.subjects));
fields = {'wave', 'MNI_coord', 'native_coord', 'subjects'};
for i = 1:length(fields)
    if strcmp(fields{i}, 'subjects')
        data.(fields{i})(indx_exclude) = [];
    else
        data.(fields{i})(indx_exclude, :) = [];
    end
end

% data_all.math = data_all.math(nan_sum==0,:);
% data_all.chan_plot = data_all.chan_plot(nan_sum==0,:);
% data.wave = data_all.math; 
% 
% dir_out = '/Volumes/LBCN8T_2/Stanford/data/neural_data/cluster';
% save([dir_out filesep 'data.mat'], 'data')


%% Make video
project_name = 'MMR';
% Retrieve subjects info
[DOCID,GID] = getGoogleSheetInfo('math_network', project_name);
googleSheet = GetGoogleSpreadsheet(DOCID, GID);
sbj_names = googleSheet.subject_name;
% selec_criteria = [~cellfun(@isempty, sbj_names)  ~cellfun(@(x) contains(x, '0'), googleSheet.freesurfer)  ~cellfun(@(x) contains(x, 'both'), googleSheet.hemi)];
selec_criteria = [~cellfun(@isempty, sbj_names)  ~cellfun(@(x) contains(x, '0'), googleSheet.freesurfer) cellfun(@(x) contains(x, '1'), googleSheet.subjVar) cellfun(@(x) contains(x, 'MMR'), googleSheet.task)];
sbj_names = sbj_names(sum(selec_criteria,2) == size(selec_criteria,2));
sbj_names = sbj_names(2:4)

all_folders = dir(fullfile([dirs.result_root filesep 'heatmap']));
sbj_names_p = {all_folders(:).name};
sbj_names_p = sbj_names_p(cellfun(@(x) contains(x, {'heatmap'}), sbj_names_p));
sbj_names_p = sbj_names_p(cellfun(@(x) contains(x, {'MMR'}), sbj_names_p));

expression = '\w{1}\d{2}\w{1}\d{2,3}\w{1}[A-Za-z10-9]{2,3}';
sbj_names = cellfun(@(x) regexp(x, expression,'match'), sbj_names_p);

conds_avg_field = 'condNames';
conds_avg_conds = {'math'};
cond_plot = 'math';
colormap_plot = 'RedsWhite';
MakeVideoActivationTime(sbj_names,project_name, conds_avg_field, conds_avg_conds, cond_plot, colormap_plot, dirs)

c_lim = [min(data.wave(:)) 3];
time_lim = [-0.1, 1];
MakeVideoActivationTime_lite(data, c_lim, time_lim, dirs)
%%% FIX colorbarFromValues %%%


%% Get indices for colloring
% [col_idx,cols] = colorbarFromValues(data.wave(:), 'RedsWhite');
c_lim = [min(data.wave(:)) 3];
data.wave(data.wave>c_lim(2)) = data.wave(data.wave>c_lim(2))/max(data.wave(data.wave>c_lim(2))) * c_lim(2);

[col_idx,cols] = colorbarFromValues(data.wave(:), 'RedBlue',[],true);
col_idx = reshape(col_idx,size(data.wave,1), size(data.wave,2));

% Highlight most active channels
chan_plot = data.MNI_coord;
% chan_plot(:,1) = chan_plot(:,1) - sum(data.wave,2);


%% Plot parameters
mark = 'o';
MarkSizeEffect = 20;
colRing = [0 0 0]/255;
time = data.time(find(data.time == -.1):max(find(data.time <= 1)));


%% Plot math
views = {'lateral', 'lateral', 'medial', 'medial', 'ventral', 'ventral'};
hemis = {'left', 'right', 'left', 'right', 'left', 'right'};

F = struct;
count = 0;
for e = [1 50 200 250 300]%:length(time)
    figureDim = [0 0 .4 1];
    f1 = figure('units', 'normalized', 'outerposition', figureDim);
    
    count = count+1;
    
    for i = 1:length(views)
        subplot(3,2,i)
        ctmr_gauss_plot(cmcortex.(hemis{i}),[0 0 0], 0, hemis{i}, views{i})
        % Sort to highlight larger channels
        for ii = 1:size(chan_plot)
            %         f = plot3(el_mniPlot_all(i,1)/(1-abs(math_memo_norm_all(i,e))),el_mniPlot_all(i,2),el_mniPlot_all(i,3), 'o', 'Color', 'k', 'MarkerFaceColor', cols(col_idx_math_memo(i,e),:), 'MarkerSize', MarkSizeEffect*abs(math_memo_norm_all(i,e))+0.01);
            if (strcmp(hemis{i}, 'left') == 1 && chan_plot(ii,1) > 0) || (strcmp(hemis{i}, 'right') == 1 && chan_plot(ii,1) < 0)
            else
                plot3(chan_plot(ii,1),chan_plot(ii,2),chan_plot(ii,3), 'o', 'Color', 'k', 'MarkerFaceColor', cols(col_idx(ii,e),:), 'MarkerSize', MarkSizeEffect*abs(data.wave(ii,e))/2);
            end
        end
        alpha(0.5)
    end
    
    
    time_tmp = num2str(time(e));
    
    if length(time_tmp) < 6
        time_tmp = [time_tmp '00'];
    end
    if strcmp(time_tmp(1), '-')
        time_tmp = time_tmp(1:6);
    else
        if strcmp(time_tmp, '000')
        else
            time_tmp = time_tmp(1:5);
        end
    end
    
    text(250, -150, -60, [time_tmp ' s'], 'FontSize', 40)
    cdata = getframe(gcf);
    F(count).cdata = cdata.cdata;
    F(count).colormap = [];
    close all
end

fig = figure('units', 'normalized', 'outerposition', figureDim);
movie(fig,F,1)

dir_out = [dirs.result_root filesep project_name filesep sbj_name filesep 'Videos' filesep project_name filesep];
videoRSA = VideoWriter([dir_out conds_plot '.avi']);
videoRSA.FrameRate = 30;  % Default 30
videoRSA.Quality = 100;    % Default 75
open(videoRSA);
writeVideo(videoRSA, F);
close(videoRSA);



%% Verify outiler channels
exclude = math_norm;
for i = 1:size(exclude,1)
    chan = exclude(i,:);
    idx_max = find(chan == max(chan));
    hold on
    plot(chan)
    text(idx_max,  max(chan), num2str(i))
end

% exclude_chan_math = {[98, 75], [], [], [], [], [], [], 31, [62, 73]};
% exclude_chan_memo = {[], [], [], [], [], [], [], [31, 25, 19]};
% el_mniPlot_math(unique([horzcat(exclude_chan_math{:}) horzcat(exclude_chan_memo{:})]),:) = []


%% PAC - python
UpdateGlobalVarDirs(sbj_name, project_name, block_names, dirs)

load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,block_names{1}),'globalVar');
elecs = setdiff(1:globalVar.nchan,globalVar.refChan);

epoch_params = genEpochParams(project_name, 'stim');

for i = 1:length(block_names)
    bn = block_names{i};
    EpochDataAll(sbj_name, project_name, bn, dirs,ChanNamesToNums(globalVar,{'LP6'}), 'CAR', [],[], epoch_params,'CAR')
end


% Concatenate 
concat_params = genConcatParams(1,200);
data_all = ConcatenateAll(sbj_name,project_name,block_names,dirs,ChanNamesToNums(globalVar,{'LP6'}),'CAR','CAR','stim', concat_params);

% Select conditions
conds_avg_field = 'condNames';
conds_avg_conds = {'math'};

data_all.wave = data_all.wave(strcmp(data_all.trialinfo.(conds_avg_field), 'math'),:); % average trials by electrode

data_all.wave = reshape(data_all.wave', 1, size(data_all.wave,1) * size(data_all.wave,2));

% Interpolate nans
nanx = isnan(data_all.wave);
t    = 1:numel(data_all.wave);
data_all.wave(nanx) = interp1(t(~nanx), data_all.wave(~nanx), t(nanx));
save([dirs.MVData filesep sbj_name '_' project_name '_' 'CAR_continuous' '.mat'], 'data_all');

%% Cluster analyses
all_folders = dir(fullfile([dirs.result_root filesep 'heatmap']));
sbj_names_p = {all_folders(:).name};
sbj_names_p = sbj_names_p(cellfun(@(x) contains(x, {'heatmap'}), sbj_names_p));
sbj_names_p = sbj_names_p(cellfun(@(x) contains(x, {'MMR'}), sbj_names_p));

expression = '\w{1}\d{2}\w{1}\d{2,3}\w{1}[A-Za-z10-9]{2,3}';
sbj_names = cellfun(@(x) regexp(x, expression,'match'), sbj_names_p);
sbj_names = unique(sbj_names);


all_folders = dir(fullfile([dirs.result_root filesep project_name]));
sbj_names_p = {all_folders(:).name};
sbj_names = sbj_names_p(cellfun(@(x) ~contains(x, '.'), sbj_names_p));

concat_params = genConcatParams(0,[]);
data_all = ConcatenateAvgTrials(sbj_names,project_name, 'condNames', {'math', 'autobio'}, concat_params, true, dirs);
save('/Volumes/NeuroSpin2T/Stanford/data/data_all_memoria_no_bad_chans.mat', 'data_all')

% select given data
data = data_all;
data.wave = [];
data.wave = data_all.wave_trimmean.math;

% exclude bad channels
fields = {'wave', 'MNI_coord', 'native_coord', 'subjects'};
for i = 1:length(fields)
    if strcmp(fields{i}, 'subjects')
        data.(fields{i})(data.badchans_all) = [];   
    else
        data.(fields{i})(data.badchans_all,:) = [];
    end
end

% exclude nan values
for i = 1:size(data.wave,1)
    nan_sum(i) = sum(isnan(data.wave(i,:)));
end
for i = 1:length(fields)
    if strcmp(fields{i}, 'subjects')
        data.(fields{i})(find(nan_sum > 0)) = [];
    else
        data.(fields{i})(find(nan_sum > 0), :) = [];
    end
end

% calculate AUC to eventually exclude some channels
mat_auc = sum(data.wave,2);
extreme_val = [prctile(mat_auc,1) prctile(mat_auc,99)];
extreme_elects = find(mat_auc<extreme_val(1) | mat_auc>extreme_val(2));
for i = 1:length(fields)
    if strcmp(fields{i}, 'subjects')
        data.(fields{i})(extreme_elects) = [];
    else
        data.(fields{i})(extreme_elects, :) = [];
    end
end

% explore individual subjects
subjects = unique(data.subjects);
for i = 1:length(subjects)
    subplot(4,4,i)
    plot(data.time, data.wave(cellfun(@(x) strcmp(x, subjects{i}), data.subjects),:)')
    title(subjects{i}, 'interpreter', 'none')
    ylim([min(data.wave(:)) max(data.wave(:))])
end

% Exclude some subjects 

data.subjects(strcmp(data.subjects, 'S18_125_LU')) = [];
indx_exclude = find(cellfun(@(x) strcmp(x, 'S18_125_LU'), data.subjects));
fields = {'wave', 'MNI_coord', 'native_coord', 'subjects'};
for i = 1:length(fields)
    if strcmp(fields{i}, 'subjects')
        data.(fields{i})(indx_exclude) = [];
    else
        data.(fields{i})(indx_exclude, :) = [];
    end
end

data_all.math = data_all.math(nan_sum==0,:);
data_all.chan_plot = data_all.chan_plot(nan_sum==0,:);
data.wave = data_all.math; 

dir_out = '/Volumes/LBCN8T_2/Stanford/data';
save([dir_out filesep 'data_memoria_math.mat'], 'data')

%% Load template brain 
load([dirs.code_root filesep 'vizualization/Colin_cortex_left.mat']);
cmcortex.left = cortex;
load([dirs.code_root filesep 'vizualization/Colin_cortex_right.mat']);
cmcortex.right = cortex;


%% Plot coverage
marker_size = 5;
figureDim = [0 0 .4 1];
f1 = figure('units', 'normalized', 'outerposition', figureDim);
views = {'lateral', 'lateral', 'medial', 'medial', 'ventral', 'ventral'};
hemis = {'left', 'right', 'left', 'right', 'left', 'right'};
for i = 1:length(views)
    subplot(3,2,i)
    ctmr_gauss_plot(cmcortex.(hemis{i}),[0 0 0], 0, hemis{i}, views{i})
    alpha(0.5)
    % Only plot on the relevant hemisphere
    for ii = 1:length(data.MNI_coord)
        if (strcmp(hemis{i}, 'left') == 1 && data.MNI_coord(ii,1) > 0) || (strcmp(hemis{i}, 'right') == 1 && data.MNI_coord(ii,1) < 0)
        else
            plot3(data.MNI_coord(ii,1),data.MNI_coord(ii,2),data.MNI_coord(ii,3), 'o', 'MarkerSize', marker_size, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k');
        end
    end
end
savePNG(gcf, 300, [dir_out 'coverage_MMR.png'])

%% Plot group heatmap
% calculate auc
times = [min(find(data.time > 0)): max(find(data.time <= 1))]
auc_all = trapz(data.wave(:,times), 2);
[col_idx,colors_plot] = colorbarFromValues(auc_all, colormap_plot, [], true);
% col_idx(col_idx>100) = 100

%% Plot electrodes as dots in common brain
marker_size = 5;
figureDim = [0 0 .4 1];
f1 = figure('units', 'normalized', 'outerposition', figureDim);
views = {'lateral', 'lateral', 'medial', 'medial', 'ventral', 'ventral'};
hemis = {'left', 'right', 'left', 'right', 'left', 'right'};
for i = 1:length(views)
    subplot(3,2,i)
    ctmr_gauss_plot(cmcortex.(hemis{i}),[0 0 0], 0, hemis{i}, views{i})
    for ii = 1:length(data.MNI_coord)
        % Only plot on the relevant hemisphere
        if (strcmp(hemis{i}, 'left') == 1 && data.MNI_coord(ii,1) > 0) || (strcmp(hemis{i}, 'right') == 1 && data.MNI_coord(ii,1) < 0)
        else
            plot3(data.MNI_coord(ii,1),data.MNI_coord(ii,2),data.MNI_coord(ii,3), 'o', 'MarkerSize', marker_size+col_idx(ii)/10, 'MarkerFaceColor', colors_plot(col_idx(ii),:), 'MarkerEdgeColor', 'k');
        end
    end
    alpha(0.5)
end





% Maybe this is more general for SPEC
% data_concat = ConcatAllAvgResp(sbj_name,project_name,block_names,dirs,[],'Band','HFB','stim','condNames',{'math'},concat_params)

% exclude the nans (channels which have only nan)
for i = 1:size(data_all.math,1)
    nan_sum(i) = sum(isnan(data_all.math(i,:)));
end

% exclude reallly extreme values
for i = 1:size(data_all.math,1)
    extreme(i) = sum(isnan(data_all.math(i,:)));
end
%%% WORK ON THAT!!! %%%




%% Load template brain 
load([dirs.code_root filesep 'vizualization/Colin_cortex_left.mat']);
cmcortex.left = cortex;
load([dirs.code_root filesep 'vizualization/Colin_cortex_right.mat']);
cmcortex.right = cortex;

labels = labels+1
labels_tab = tabulate(labels)
sortrows(labels_tab,2)

%% Load cluster labels
load('/Volumes/LBCN8T_2/Stanford/data/cluster_labels_smooth_memoria.mat')
dir_out = '/Volumes/LBCN8T_2/Stanford/data/';
cluster_numbers = [9];
% cluster_numbers = [6 7 8 10 12 15 42 44 61 72 78 79 80 84 107 110 111 115];
cluster_cols = hsv(length(cluster_numbers));



%% Plot clusters
marker_size = 10;
figureDim = [0 0 .4 1];
f1 = figure('units', 'normalized', 'outerposition', figureDim);
views = {'lateral', 'lateral', 'medial', 'medial', 'ventral', 'ventral'};
hemis = {'left', 'right', 'left', 'right', 'left', 'right'};
for i = 1:length(views)
    subplot(3,2,i)
    ctmr_gauss_plot(cmcortex.(hemis{i}),[0 0 0], 0, hemis{i}, views{i})
    alpha(0.5)
    % Only plot on the relevant hemisphere
    for c = 1:length(cluster_numbers)
        coords_plot = data.MNI_coord(labels == cluster_numbers(c),:);
        for ii = 1:length(coords_plot)
            if (strcmp(hemis{i}, 'left') == 1 && coords_plot(ii,1) > 0) || (strcmp(hemis{i}, 'right') == 1 && coords_plot(ii,1) < 0)
            else
                plot3(coords_plot(ii,1),coords_plot(ii,2),coords_plot(ii,3), 'o', 'MarkerSize', marker_size, 'MarkerFaceColor', cluster_cols(c,:), 'MarkerEdgeColor', 'k');
            end
        end
    end
end
savePNG(gcf, 300, [dir_out 'examplar_cluster_memoria.png'])

%% Plot channels
marker_size = 10;
figureDim = [0 0 .3 1];
figure('units', 'normalized', 'outerposition', figureDim);
for c = 1:length(cluster_numbers)
    subplot(5,2,c)
    plot(data.wave(labels == cluster_numbers(c),:)', 'LineWidth',1, 'Color', cluster_cols(c,:))
    title(['cluster' num2str(cluster_numbers(c))])
    set(gca,'fontsize',15)
end
set(gcf,'color','w');
savePNG(gcf, 300, [dir_out 'examplar_cluster_memoria_brain.png'])









cluster_num = 12 % 9 and 12 
color_el = cdcol.orange;

el_mniPlot = el_mniPlot_all(labels==cluster_num,:);
el_mniPlot(:,1) = -70;

for c = 1:length(el_mniPlot)
    f = plot3(el_mniPlot(c,1)*c,el_mniPlot(c,2),el_mniPlot(c,3), 'o', 'Color', 'k', 'MarkerFaceColor', color_el, 'MarkerSize', 20);     

%     el_add2(el_mniPlot(c,:),'g',mark,MarkSizenoEffect*2,[1,2,1])
%     el_add2(el_mniPlot(c,:),'g',mark,MarkSizenoEffect*2,[1,2,2])
end
% save2pdf('/Volumes/NeuroSpin2T/Calc_ECoG/cluster_30.pdf', gcf, 600)








%% Su's viz
sbj_name = 'S13_57_TVD'
project_name = 'MMR';
% Concatenate all blocks and channels
decimate = false;
final_fs = 200;
concat_params = genConcatParams(decimate, final_fs);
concat_params.noise_method = 'trials'; % or timepts maybe better. play with interpolate
block_names = BlockBySubj(sbj_name,project_name);
dirs = InitializeDirs(project_name, sbj_name, comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'
data = ConcatenateAll(sbj_name,project_name,block_names,dirs,[], 'Band', 'HFB','stim', concat_params);

% Load subject Variable
load([dirs.original_data filesep sbj_name filesep 'subjVar_' sbj_name '.mat']);

dir_out = '/Volumes/LBCN8T_2/Stanford/data/neural_data/';

if ~exist([dir_out sbj_name], 'dir')
    mkdir([dir_out sbj_name]) 
else
end
save([dir_out sbj_name filesep 'data_all_' project_name '_' sbj_name '.mat'], 'data', '-v7.3')
save([dir_out sbj_name filesep 'subjVar.mat'], 'subjVar')


%% Count number of subjects
project_name = 'Calculia';
dirs = InitializeDirs(project_name, sbj_name, comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'
all_folders = dir(fullfile([dirs.result_root filesep project_name]))
all_folders = all_folders(arrayfun(@(x) ~contains(x.name, '.'), all_folders));
sbj_names = {all_folders(:).name};

%Subjects with figures
for i = 1:length(all_folders)
    figures(i) = exist([all_folders(i).folder filesep all_folders(i).name filesep 'Figures']);
end

%Subjects with subjVar and matched labels
for i = 1:length(sbj_names)
    load([dirs.original_data filesep  sbj_names{i} filesep 'subjVar_'  sbj_names{i} '.mat']);
    coord_match(i) = 1*(length(subjVar.labels) == length(subjVar.LEPTO_coord));
end


%% Localize electrodes
% Automatic electrode labelling
comp_root = '/Volumes/LBCN8T/Stanford/data';
server_root = '/Volumes/neurology_jparvizi$/';
code_root = '/Users/pinheirochagas/Pedro/Stanford/code/lbcn_preproc/';

dirs = InitializeDirs(project_name, 'S13_57_TVD', comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'
[subjVar,  subjVar_created] = CreateSubjVar('S13_57_TVD', dirs, 'TDT');

cfg.plot_label = 'Destr_ind';
cfg.plot_label = 'numbers';

cfg.views = {'lateral', 'ventral'};
cfg.hemis = {'left', 'left'};
cfg.label_fontsize = 14;
cfg.correction_factor = 10;
PlotAtlasLabels(subjVar, cfg)

% Get all electrodes from all subjects
dirs = InitializeDirs(' ', ' ', comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'

all_folders = dir(fullfile(dirs.original_data))
all_folders = all_folders(arrayfun(@(x) ~contains(x.name, '.'), all_folders));
sbj_names = {all_folders(:).name};

sbj_names(contains(sbj_names, 'S10_18_JBXa')) = []
sbj_names(contains(sbj_names, 'S14_73_AY')) = []
sbj_names(contains(sbj_names, 'S16_96_LF')) = []
sbj_names(strcmp(sbj_names, 'S14_78_RSb')) = []
sbj_names(strcmp(sbj_names, 'S14_78_RS')) = []



% Create subjVar all subjects
% for i = 1:length(sbj_names)
%     [fs_iEEG, fs_Pdio, data_format] = GetFSdataFormat(sbj_names{i}, center);
%     dirs = InitializeDirs(project_name, sbj_names{i}, comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'
%     [subjVar,  subjVar_created(i)] = CreateSubjVar(sbj_names{i}, dirs, data_format);
%     if i == 1
%         subjVar_all = subjVar;
%     else
%         subjVar_all = [subjVar_all, subjVar];
%     end
% end
% save([dirs.data_root 'subjVar_all_new.mat'], 'subjVar_all', '-v7.3')


parfor i = 1:length(sbj_names)
    CreateSubjVar(sbj_names{i}, InitializeDirs(project_name, sbj_names{i}, comp_root, server_root, code_root), GetFSdataFormat(sbj_names{i}, 'Stanford'));
end


% Issues
% 'S10_12_AC'
% 'S10_18_JBXa'
% 'S11_25_DL'
% 'S11_26_SRb'
% 'S11_28_LS'
% 'S11_31_DZa'
% 'S12_33_DA'
% 'S12_43_HH'
% 'S12_45_LR'
% 'S13_53_KS2'
% S13_55_JJC 
% S14_61_CM2
% S14_62_JW


%% Copy global variables to Serdar
for i = 1:length(sbj_names)
    globals = dir(fullfile([dirs.original_data filesep sbj_names{i} filesep], 'global*.mat'));
    
    if ~isempty(globals)
        copyfile([globals(1).folder filesep globals(1).name], '/Users/pinheirochagas/Pedro/drive/Stanford/projects/math_network/globalVars/')   
    else
    end

end


%% Load and concatenate subjVar all subjects
% load([dirs.data_root 'subjVar_all.mat'])
for i = 1:length(sbj_names)
load([dirs.original_data filesep  sbj_names{i} filesep 'subjVar_'  sbj_names{i} '.mat']);
    if i == 1
        subjVar_all = subjVar;
    else
        subjVar_all = [subjVar_all, subjVar];
    end
end


% Concatenate
for i = 1:length(subjVar_all)
    subjVar_all(i).elinfo.sbj_name = cellstr(repmat(subjVar_all(i).sbj_name, size(subjVar_all(i).elinfo,1), 1));
    if i == 1
        elinfo_all = subjVar_all.elinfo;
    else
        elinfo_all = vertcat(elinfo_all, subjVar_all(i).elinfo);
    end
end

cfgl.atlas = 'Yeo_ind7'; %DK_ind Yeo_ind Destr_ind
cfgl.plot_elects = true;
cfgl.save_plot = false
PlotElectDensityMap(elinfo_all,cfgl)


elinfo_rod = elinfo_all(contains(elinfo_all.WMvsGM, 'GM'),:)
elinfo_rod = 



%% Bad chan confirm
sbj_name = 'S12_32_JTb';
block_names = BlockBySubj(sbj_name,project_name)
pathological_chan_id25 = BadChanRejectIdentify(sbj_name, project_name, block_names, dirs, false, 2)

find(pathological_chan_id)


data_tmp = data_JTB.wave_mean.math;
data_tmp(pathological_chan_id25,:) = [];
plot(data_tmp(:,1:1000)', 'b')
hold on
plot(data_JTB.wave_mean.math(pathological_chan_id25,1:1000)', 'r')



true%% Delete continuous data all tasks
% list subjects in a given folder
spec_dir = '/Volumes/LBCN8T_2/Stanford/data/neuralData/SpecData/SpecDense';
all_folders = dir(fullfile(spec_dir));
sbj_names = {all_folders(:).name};
sbj_names = sbj_names(cellfun(@(x) ~contains(x, '.'), sbj_names));

for i = 1:length(sbj_names)
    bn_tmp = dir(fullfile([spec_dir filesep sbj_names{i}]));
    bn_tmp = {bn_tmp(:).name};
    bn_tmp = bn_tmp(cellfun(@(x) ~contains(x, '.'), bn_tmp));
    
    for ib = 1:length(bn_tmp)
        dir_data = [spec_dir filesep sbj_names{i} filesep bn_tmp{ib}];
        dinfo = dir(fullfile(dir_data,'*.mat'));
        for ic = 1:length(dinfo)
            thisfile = [dir_data filesep dinfo(ic).name];
            disp(['deleted ' thisfile])
            delete(thisfile);
        end
    end
end




% 'l' - Left hem lateral
%                             'lm' - Left hem medial
%                             'lo' - Left hem occipital
%                             'lf' - Left hem frontal
%                             'lim' - Left hem inferior-medial
%                             'li' - Left hem inferior
%                             'ls' - Left hem superior
%                             'lsv' - Left hem superior and vertically
%                                     aligned
%                             'liv' - Left hem inferior and vertically
%                                     aligned


% 
% for i = 1:size(cols,1)
% plot(i, 1, '.', 'MarkerSize', 50, 'Color', cols(i,:))   
% hold on
% end





% 
% %%
% %% Make video
% % list subjects
% all_folders = dir(fullfile('/Volumes/LBCN8T/Stanford/data/Results/Memoria/'));
% sbj_names = {all_folders(:).name};
% sbj_names = sbj_names(cellfun(@(x) ~contains(x, '.'), sbj_names));
% sbj_names = sbj_names(3:16);
% sbj_names = {'S18_124'};
% 
% %% Avg task
% % conditions to average
% conds_avg_field = 'condNames';
% conds_avg_conds = {'math', 'autobio'};
% data_all = [];
% for ii = 1:length(conds_avg_conds)
%     % Initialize data_all
%     data_all.(conds_avg_conds{ii}) = [];
% end
% 
% plot_params = genPlotParams(project_name,'timecourse');
% 
% for i = 1:length(sbj_names)
%     % Concatenate trials from all blocks
%     block_names = BlockBySubj(sbj_names{i},project_name);
%     data_sbj = ConcatenateAll(sbj_names{i},project_name,block_names,dirs,[],'Band','HFB','stim', plot_params);
%     elect_all{i} = data_sbj.labels; % QUCK AND DIRTY SOLUTION JUST TO TEST THE REST OF THE CODE
%     % Average across trials, normalize and concatenate across subjects
%     for ii = 1:length(conds_avg_conds)
%         data_tmp_avg = squeeze(nanmean(data_sbj.wave(strcmp(data_sbj.trialinfo.(conds_avg_field), conds_avg_conds{ii}),:,:),1)); % average trials by electrode
%         %         data_tmp_norm = (data_tmp_avg-min(data_tmp_avg(:)))/(max(data_tmp_avg(:))-min(data_tmp_avg(:))); % normalize
%         data_tmp_norm = data_tmp_avg/max(data_tmp_avg(:));
%         data_all.(conds_avg_conds{ii}) = [data_all.(conds_avg_conds{ii});data_tmp_norm]; % concatenate across subjects
%     end
% end
% 
% %% Load MNI coordinates
% chan_plot = [];
% elecNames_tmp = [];
% for i = 1%length(sbj_names)
%     dirs = InitializeDirs(project_name, sbj_names{i}, comp_root, server_root); % 'Pedro_NeuroSpin2T'
%     coords_tmp = importCoordsFreesurfer(dirs);
%     [MNI_coords, elecNames, isLeft, avgVids, subVids] = sub2AvgBrainCustom([],dirs, fsDir_local);
%     close all
%     elecNames = cellfun(@(x) strsplit(x, '-'), elecNames, 'UniformOutput', false);
%     for ii = 1:length(elecNames)
%         elecNames_tmp{ii} = elecNames{ii}{2};
%     end
%     [a,idx] = ismember(elecNames_tmp, elect_all{i});
%     MNI_coords = MNI_coords(a,:);
%     idx = idx(a);
%     [b,idx_2] = sort(idx);
%     MNI_coords = MNI_coords(idx_2,:);
%     chan_plot = [chan_plot;MNI_coords]; % concatenate electrodes across subjects
% end
% %%%%%%%%%%%%%%%%%%
% %%% CORRECTION %%%
% %%%%%%%%%%%%%%%%%%
% % Make sure that electrodes labels from freesurfer are the same as in the files
% 
% 
% %%
% %% Load template brain
% code_path = '/Users/pinheirochagas/Pedro/Stanford/code/lbcn_preproc/';
% load([code_path filesep 'vizualization/Colin_cortex_left.mat']);
% cmcortex.left = cortex;
% load([code_path filesep 'vizualization/Colin_cortex_left.mat']);
% cmcortex.right = cortex;
% 
% 
% 
% %% Get indices for colloring
% cond = 'math';
% 
% [col_idx,cols] = colorbarFromValues(data_all.(cond)(:), 'RedsWhite');
% % cols = flipud(cols);
% % Plot Colorbar
% figureDim = [0 0 .2 .2];
% figure('units','normalized','outerposition',figureDim)
% for i = 15:5:length(cols)
%     plot(i, 1, '.', 'MarkerSize', 20+(i/2), 'Color', cols(i,:))
%     hold on
% end
% axis off
% dir_out = '/Users/pinheirochagas/Desktop/';
% savePNG(gcf,400, [dir_out 'Reds.png'])
% 
% 
% [col_idx,cols] = colorbarFromValues(data_all.(cond)(:), 'RedsWhite');
% col_idx = reshape(col_idx,size(data_all.(cond),1), size(data_all.(cond),2));
% % only for ECoG
% chan_plot(:,1) = -70;
% chan_plot(:,1) = chan_plot(:,1) - sum(data_all.(cond),2);
% 
% % Plot parameters
% mark = 'o';
% MarkSizeEffect = 35;
% colRing = [0 0 0]/255;
% time = data_sbj.time(find(data_sbj.time == -.2):max(find(data_sbj.time <= 5)));
% 
% 
% %% Plot math
% F = struct;
% count = 0;
% 
% for e = 1:2:length(time)
%     count = count+1;
%     ctmr_gauss_plot(cmcortex.left,[0 0 0], 0, 'l', 1)
%     alpha(0.5)
%     % Sort to highlight larger channels
%     for i = 1:size(chan_plot)
%         %         f = plot3(el_mniPlot_all(i,1)/(1-abs(math_memo_norm_all(i,e))),el_mniPlot_all(i,2),el_mniPlot_all(i,3), 'o', 'Color', 'k', 'MarkerFaceColor', cols(col_idx_math_memo(i,e),:), 'MarkerSize', MarkSizeEffect*abs(math_memo_norm_all(i,e))+0.01);
%         f = plot3(chan_plot(i,1),chan_plot(i,2),chan_plot(i,3), 'o', 'Color', 'k', 'MarkerFaceColor', cols(col_idx(i,e),:), 'MarkerSize', MarkSizeEffect*abs(data_all.(cond)(i,e))+0.01);
%     end
%     time_tmp = num2str(time(e));
%     
%     if length(time_tmp) < 6
%         time_tmp = [time_tmp '00'];
%     end
%     if strcmp(time_tmp(1), '-')
%         time_tmp = time_tmp(1:6);
%     else
%         if strcmp(time_tmp, '000')
%         else
%             time_tmp = time_tmp(1:5);
%         end
%     end
%     
%     text(50, 15, -60, [time_tmp ' s'], 'FontSize', 40)
%     cdata = getframe(gcf);
%     F(count).cdata = cdata.cdata;
%     F(count).colormap = [];
%     close all
% end
% 
% fig = figure;
% movie(fig,F,1)
% 
% videoRSA = VideoWriter([dir_out 'mmr_math.avi']);
% videoRSA.FrameRate = 30;  % Default 30
% videoRSA.Quality = 100;    % Default 75
% open(videoRSA);
% writeVideo(videoRSA, F);
% close(videoRSA);


%% ROL
[ROL] = getROLAll(sbj_name,project_name,block_names,dirs,[105, 15, 61, 81, 70],'HFB',[],'conds_math_memory',{'math'})
