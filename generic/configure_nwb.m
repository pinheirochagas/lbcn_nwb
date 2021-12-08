function [cfg] = configure_nwb()
[server_root, comp_root, code_root] = AddPaths('Areti');
dirs = InitializeDirs(' ', ' '); % 'Pedro_NeuroSpin2T'

cfg = [];
cfg.dirs = dirs;
cfg.dirs.output_nwb = '/Volumes/Areti_drive/data/nwbData';
cfg.save = true;
cfg.datatype = 'RAW';% 'HFB', 'RAW'
cfg.freq_band = 'RAW';% 'HFB', 'RAW'
cfg.visualize_channels = true; % display all channels w/ bad channels shown in red
cfg.vol_to_planes = false; %convert volumes to planes 
cfg.plot_elec = true; %plot electrodes; % display all channels w/ bad channels shown in red

end

