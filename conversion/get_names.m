function [block_name, ext_name] = get_names(sheet, sbj_name)
%GET_NAMES  gets subject name
%   Accesses google sheet to get subject name and block infomation
%   
%   INPUT:
%       sheet: google spreadsheet with subject info 
%
%   Laboratory of Behavioral and Cognitive Neuroscience, Stanford University
%   Authors: Pedro Pinheiro-Chagas, Areti Majumdar
%   Copyright: MIT License 2021   

% load subjVar file, need to deidentify folder/filenames
ext_name = sheet.subj_name_ext(strcmp(sheet.subject_name, sbj_name)); 

%get block name
%TODO: fix? this only returns block1
block_name = sheet.block1(strcmp(sheet.subject_name, sbj_name))

end

