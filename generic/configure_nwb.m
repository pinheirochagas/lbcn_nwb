function [cfg] = configure_nwb()
[server_root, comp_root, code_root] = AddPaths('Areti');
dirs = InitializeDirs(' ', ' ', comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'

cfg = [];
cfg.dirs = dirs;
cfg.dirs.output_nwb = '/Volumes/Areti_drive/data/nwbData';
cfg.save = true;
cfg.datatype = 'RAW';% 'HFB', 'RAW'
cfg.freq_band = 'RAW';% 'HFB', 'RAW'
cfg.visualize_channels = false; % display all channels w/ bad channels shown in red
cfg.vol_to_planes = false; %convert volumes to planes 
cfg.plot_elec = false; %plot electrodes; % display all channels w/ bad channels shown in red
cfg.vol_to_planes = false; %convert volumes to planes 

end

