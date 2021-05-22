function [task, general_keywords, session_start] = get_task(sbj_name)
% Get task information from sbj_name

% Load table
[DOCID,GID] = getGoogleSheetInfo_nwb('nwb_meta_data', 'cohort');
sheet = GetGoogleSpreadsheet(DOCID, GID);

task = sheet.task{strcmp(sheet.subject_name, sbj_name)};
general_keywords = sheet.general_keywords{strcmp(sheet.subject_name, sbj_name)};

%date stored in month/day/year format
date = sheet.session1_start{strcmp(sheet.subject_name, sbj_name)};
date = strsplit(date, '/');
session_start = datetime(str2double(strcat('20', date(3))), str2double(date(1)), str2double(date(2)));

end
