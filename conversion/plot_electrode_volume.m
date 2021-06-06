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