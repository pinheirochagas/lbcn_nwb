function visualize_channels(data, globalVar)
%VISUALIZE_CHANNELS plots eeg data from all electrodes
%     INPUT:
%         data: data: struct of wave and sample rate info (created in ConcatenateAll_continuous)
%         globalVar: global variables structure
%   Laboratory of Behavioral and Cognitive Neuroscience, Stanford University
%   Authors: Pedro Pinheiro-Chagas, Areti Majumdar
%   Copyright: MIT License 2021  
       

for i = 1:128
    if sum(i == globalVar.badChan) == 1
        plot(data.wave(i,:)+(i*1000), 'r')
    else
        plot(data.wave(i,:)+(i*1000), 'k')
    end
    hold on
end
title('All EEG Data')
xlabel('time')
ylabel('electrode')
end

