function ss_pca_plot(spikes,varargin)
% SS_PCA_PLOT(spikestruct,varargin)
% Plots the specified principal components of the specified units (or all
% if none defined), with 3D rotational capabilities, and a tool tip that
% highlights all items from the clicked cluster, along with showing the
% unit number.
%
% Possible varargins:
%   'units' : IDs of units to plot
%   'dimensions' : which pca dimensions to plot
%   'incl_outliers' : whether to include the predetermined outliers (will
%   recalculate kmeans and therefore take longer to plot) [0, 1]
%
% E M Merricks 2015

settings.units = [];
settings.dimensions = 1:3;
settings.incl_outliers = 0;

for v = 1:2:length(varargin)
    settings.(varargin{v}) = varargin{v+1};
end

if settings.incl_outliers
    temp.waveforms = [spikes.waveforms; spikes.outliers.waveforms];
    temp.spiketimes = [spikes.spiketimes spikes.outliers.spiketimes];
    temp.assigns = [spikes.assigns zeros(1,length(spikes.outliers.spiketimes))];
    temp.info = spikes.info;
    temp.params = spikes.params;
    spikes = ss_kmeans(temp);
end
base_unq = unique(spikes.assigns);
if ~isempty(settings.units)
    unq = settings.units;
    % Need to remove unit numbers from the input that aren't in the base
    % list here.
else
    unq = base_unq;
end

cols = distinguishable_colors(length(unq));

if ~isfield(spikes.params,'dimension_reduction')
    spikes.params.dimension_reduction = 0;
end
if spikes.params.dimension_reduction
    disp([9 'Using t-SNE dimensionality reduced data'])
    if ~isfield(spikes,'tsne')
        disp([9 'Could not find t-SNE data, calculating now'])
        spikes = ss_tsne(spikes);
    end
    waves = spikes.tsne.data;
else
    %%%%%%%%%% CONSTANTS
    d = diag(spikes.info.pca.s);
    r = find( cumsum(d)/sum(d) >.95,1);
    %waves = spikes.info.pca.scores(:,1:r);
    waves = spikes.waveforms(:,:) * spikes.info.pca.v(:,1:r); 
end

fig = figure;
hold on
group = zeros(1,length(unq));
unit = cell(1,length(unq));
for u = 1:length(unq)
    subset = find(spikes.assigns == unq(u));
    group(u) = plot3(waves(subset,settings.dimensions(1)),...
        waves(subset,settings.dimensions(2)),...
        waves(subset,settings.dimensions(3)),'.','color',cols(u,:));
    unit{u} = ['Unit ' num2str(unq(u))];
end
xlabel(['PC ' num2str(settings.dimensions(1))])
ylabel(['PC ' num2str(settings.dimensions(2))])
zlabel(['PC ' num2str(settings.dimensions(3))])
rotate3d('on')
legend(group,unit,'Location','NorthEastOutside');

dcm_obj = datacursormode(fig);
set(dcm_obj,'UpdateFcn',@myupdatefcn)

function txt = myupdatefcn(empt,event_obj)
% Customizes text of data tips
all_u = get(gca,'Children');
for a = 1:length(all_u)
    set(all_u(a),'Markersize',12);
end
target = get(event_obj,'Target');
unit = get(target,'DisplayName');
set(target,'MarkerSize',24);
txt = {unit};
