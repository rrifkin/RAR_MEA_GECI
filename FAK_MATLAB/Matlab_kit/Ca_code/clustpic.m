function  clustpic(groups,chanlocs,histochanlocs,X,map,img,r,r_histo)
%clustpic Displays  picture of the clusters on a photo of the slice
%   X, map are the coordinates and intensities for the photo. Chanlocs are
%   the coordinates for the channels. Groups is a structure array produced
%   by the function kmeanscheck and contains the channels which are a part
%   of each cluster. r is the radius of the circle around each channel.


color = ['r';'g';'b';'m';'k';'y';'c';'w'];
figure;imshow(X,map);
F = (length(groups.kclusters));
for i=1:F
    E = color(i);
    A = groups.kclusters{i,1};
        for j=1:length(A)
            B = A(j);
            C = chanlocs(B,1);
            D = chanlocs(B,2);
            circles(C,D,r,'LineWidth',3,'edgecolor',E,'facecolor','none');
            j=j+1;
        end
       i=i+1;
end
A=[];
B=[];
C = [];
D = [];
E = [];
F=[];

figure;imshow(img);
F = (length(groups.kclusters));
for i=1:F
    E = color(i);
    A = groups.kclusters{i,1};
        for j=1:length(A)
            B = A(j);
            C = histochanlocs(B,1);
            D = histochanlocs(B,2);
            circles(C,D,r_histo,'LineWidth',3,'edgecolor',E,'facecolor','none');
            j=j+1;
        end
       i=i+1;
end
            
end

