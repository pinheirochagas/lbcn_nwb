function subject = get_subject(de_name, sheet)
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

%create subject object
subject = types.core.Subject();

%set id 
subject.subject_id = de_name;

%add any other demographics info
subject.species = 'Homo sapiens';
subject.sex = sheet.sex(strcmp(sheet.de_name, de_name));
subject.age = sheet.age(strcmp(sheet.de_name, de_name));

end

