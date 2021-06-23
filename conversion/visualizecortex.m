function visualizecortex()

ctmr_gauss_plot(nwb.general_subject.corticalsurfaces.value.surface.get('left').vertices, electrodes, weights,hemi,viewside);

end

