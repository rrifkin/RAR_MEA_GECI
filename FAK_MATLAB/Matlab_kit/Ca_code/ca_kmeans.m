function [groups] = ca_kmeans(cadata,catimes,clustnum,X,map,img,r,r_histo,histochanlocs,chanlocs)
%ca_kemans. Performs kmeans analysis on the delta_intensities traces over a
%period of interest and plits the silhouette scores, calcium signals and
%the spatial distribution of the traces

K = kmeans(cadata,clustnum,'Distance','correlation','MaxIter',100000,'Replicates',10);

color = ['r';'g';'b';'m';'k';'y';'c';'w'];

%extract groups
a = clustnum;
A=[];
B = [];
C=[];
for i=1:a
E = color(i);
A = find(K==i);
B=A;
groups.kclusters{i,1} = A;
    for k=1:length(B)
        C(k,:) = cadata(B(k),:);
        k=k+1;
    end
    figure; plot(catimes, C,'Color', E);
    C=[];
i=i+1;
end

figure;
[sil,h] = silhouette(cadata,K);
meansil = mean(sil)

% %display spatial distribution of groups
% A=[];
% B=[];
% C = [];
% D = [];
% E = [];
% F=[];
% 
% figure;
% imshow(X,map);
% for i=1:F
%     E = color(i);
%     A = groups.kclusters{i,1};
%         for j=1:length(A)
%             B = A(j);
%             C = chanlocs(B,1);
%             D = chanlocs(B,2);
%             circles(C,D,r,'LineWidth',3,'edgecolor',E,'facecolor','none');
%             j=j+1;
%         end
%        i=i+1;
% end
% 
% A=[];
% B=[];
% C = [];
% D = [];
% E = [];
% F=[];
% 
% figure;imshow(img);
% F = (length(groups.kclusters));
% for i=1:F
%     E = color(i);
%     A = groups.kclusters{i,1};
%         for j=1:length(A)
%             B = A(j);
%             C = histochanlocs(B,1);
%             D = histochanlocs(B,2);
%             circles(C,D,r_histo,'LineWidth',3,'edgecolor',E,'facecolor','none');
%             j=j+1;
%         end
%        i=i+1;
% end


end

