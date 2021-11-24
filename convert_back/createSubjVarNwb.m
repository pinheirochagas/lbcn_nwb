function createSubjVarNwb(nwb, cfg, sbj_name)
%CREATESUBJVARNWB creates subjVar struct
%   constructs properly formatted subjVar struct. Saves subjVar to originalData.
%
%   INPUTS:
%       nwb: NwbFile type
%       cfg: folder paths 
%       sbj_name: deidentified subject name
% 
%   Laboratory of Behavioral and Cognitive Neuroscience, Stanford University
%   Authors: Pedro Pinheiro-Chagas, Areti Majumdar
%   Copyright: MIT License 2021

% add name
subjVar.sbj_name = sbj_name;

% demographics
subject_name = nwb.general_subject.subject_id;
sex = nwb.general_subject.sex;
age = nwb.general_subject.age;

D = {subject_name sex age};

subjVar.demographics = cell2table(D, 'VariableNames', {'subject_name' 'sex' 'age'});

% add cortex
subjVar.cortex.left.vert = nwb.general_subject.corticalsurfaces.value.surface.get('left').vertices';
subjVar.cortex.left.tri = nwb.general_subject.corticalsurfaces.value.surface.get('left').faces';

subjVar.cortex.right.vert = nwb.general_subject.corticalsurfaces.value.surface.get('right').vertices';
subjVar.cortex.right.tri = nwb.general_subject.corticalsurfaces.value.surface.get('right').faces';

% add labels_EDF
subjVar.labels_EDF = [];

% add volumes
subjVar.V = nwb.processing.get('Volumes').nwbdatainterface.get('grayscale_volume').data.load;

% add elinfo
% note - last row of vectordata is pdio data
LvsR = nwb.general_extracellular_ephys_electrodes.vectordata.get('LvsR').data.load;
DK_long_josef = nwb.general_extracellular_ephys_electrodes.vectordata.get('location').data.load;
FS_label = nwb.general_extracellular_ephys_electrodes.vectordata.get('label').data.load;

x_fsaverage = nwb.general_extracellular_ephys_electrodes.vectordata.get('x_fsaverage').data.load;
y_fsaverage = nwb.general_extracellular_ephys_electrodes.vectordata.get('y_fsaverage').data.load;
z_fsaverage = nwb.general_extracellular_ephys_electrodes.vectordata.get('z_fsaverage').data.load;

x_subject = nwb.general_extracellular_ephys_electrodes.vectordata.get('x_subject').data.load;
y_subject = nwb.general_extracellular_ephys_electrodes.vectordata.get('y_subject').data.load;
z_subject = nwb.general_extracellular_ephys_electrodes.vectordata.get('z_subject').data.load;


for ielec = 1:length(LvsR)
    MNI_coord(ielec, 1, 1) = x_fsaverage(ielec);
    MNI_coord(ielec, 2, 1) = y_fsaverage(ielec);
    MNI_coord(ielec, 3, 1) = z_fsaverage(ielec);
    
    LEPTO_coord(ielec, 1, 1) = x_subject(ielec);
    LEPTO_coord(ielec, 2, 1) = y_subject(ielec);
    LEPTO_coord(ielec, 3, 1) = z_subject(ielec);
    
end

subjVar.elinfo = table(LvsR, DK_long_josef, FS_label, MNI_coord, LEPTO_coord);

% save subjVar
save_path = [cfg.originalData '/' sbj_name ];
table_path_format = fullfile(save_path, ['subjVar_' sbj_name '.mat']);
save(table_path_format, 'subjVar');

end
