function [IDX, C] = spectralClustering(data,maxClusters)
%SPECTRALCLUSTERING Performs spectral clustering of data
%   This algorithm is based on the following literature: 
%   Ng, A., Jordan, M., and Weiss, Y. (2002). On spectral clustering: 
%   analysis and an algorithm. Advances in Neural Information 
%   Processing Systems 14 (pp. 849-856). MIT Press.
%
%   Inputs:
%   data = actual data to be clustered
%   maxClusters = maximum number of dynamical clusters allowed
%   
%   Outputs:
%   IDX = cluster indices of every data point
%   C = centroid locations of each cluster
%
%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   For use in:
%   NEXPERIMENT: COMPUTATIONAL PLATFORM FOR MODEL-BASED DESIGN OF
%   EXPERIMENTS TO REDUCE DYNAMICAL UNCERTAINTY
%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Updated by: Aditya Sai
%   Last updated: 1/16/2016

% Calculate the affinity / similarity matrix
affinity = CalculateAffinity(data);
% Compute the degree matrix
D = zeros(size(affinity,1));
for i=1:size(affinity,1)
    D(i,i) = sum(affinity(i,:));
end
% Compute the normalized laplacian / affinity matrix (NL)
NL = zeros(size(affinity));
for i=1:size(affinity,1)
    for j=1:size(affinity,2)
        NL(i,j) = affinity(i,j) / (sqrt(D(i,i)) * sqrt(D(j,j)));  
    end
end
% Remove any nan or inf values in rows or columns
NL(:,~any(~isnan(NL), 1))=[];
NL(~any(~isnan(NL), 2),:)=[];
NL(:,~any(~isinf(NL), 1))=[];
NL(~any(~isinf(NL), 2),:)=[];
% Perform the eigenvalue decomposition
[eigVectors,eigValues] = eig(NL);
% Select the number of clusters
gap = zeros(size(NL,1),1);
% Maximum number of dynamical clusters
if(size(data,1) < maxClusters)
   maxClusters = size(data,1); 
end
% Determine number of clusters by finding the maximizer of the eigengap
for i = 2:size(NL,1)
    if eigValues(i-1,i-1) > 0 && eigValues(i,i) > 0
        gap(i) = abs(eigValues(i-1,i-1) - eigValues(i,i))/eigValues(i,i);
    else
        gap(i) = 0;
    end
end
% Choose default number of clusters in the event that maximum of the
% eigengap is non-unique
[~,nClusters] = max(gap(1:maxClusters));
% Select k largest eigenvectors
% Choose between the minimum of the maximizer of the eigengap + 10 OR
% the maximum number of clusters allowed
% This may mean that it is not feasible/practical to use maxClusters
k = min(10 + nClusters, maxClusters);
nEigVec = eigVectors(:,(size(eigVectors,1)-(k-1)): size(eigVectors,1));
% Construct the normalized matrix U from the obtained eigenvectors
U = zeros(size(nEigVec));
for i=1:size(nEigVec,1)
    n = sqrt(sum(nEigVec(i,:).^2));    
    U(i,:) = nEigVec(i,:) ./ n; 
end
% Perform Kmeans clustering on the matrix U
[IDX,C] = kmeans(U,k,'EmptyAction','singleton'); 
end

%% Calculates the affinity matrix 
function affinity = CalculateAffinity(data)
% set the parameter sigma 
sigma = 2;
% calculate pairwise euclidean distances between points using vectorized
% pdist2 function
dist = pdist2(data,data);
% determine affinity matrix
affinity = exp(-dist/(2*sigma^2));
% replace all diagonal entries with 0s
affinity(1:size(affinity,1)+1:end) = 0;
end