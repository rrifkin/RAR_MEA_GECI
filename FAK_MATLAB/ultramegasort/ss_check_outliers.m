function ss_check_outliers(spikes)

d = diag(spikes.info.pca.s);
r = find( cumsum(d)/sum(d) >.95,1);

waves = [spikes.waveforms(:,:); spikes.outliers.waveforms(:,:)] * spikes.info.pca.v(:,1:r);

until = length(spikes.waveforms);
figure
plot3(waves(1:until,1),waves(1:until,2),waves(1:until,3),'.')
hold on
plot3(waves(until+1:end,1),waves(until+1:end,2),waves(until+1:end,3),'r.')
