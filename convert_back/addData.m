function addData(nwb, cfg, sbj_name)
%ADDDATA Writes electrical series data to correct folder
%   
%   INPUT:
%       nwb: NwbFile type
%       cfg: folder paths 
%       sbj_name: deidentified subject name
% 
%   Laboratory of Behavioral and Cognitive Neuroscience, Stanford University
%   Authors: Pedro Pinheiro-Chagas, Areti Majumdar
%   Copyright: MIT License 2021


data = nwb.acquisition.get('ElectricalSeries').data.load;

block_path = [cfg.originalData '/' sbj_name '/' nwb.identifier];
mkdir(block_path)

for k = 1:nwb.acquisition.get('ElectricalSeries').data.dims(1)
    path_format = fullfile(block_path, ['iEEG' sbj_name '_' num2str(k) '.mat']);
    
    curr = data(k, :);
    
    save(path_format, 'curr');
end

