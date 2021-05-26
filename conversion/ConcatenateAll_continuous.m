function data_all = ConcatenateAll_continuous(sbj_name, project_name, block_names, dirs,elecs, datatype, freq_band, ext_name)
%% Define electrodes



load([dirs.original_data filesep ext_name{1} filesep 'subjVar_' ext_name{1} '.mat'])
if isempty(elecs)
    elecs = 1:size(subjVar.elinfo,1);
end

if ~isfield(subjVar, 'elinfo')
    data_format = GetFSdataFormat(sbj_name, 'Stanford');
    subjVar = CreateSubjVar(sbj_name, dirs, data_format);
else
end

%% loop through electrodes
concatfields = {'wave'}; % type of data to concatenate
for ei = 1:length(elecs)
    el = elecs(ei);
    
    data_bn = concatBlocks_continuous(sbj_name,project_name,block_names,dirs,el,freq_band,datatype,concatfields, ext_name);
    elecnans(ei) = sum(sum(isnan(data_bn.wave)));
    
    % Concatenate all subjects all trials
    data_all.wave(ei,:) = data_bn.wave;
    data_all.fsample = data_bn.fsample;
end

end
