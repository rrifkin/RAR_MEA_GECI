%% Basic extract and plot:
% Load the file:
load('/Volumes/External/Single Unit Analysis/4:25:19 AZD/TM3S1_zeromag/channel31.mat');
% Choose which Unit ID you want to extract: (this is the one with the weird
% bump)
id = 12;
% Extract the waveforms and spike times of those assigned this ID:
inds = spikes.assigns == id;
waveforms = spikes.waveforms(inds,:);
spiketimes = spikes.spiketimes(inds);
% Plot the waveforms:
figure
plot((-18:30)/30, waveforms'); % (-18:30)/30 is -0.6 to 1 ms at 30 kHz

%% More in depth plot (also showing how I change the default figure design):
hfig = figure;
hfig.Position = [100 100 800 620];
ax = axes('Parent',hfig,'Position',[0.08 0.06 0.88 0.88]);

cRes = 128; % color resolution (number of distinct colors)
cmap = parula(cRes); % create the default color map with cRes resolution

% Calculate the PCA for color plotting (just an example, it'd be good to
% plot the color based on spike half width, but that's more than one line
% of code, and within these waveforms that width should be the most common
% deviation, so the first PC score will approximate the half width)
[~,pc] = pca(waveforms);

hold(ax,'on');
for t = 1:length(spiketimes)
    % work out which color bin we should be in, based on its first PC score
    c = round(((pc(t,1) - min(pc(:,1)))/range(pc(:,1))*(cRes-1))+1);
    plot3(ax,(-18:30)/30,ones(size(waveforms(t,:)))*spiketimes(t),waveforms(t,:),'color',cmap(c,:));
end

%{
% If you didn't want specific colors you could have just done this instead of lines 19-33:
zt = ones(size(waveforms)).*spiketimes;
plot3(ax,(-18:30)/30,zt,waveforms)
%}

xlabel(ax,'Time (ms)')
ylabel(ax,'Time (s)')
zlabel(ax,'Voltage (\muV)')

% You can set properties of axes objects either like this:
set(ax,'linewidth',1.5,'FontSize',14,'FontName','Helvetica Neue');
% Or like these:
ax.YDir = 'reverse';
ax.TickDir = 'out';
ax.TickLength = [0.005 0.005];
ax.Color = 'none';
ax.XColor = [0.7 0.7 0.7];
ax.YColor = [0.7 0.7 0.7];
ax.ZColor = [0.7 0.7 0.7];
ax.GridColor = [0.7 0.7 0.7];
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.ZGrid = 'on';

hfig.Color = [0.1412 0.1529 0.1804];

rotate3d(ax,'on')
view(ax,[-20 15])