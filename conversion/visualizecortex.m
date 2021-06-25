function visualizecortex()

ctmr_gauss_plot(read.general_subject.corticalsurfaces.value.surface.get('left').vertices, electrodes, [],'left','lateral');


ctmr_gauss_plot(read.general_subject.corticalsurfaces.value.surface.get('left'),[0 0 0], 0, 'left','lateral')

end

