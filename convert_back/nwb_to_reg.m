function nwb_to_reg(nwb, cfg)
% NWB_TO_REG convert nwb file to usable data format
%   Formats data from nwb file to correct folders and names to be compatible
%   with preprocessing pipeline
%
%   INPUT: 
%       nwb: path to .nwb file
%
%   Laboratory of Behavioral and Cognitive Neuroscience, Stanford University
%   Authors: Pedro Pinheiro-Chagas, Areti Majumdar
%   Copyright: MIT License 2021

% load nwb data
nwb = nwbRead(nwb);
sbj_name = nwb.general_subject.subject_id;
task = nwb.session_description;

% create correct folders and add data for neuralData folder
mkdir([cfg.originalData '/' sbj_name])

% original data needs a global variable, subjVar, folders with trial names, and
% within the trial name subfolders goes the raw data

% create correct folders and add data for psychData folder
mkdir([cfg.psychData '/' sbj_name])

% create and save trialinfo
createTrialInfo(nwb, cfg, sbj_name);

% create and save subjVar
createSubjVarNwb(nwb, cfg, sbj_name);

% Write data
addData(nwb, cfg, sbj_name);

end
