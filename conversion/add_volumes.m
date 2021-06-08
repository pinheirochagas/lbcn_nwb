function volumes_module = add_volumes(subjVar)
%ADD_VOLUMES adds MRI volumes to nwb file
%     
%   INPUT:
%       subjVar: subject information (contains volumes in variable V)
% 
%   Laboratory of Behavioral and Cognitive Neuroscience, Stanford University
%   Authors: Pedro Pinheiro-Chagas, Areti Majumdar
%   Copyright: MIT License 2021

%create processing module and GrayscaleVolume modules
volumes_module = types.core.ProcessingModule('description', 'MRI Volumes');
grayscale_volume = types.ndx_grayscalevolume.GrayscaleVolume();

%add data to grayscale volume
grayscale_volume.data = subjVar.V;

%set processing module
volumes_module.nwbdatainterface.set('grayscale_volume', grayscale_volume);

end



