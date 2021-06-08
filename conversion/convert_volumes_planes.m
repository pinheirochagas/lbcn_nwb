function subjVar = convert_volumes_planes(subjVar)


V = subjVar.V;
for i = 1:size(V,1)
    subjVar.volumes.axial{i} = squeeze(V(:,i,:));
    subjVar.volumes.sagittal{i} = squeeze(V(i,:,:));
    subjVar.volumes.coronal{i} = squeeze(V(:,:,i))';
end

volumes_module = types.core.ProcessingModule('description', 'MRI Volumes');
volumes_module.nwbdatainterface.set('volumes_module', volumes_module);
nwb.processing.set('Volumes', volumes_module);

grayscale_volume = types.ndx_grayscalevolume.GrayscaleVolume()

plot_electrode_volume(subjVar, 1)

end

 
% data = mri.vol(:,xyz(2,1),:)
% 
% 
% for i = 1:size(xyz,1)
%     axial{i} = squeeze(mri.vol(:,xyz(i,1),:));
%     sagittal{i} = squeeze(mri.vol(xyz(i,2),:,:));
%     coronal{i} = squeeze(mri.vol(:,:,xyz(i,3)))';
% end
% 
% V = subjVar.V;
% 




