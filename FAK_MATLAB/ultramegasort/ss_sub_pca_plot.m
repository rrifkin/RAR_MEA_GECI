function ss_sub_pca_plot(spikes,units)
% SS_SUB_PCA_PLOT(spikestruct,units,upto)
% Plots 1st 3 principal components of specified units (defaults to all),
% having recalculated the PCA just for these waveforms.
%
% E M Merricks 2015

base_unq = unique(spikes.assigns);
if nargin > 1 && ~isempty(units)
    unq = units;
    % Need to remove unit numbers from the input that aren't in the base
    % list here.
else
    unq = base_unq;
end

cols = distinguishable_colors(length(unq));

inds = ismember(spikes.assigns,unq);
subwaves = spikes.waveforms(inds,:);
assigns = spikes.assigns(inds);

[pca.u,pca.s,pca.v] = svd(detrend(subwaves(:,:),'constant'), 0);

d = diag(pca.s);
r = find( cumsum(d)/sum(d) >.95,1);
waves = subwaves(:,:) * pca.v(:,1:r);


fig = figure;
hold on
group = zeros(1,length(unq));
unit = cell(1,length(unq));
for u = 1:length(unq)
    subset = find(assigns == unq(u));
    group(u) = plot3(waves(subset,1),...
        waves(subset,2),...
        waves(subset,3),'.','color',cols(u,:));
    unit{u} = ['Unit ' num2str(unq(u))];
end
xlabel('PC 1')
ylabel('PC 2')
zlabel('PC 3')
rotate3d('on')
legend(group,unit,'Location','NorthEastOutside');

dcm_obj = datacursormode(fig);
set(dcm_obj,'UpdateFcn',@myupdatefcn)

function txt = myupdatefcn(~,event_obj)
% Customizes text of data tips
all_u = get(gca,'Children');
for a = 1:length(all_u)
    set(all_u(a),'Markersize',12);
end
target = get(event_obj,'Target');
unit = get(target,'DisplayName');
set(target,'MarkerSize',24);
txt = {unit};
