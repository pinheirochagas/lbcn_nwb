function subjVar = convert_volumes_planes(subjVar)


V = subjVar.V;
for i = 1:size(subjVar,1)
    subjVar.volumes.axial{i} = squeeze(V(:,i,:));
    subjVar.volumes.sagittal{i} = squeeze(V(i,:,:));
    subjVar.volumes.coronal{i} = squeeze(V(:,:,i))';
end

volumes_module = types.core.ProcessingModule('description', 'MRI Volumes');
volumes_module.nwbdatainterface.set('volumes_module', volumes_module);
nwb.processing.set('Volumes', volumes_module);

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
% 
% el_coord = round(subjVar.elinfo.MGRID_coord(1,:))
% 
% planes = {'axial', 'sagittal', 'coronal'}
% 
% %not sure how to fix this, what is elecID?
% for ip = 1:3
%     subplot(1,3,ip)
%     imshow(subjVar.volumes.(planes{ip}){el_coord(ip)})
%     
%     if strcmp(planes{ip}, 'axial')
%         plot(xyz(elecId,3),xyz(elecId,2),'.','color',elecRgb(elecId,:),'markersize',30,'parent',slice2d_axes(1));
%     elseif
%         
%     elseif
%         
%     end
% end




