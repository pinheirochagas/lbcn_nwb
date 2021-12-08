function [bn, ext_name, sbj_name] = get_names(sheet, de_name, round)
%GET_NAMES  gets subject name
%   Accesses google sheet to get subject name and block infomation, uses
%   deidentified name
%   
%   INPUT:
%       sheet: google spreadsheet with subject info 
%
%   Laboratory of Behavioral and Cognitive Neuroscience, Stanford University
%   Authors: Pedro Pinheiro-Chagas, Areti Majumdar
%   Copyright: MIT License 2021   


% load subjVar file, need to deidentify folder/filenames
ext_name = sheet.subj_name_ext(strcmp(sheet.de_name, de_name)); 

% get block number
b_num = ['block' num2str(round)];

% get block name
bn = sheet.(b_num)(strcmp(sheet.de_name, de_name));

sbj_name = sheet.subject_name(strcmp(sheet.de_name, de_name));
end

