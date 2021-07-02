function visualize_channels_nwb(nwb)
%VISUALIZE_CHANNELS_NWB plots eeg data from all electrodes using
%   information from nwb file
%     INPUT:
%         nwb: Neurodata without borders object type
%         
%   Laboratory of Behavioral and Cognitive Neuroscience, Stanford University
%   Authors: Pedro Pinheiro-Chagas, Areti Majumdar
%   Copyright: MIT License 2021  
       

%iterate through length of electrodes
%photodiode channel is last channel
for i = 1:(nwb.general_extracellular_ephys_electrodes.id.data.dims - 1)
    
   noisy = load(nwb.general_extracellular_ephys_electrodes.vectordata.get('noisy_channels').data);
   data = load(nwb.acquisition.get('ElectricalSeries').data);

   if noisy(i) == 1
       plot(data(i,:)+(i*1000), 'r')
   else
        plot(data(i,:)+(i*1000), 'k')
    end
    hold on
end
title('All EEG Data')
xlabel('time')
ylabel('electrode')
end

