function visualizecortex(nwb, hemisphere, view)
nwb = nwbRead(nwb);
struct = nwb.general_subject.corticalsurfaces.value.surface.get(hemisphere);
cortex.vertices = s.load';
cortex.faces = struct.faces.load';

plot_cortex(cortex,[0 0 0], 0, hemisphere,view)
x = nwb.general_extracellular_ephys_electrodes.vectordata.get('x_subject').data(1:end-1);
y = nwb.general_extracellular_ephys_electrodes.vectordata.get('y_subject').data(1:end-1);
z = nwb.general_extracellular_ephys_electrodes.vectordata.get('z_subject').data(1:end-1);

LvsR = nwb.general_extracellular_ephys_electrodes.vectordata.get('LvsR').data;

for ii = 1:length(x)
    hold on
    % Only plot on the relevant hemisphere
    if (strcmp(hemisphere, 'left') == 1 && strcmp(LvsR(ii), 'R') == 1) || (strcmp(hemisphere, 'right') == 1 && strcmp(LvsR(ii), 'L') == 1)
    else
        plot3(x(ii),y(ii),z(ii), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k');
    end
end

end

