function nwb = lbcn_nwb_convert(sbj_name,task, cfg)
% wraps whole pipeline here

%% Link Google Spreadsheet with subject information
[DOCID,GID] = getGoogleSheetInfo_nwb('nwb_meta_data', 'cohort');
sheet = GetGoogleSpreadsheet(DOCID, GID);

%% Retrieve subject & block information
[sbj_name, block_name, ext_name] = get_names(sheet);

%% Initialize nwb file
nwb = initialize_nwb(sbj_name, sheet);

%% Subject Information
% what subject info to include
%   aka age, DOB, description, genotype, sex, species, subj_id -
%   deidentified, no initials
nwb.general_subject = get_subject(sbj_name, sheet)

%% Concatenate block data
data = ConcatenateAll_continuous(sbj_name,nwb.session_description,block_name,dirs ,[], cfg.datatype, cfg.freq_band, ext_name);

%% For visualization - display data for all channels with bad channels in red
if cfg.visualize_channels
    for i = 1:128
    if sum(i == globalVar.badChan) == 1
        plot(data.wave(i,:)+(i*1000), 'r')
    else
        plot(data.wave(i,:)+(i*1000), 'k')
    end
    hold on
    end
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

%% Export file
if cfg.save == true
    cd(dirs.output_nwb)
    nwbExport(nwb, 'nwb_practice.nwb')
else
end

end

