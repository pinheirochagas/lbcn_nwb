function [electrical_series] = add_eeg_data(tbl, data)
%ADD_EEG_DATA   add eeg data
%   Links electrode table to electrical series and adds eeg data.
%   
%   INPUT:
%       tbl: table of electrode infomation
%       data: struct of wave and sample rate info (created in
%       ConcatenateAll_continuous)
%
%   Laboratory of Behavioral and Cognitive Neuroscience, Stanford University
%   Authors: Pedro Pinheiro-Chagas, Areti Majumdar
%   Copyright: MIT License 2021  


electrodes_object_view = types.untyped.ObjectView('/general/extracellular_ephys/electrodes');


% 'table' attribute is a link to another DynamicTable (in this case, the electrodes table, tbl)
% 'data' indicates the rows of the table
electrode_table_region = types.hdmf_common.DynamicTableRegion(...
    'table', electrodes_object_view, ...
    'description', 'all electrodes', ...
    'data', (0:height(tbl)-1)');


% add starting time and starting time rate info
electrical_series = types.core.ElectricalSeries( ...
    'starting_time', 0.0, ...
    'starting_time_rate', data.fsample, ...
    'data', data.wave, ...
    'electrodes', electrode_table_region, ...
    'data_unit', 'volts');

end

