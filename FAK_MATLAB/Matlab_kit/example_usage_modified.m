
%load data
%raw = openNSx('/mnt/mfs/home/NIMASTER/bjg2140/TAE_LGG_GCAMP/Ephys Data/TAE LGG GCamP/Raw Data/042519/tm3_slice1_zmg.ns5');
%raw = openNSx('/mnt/mfs/home/NIMASTER/fak2121/rawMUA/tm7_slice2_zmg.ns5');
raw = openNSx('/mnt/mfs/home/NIMASTER/fak2121/Raw Data/FK_10_21_CTL_Non_Treated/slice3/slice3_zmg.ns5');

% Purely for identification purposes within the MultipleUnits object, and
% don't need to be set:
patient = 'CM4S3';
seizure = 33;

% Directory of files with spike sorting results from UltraMegaSort2000
filepath = '/mnt/mfs/home/NIMASTER/fak2121/Sorted Spikes/CM4S3_ZMG';

% Load up a list of files in that directory, e.g. where files are called DataFromChannel{1-n}.mat
fls = dir([filepath filesep 'channel*.mat']);

% Name of the output struct in those files (set this to whatever variable
% name you saved the UltraMegaSort2000 output as):
spikestruct = 'spikes';

% Create the MultipleUnits object to hold them (leave out unnecessary 
% parameters for your circumstances):
data = MultipleUnits('patient', patient, 'seizure', seizure);

% Loop through the files of spike sorting results:
for f = 1:length(fls)
    % Load and extract the data into spikes variable:
    temp = load([filepath filesep fls(f).name],spikestruct);
    spikes = temp.(spikestruct);
    
    % Find which clusters have been marked as good in SplitMerge or
    % splitmerge_tool (or manually):
    good = spikes.labels(spikes.labels(:,2) == 2,1);
    
    % Extract the channel number from the file name (or however else you'd
    % like to do so, can't say I recommend this way):
    channel = str2double(strrep(strrep(fls(f).name,'channel',''),'.mat',''));
    
    % For each cluster marked as "good" make a SingleUnit object, and add
    % it to the MultipleUnits object:
    for g = 1:length(good)
        unit = SingleUnit(...
            'times',        spikes.spiketimes(spikes.assigns == good(g))', ...
            'waveforms',    spikes.waveforms(spikes.assigns == good(g),:), ...
            'channel',      channel ...
            );
        unit.extra.originalID=good(g);
        % Add the SingleUnit to the MultipleUnits:
        data.add_unit(unit); % add_unit auto adds a unique ID for the unit if none is there
    end
end
save([filepath filesep patient '_' num2str(seizure) '_units.mat'],'data')
data.order_by_channel;
 
spkwin = -200:200;
 
for u = 1:length(data.units)
    disp([9 'working on ' num2str(u) ' of ' num2str(length(data.units))]) 
    tt = round(data.units(u).times*3e4);
    wb = extract_spks(tt,raw.Data(data.units(u).channel,:),spkwin);
    wb = double(wb)./4;
    wideband = nanmean(wb);
    data.units(u).wideband = wideband - mean(wideband);
end

