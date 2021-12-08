function cfg = configurecfg(dirs)


dataFolder = [dirs.comp_root '/convertedNWBData'];
mkdir(dataFolder)
addpath(fullfile(pwd, dataFolder)); %current folder is returned by pwd. Combined with newfolder gives full path.
cfg.dataFolder = dataFolder;

neural = [dataFolder '/neuralData'];
psych = [dataFolder '/psychData'];

mkdir(neural)
mkdir(psych)
cfg.neuralData = neural;
cfg.psychData = psych;

og = [neural '/originalData'];
mkdir(og)
cfg.originalData = og;

% outer data folder
cfg.comp_root = dirs.comp_root;

end