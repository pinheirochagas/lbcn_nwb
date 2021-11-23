function gen_subj = get_subject(gen_subj, de_name, sheet)
%GET_SUBJECT    subject demographics
%   Function returns a subject object with demographics information. 
%   Information is taken from google spreadsheet.
%   
%   INPUTS:
%       sbj_name: subject name
%       sheet: google spreadsheet with subject info 
%
%   Laboratory of Behavioral and Cognitive Neuroscience, Stanford University
%   Authors: Pedro Pinheiro-Chagas, Areti Majumdar
%   Copyright: MIT License 2021   


%set id 
gen_subj.subject_id = de_name;

%add any other demographics info
gen_subj.species = 'Homo sapiens';
gen_subj.sex = sheet.sex(strcmp(sheet.de_name, de_name));
gen_subj.age = sheet.age(strcmp(sheet.de_name, de_name));

end

