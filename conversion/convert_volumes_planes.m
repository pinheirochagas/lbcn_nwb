data =


data = mri.vol(:,xyz(2,1),:)


for i = 1:size(xyz,1)
    axial{i} = squeeze(mri.vol(:,xyz(i,1),:));
    sagittal{i} = squeeze(mri.vol(xyz(i,2),:,:));
    coronal{i} = squeeze(mri.vol(:,:,xyz(i,3)))';
end

V = subjVar.V;


el_coord = round(subjVar.elinfo.MGRID_coord(1,:))

planes = {'axial', 'sagittal', 'coronal'}

for ip = 1:3
    subplot(1,3,ip)
    imshow(subjVar.volumes.(planes{ip}){el_coord(ip)})
    
    if strcmp(planes{ip}, 'axial')
        plot(xyz(elecId,3),xyz(elecId,2),'.','color',elecRgb(elecId,:),'markersize',30,'parent',slice2d_axes(1));
    elseif
        
    elseif
        
    end
end

function subjVar = convert_volumes_planes(subjVar)
V = subjVar.V;
for i = 1:size(s,1)
    subjVar.volumes.axial{i} = squeeze(V(:,i,:));
    subjVar.volumes.sagittal{i} = squeeze(V(i,:,:));
    subjVar.volumes.coronal{i} = squeeze(V(:,:,i))';
end

end

function plot_electrode_volume(subjVar, el)
sVol = size(subjVar.V)
el_coord = subjVar.elinfo.MGRID_coord(el,:)

xyz(:,1)=el_coord(:,2);
xyz(:,2)=el_coord(:,1);
xyz(:,3)=sVol(3)-el_coord(:,3);

imshow(subjVar.volumes.axial{xyz(1)})
hold on
plot(xyz(3),xyz(2),'.','color',[1 0 0],'markersize',30)

end

