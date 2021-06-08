function plot_electrode_volume(subjVar, el)


el_coord = round([nwb.general_extracellular_ephys_electrodes.vectordata.get('x').data(el), ...
                  nwb.general_extracellular_ephys_electrodes.vectordata.get('y').data(el), ...
                  nwb.general_extracellular_ephys_electrodes.vectordata.get('z').data(el)]);

planes = fields(subjVar.volumes);
sVol = size(subjVar.volumes.axial,2);


xyz(1,1)=el_coord(1,2);
xyz(1,2)=el_coord(1,1);
xyz(1,3)=sVol-el_coord(1,3);

%not sure how to fix this, what is elecID?
for ip = 1:3
    subplot(1,3,ip)
    imshow(subjVar.volumes.(planes{ip}){el_coord(ip)})
    hold on
    if strcmp(planes{ip}, 'axial')
        plot(xyz(1,3),xyz(1,1),'.','color','r','markersize',30);
    elseif strcmp(planes{ip}, 'sagittal')
        plot(xyz(1,3),xyz(1,2),'.','color','r','markersize',30);
    elseif strcmp(planes{ip}, 'coronal')
        plot(xyz(1,2),xyz(1,1),'.','color','r','markersize',30);
    end
end




imshow(subjVar.volumes.axial{xyz(1)})
hold on
plot(xyz(3),xyz(2),'.','color',[1 0 0],'markersize',30)




end