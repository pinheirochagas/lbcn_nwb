function nwb = nwb_to_reg_pipeline()
% NWB_TO_REG format file structure and convert data
%   Formats directories, files and data
%   correctly to work with preprocessing pipeline and converts nwb data to 
%   compatible format
%
%   INPUT: 
%
%   Laboratory of Behavioral and Cognitive Neuroscience, Stanford University
%   Authors: Pedro Pinheiro-Chagas, Areti Majumdar
%   Copyright: MIT License 2021

% create directories and cfg
cfg = configurecfg(dirs);

% navigate to folder with nwbData
cd([comp_root '/nwbData'])

%iterate through each file and convert to original data format
nwbfiles = dir('*.nwb');
nwbfiles = dir('*-1.nwb');
for file = nwbfiles'
    nwb_to_reg(file.name, cfg);
end


end
