files = dir('*.mat');
merged = MultipleUnits('patient','combinedAZD');
for f = 1:length(files)
    temp = load(files(f).name);
    [~,name] = fileparts(files(f).name);
    data = temp.(['data_' name]);
    for u = 1:length(data.units)
        data.units(u).extra.originalUID = data.units(u).UID;
        data.units(u).patient = data.patient;
        data.units(u).seizure = data.seizure;
        merged.add_unit(data.units(u));
    end
end

%% for actual subclassification
wb = cell2mat({merged.units.wideband}');
ac_index = NaN(1,length(merged.units));
cumulac = NaN(length(merged.units),101);
for d = 1:length(merged.units)
    [ac,lags] = merged.units(d).autocorr(0:100);
    cumulac(d,:) = cumsum(ac)/nansum(ac);
    ac_index(d) = sum(cumulac(d,:));
end

norm_wb = nan(size(wb));
v2p = nan(1,size(wb,1));
for w = 1:size(wb,1);
    norm_wb(w,:) = wb(w,:) - mean(wb(w,:));
    norm_wb(w,:) = zscore(norm_wb(w,:));
    [~,v] = max(norm_wb(w,201:end));
    v2p(w) = v/30;
end

%% probability
[h_ac,x_ac] = histcounts(ac_index,100,'normalization','cdf');
[h_v,x_v] = histcounts(v2p,100,'normalization','cdf');
x_ac = x_ac(2:end)-diff(x_ac(1:2));
x_v = x_v(2:end)-diff(x_v(1:2));

for a = 1:length(v2p)
    [~,p] = min(abs(x_v - v2p(a)));
    prob(1,a) = h_v(p);
    [~,p] = min(abs(x_ac - ac_index(a)));
    prob(2,a) = h_ac(p);
end

in_prob = 1 - mean(prob);

%[xData, yData] = prepareCurveData(x(2:end)-diff(x(1:2)), cumsum(h)/sum(h));
 
%ft = fittype('a/(1+exp(-b*(x-c)))','independent','x','dependent','y');
%opts = fitoptions('Method','NonlinearLeastSquares');
%opts.Display = 'Off';
%[fitresult, gof] = fit(xData, yData, ft, opts);
%res = fitresult.a ./ (1+exp(-fitresult.b*(xData-fitresult.c)));
 
%dev = res' - cumsum(h)/sum(h);
%zci = @(v) find(v(:).*circshift(v(:), [-1 0]) <= 0);
%zx = zci(dev);
%pre = dev(zx(2)); % ignore first zero crossing
%post = dev(zx(2)+1);
%ratio = (-pre/post)/2;
%zero_crossing = xData(zx(2)) + (diff(xData(1:2)) * ratio);
 
%hfig = figure;
%hfig.Position(3:4) = [1520 435];
%ax(1) = axes('Position',[0.04 0.12 0.29 0.84]);
%hold(ax(1),'all')
%plot(ax(1),xData,cumsum(h)/sum(h),'linewidth',2)
%plot(ax(1),xData,res)
%line(ax(1),[1 1] * zero_crossing,[0 1],'color','k','linewidth',2,'linestyle','--')
%lg = legend(ax(1),{'True data','Sigmoid fit','Cutoff for unexpected values'});
%lg.Location = 'southeast';


%% plotting
%figure; plot((-200:200)/30,norm_wb')

%figure; plot(v2p,ac_index,'.','MarkerSize',14)

%figure; plot((-200:200)/30,norm_wb(v2p>0.7,:),'k') 
%hold on 
%plot((-200:200)/30,norm_wb(v2p<0.7,:),'r')

%figure; histogram(v2p,50)

%figure; hold on
%for w = 1:size(wb,1);
    %plot((-200:200)/30,norm_wb(w,:),'color',[in_prob(w) 0 0])
%end

%% going back in
in = find(v2p<0.7);
pc = find(v2p>=.7);
in_probab = find(in_prob>0.6);
pc_probab = find(in_prob<=0.6);
for u = 1:length(merged.units)
    merged.units(u).type = 'pc';
end
for i = 1:length(in)
    merged.units(in(i)).type = 'in';
end

figure; merged.raster('showtypes',true)