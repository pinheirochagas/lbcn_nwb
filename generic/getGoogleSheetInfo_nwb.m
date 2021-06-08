function [DOCID,GID] = getGoogleSheetInfo_nwb(table,sheet)
%GETGOOGLESHEETINFO_NWB directs to correct google sheet
%   returns DOCID and GID information of target google sheet.    
%
%   INPUTS:
%       table: name of table or spreadsheet
%       sheet: name of sheet within table or spreadsheet
%
%   Laboratory of Behavioral and Cognitive Neuroscience, Stanford University
%   Authors: Pedro Pinheiro-Chagas, Areti Majumdar
%   Copyright: MIT License 2021   

if isempty(sheet)
    sheet = 'generic';
else
end

switch table
    case 'nwb_meta_data'
        DOCID = '12AfcX5inXY9YKjgnlV7ero6FYea5WSY7JQBsFVXj8Uo';
        
        switch sheet
            case 'cohort'
                GID = '0';
                
        end
end


end

