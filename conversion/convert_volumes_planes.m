function subjVar = convert_volumes_planes(V, plot_elec)
% CONVERT_VOLUMES_PLANES converts MRI volumes to planes
%     Converts 256 x 256 x 256 MRI volume data into axial, sagittal, and 
%     coronal planes that can be accessed from subjVar variable.
%     
%     INPUTS:
%         V: raw MRI volumes data
%         plot_elec: bool, plot electrode on axial, sagittal, and coronal view
%         
%   Laboratory of Behavioral and Cognitive Neuroscience, Stanford University
%   Authors: Pedro Pinheiro-Chagas, Areti Majumdar
%   Copyright: MIT License 2021

V = subjVar.V;
V = nwb.processing.get('Volumes').nwbdatainterface.get('grayscale_volume').data;
for i = 1:size(V,1)
    %error, works when V = subjVar.V but not when 
    % V = nwb.processing.get('Volumes').nwbdatainterface.get('grayscale_volume').data;
    % subjVar.V was copied into ^^ so not sure why its not working
    subjVar.volumes.axial{i} = squeeze(V(:,i,:));
    subjVar.volumes.sagittal{i} = squeeze(V(i,:,:));
    subjVar.volumes.coronal{i} = squeeze(V(:,:,i))';
end

if plot_elec
    plot_electrode_volume(subjVar, el);
end

end



