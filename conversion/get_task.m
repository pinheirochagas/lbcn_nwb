function [task, general_keywords] = get_task(sbj_name)
% Get task information from sbj_name

% Load table
[DOCID,GID] = getGoogleSheetInfo_nwb('nwb_meta_data', 'cohort');
sheet = GetGoogleSpreadsheet(DOCID, GID);

task = sheet.task{strcmp(sheet.sbj_name, sbj_name)};
general_keywords = sheet.general_keywords{strcmp(sheet.sbj_name, sbj_name)};


end

