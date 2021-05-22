function [sex, age] = get_subject(sbj_name)

% gets subject information from google doc


% Load table
[DOCID,GID] = getGoogleSheetInfo_nwb('nwb_meta_data', 'cohort');
sheet = GetGoogleSpreadsheet(DOCID, GID);

sex = sheet.sex(strcmp(sheet.subject_name, sbj_name));
age = sheet.age(strcmp(sheet.subject_name, sbj_name));


end

