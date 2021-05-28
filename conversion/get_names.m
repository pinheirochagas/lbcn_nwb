function [sbj_name, block_name, ext_name] = get_names()
%get subject names and block names
sbj_names = sheet.subject_name;
sbj_name = sbj_names{end}

% load subjVar file, need to deidentify folder/filenames
ext_name = sheet.subj_name_ext(strcmp(sheet.subject_name, sbj_name)); 

%get block name
block_name = sheet.block1(strcmp(sheet.subject_name, sbj_name))

end

