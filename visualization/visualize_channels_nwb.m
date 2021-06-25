function visualize_channels_nwb(nwb)
%VISUALIZE_CHANNELS_NWB plots eeg data from all electrodes using
%   information from nwb file
%     INPUT:
%         nwb: Neurodata without borders object type
%         
%   Laboratory of Behavioral and Cognitive Neuroscience, Stanford University
%   Authors: Pedro Pinheiro-Chagas, Areti Majumdar
%   Copyright: MIT License 2021  
       

for i = 1:size(subjVar.elinfo, 1)
%    if sum(i == globalVar.badChan) == 1
%        plot(data.wave(i,:)+(i*1000), 'r')
%    else
        plot(data.wave(i,:)+(i*1000), 'k')
%    end
    hold on
end
title('All EEG Data')
xlabel('time')
ylabel('electrode')
end

