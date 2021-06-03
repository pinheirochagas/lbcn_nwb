function cortical_surfaces = convert_cortical_surface(ext_name, dirs)
%% Cortical Surface

%% load subjVar
subj_file = [dirs.original_data filesep ext_name{1} filesep 'subjVar_' ext_name{1} '.mat'];
load(subj_file);

%% initialize objects
cortical_surfaces = types.ndx_ecog.CorticalSurfaces;

%% Create left surface
surfL = types.ndx_ecog.Surface();

surfL.vertices = subjVar.cortex.left.vert';
surfL.faces = subjVar.cortex.left.tri';

%add to cortical surfaces object
cortical_surfaces.surface.set('left', surfL);

%% Create right surface
surfR = types.ndx_ecog.Surface();

surfR.vertices = subjVar.cortex.right.vert';
surfR.faces = subjVar.cortex.right.tri';

cortical_surfaces.surface.set('right', surfR);


% can add more surface objects
end
