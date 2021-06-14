function [K, sil,groups] = kmeanscheck(cvdata,clustnum,cadata,timesca)
%Checks the validity of the kmeans clutering using silhouette scores. Plots
%the silhouette scores and calsginal for each group.

%kmeans
%K = kmeans(cvdata,clustnum,'Distance','correlation','MaxIter',100000,'Replicates',10);
%kmedoids
K = kmedoids(cvdata,clustnum,'Distance','cityblock','Options',statset('MaxIter',100000),'Replicates',10);


%extract groups
a = clustnum;
A=[];
B = [];
C=[];
for i=1:a
A = find(K==i);
B=A;
groups.kclusters{i,1} = A;
    for k=1:length(B)
        C(k,:) = cadata(B(k),:);
        k=k+1;
    end
    figure; plot(timesca, C);
    C=[];
i=i+1;
end

figure;
[sil,h] = silhouette(cvdata,K);

meansil = mean(sil)

    


end

