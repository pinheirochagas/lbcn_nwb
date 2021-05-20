function [DOCID,GID] = getGoogleSheetInfo_nwb(table,sheet)

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

