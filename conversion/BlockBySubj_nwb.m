function BN = BlockBySubj(sbj,task)

%returns block names
switch task
    case 'MMR'
        switch sbj
            case 'S12_33'
                BN = {'DA0112-03', 'DA0112-15'};
        end
        
end
end


