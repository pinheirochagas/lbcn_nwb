function nwb = initialize_nwb(de_name, de_blockname, sheet)
%INITIALIZE_NWB create & initialize nwb file
%
%   INPUTS:
%       sbj_name: subject name
%
%   Laboratory of Behavioral and Cognitive Neuroscience, Stanford University
%   Authors: Pedro Pinheiro-Chagas, Areti Majumdar
%   Copyright: MIT License 2021 

nwb = NwbFile();
nwb.general_institution = 'Stanford';
[nwb.session_description, nwb.general_keywords, nwb.session_start_time] = get_task(de_name, sheet);
nwb.general_session_id = de_blockname;
nwb.identifier = de_blockname;
nwb.general_source_script_file_name	= 'nwb_pipeline.m';

end

