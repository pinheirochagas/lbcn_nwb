function [sex, age] = get_subject(sbj_name)
%GET_SUBJECT    subject demographics
%   [Se, A] = GET_SUBJECT(S) is the sex and age of the subject with subject
%   name S. Information is taken from google spreadsheet.
%   
%   INPUTS:
%       sbj_name: subject name
%
%   Laboratory of Behavioral and Cognitive Neuroscience, Stanford University
%   Authors: Pedro Pinheiro-Chagas, Areti Majumdar
%   Copyright: MIT License 2021   

% Load sheet
[DOCID,GID] = getGoogleSheetInfo_nwb('nwb_meta_data', 'cohort');
sheet = GetGoogleSpreadsheet(DOCID, GID);

sex = sheet.sex(strcmp(sheet.subject_name, sbj_name));
age = sheet.age(strcmp(sheet.subject_name, sbj_name));


end

