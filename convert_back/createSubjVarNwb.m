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
subjVar.sbj_name = sbj_name{1};

% demographics
subject_name = nwb.general_subject.subject_id;
sex = nwb.general_subject.sex;
age = nwb.general_subject.age;

subjVar.demographics = table(cellstr(subject_name), sex, age, 'VariableNames', {'subject_name', 'sex', 'age'});

% add cortex
subjVar.cortex.left.vert = nwb.general_subject.corticalsurfaces.value.surface.get('left').vertices';
subjVar.cortex.left.tri = nwb.general_subject.corticalsurfaces.value.surface.get('left').faces';

subjVar.cortex.right.vert = nwb.general_subject.corticalsurfaces.value.surface.get('right').vertices';
subjVar.cortex.right.tri = nwb.general_subject.corticalsurfaces.value.surface.get('right').faces';

% add labels_EDF
subjVar.labels_EDF = [];

% add volumes
subjVar.V = nwb.processing.get('Volumes').nwbdatainterface.get('grayscale_volume').data;

% add elinfo

end
