function cortical_surfaces = convert_cortical_surface(sbj_name)
%% Cortical Surface

%load subjVar
subj_file = [dirs.original_data filesep ext_name{1} filesep 'subjVar_' ext_name{1} '.mat'];
load(subj_file);

%initialize objects
cortical_surfaces = types.ndx_ecog.CorticalSurfaces;
surf = types.ndx_ecog.Surface();

%errors here
surf.vertices = subjVar.cortex.left.vert;
surf.faces = subjVar.cortex.left.tri;

%add to cortical surfaces object
cortical_surfaces.surface.set('left', surf);
% can add more surface objects

%this section goes in lbcn_nwb_convert
file.subject = types.ndx_ecog.ECoGSubject('subject', cortical_surfaces);
end